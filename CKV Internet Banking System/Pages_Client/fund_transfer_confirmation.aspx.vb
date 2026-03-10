Imports System.Data.SqlClient

Public Class fund_transfer_confirmation
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CustomerName.Text = Session("FullName")
            If Session("LoginTime") IsNot Nothing Then
                ' Format the datetime as "06-Sep-2025 12:34 PM"
                LoginTimestamp.Text = Convert.ToDateTime(Session("LoginTime")).ToString("dd-MMM-yyyy hh:mm tt")
            End If

            'load data from Page_Bill_Payment
            InputTransferTo.Text = Session("ToAccount")
            InputTransferFrom.Text = Session("FromAccount")
            Dim amount As Decimal = CType(Session("Amount"), Decimal)
            InputTransferAmount.Text = "RM " & amount.ToString("N2")
            InputTransferPaymentDate.Text = Session("PaymentDate")
            InputTransDescription.Text = Session("TransDescription")
        End If
    End Sub

    Protected Sub BtnTransferNow_Click(sender As Object, e As EventArgs) Handles BtnTransferNow.Click
        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString

        Using connection As New SqlClient.SqlConnection(connectionString)
            connection.Open()
            Dim transaction As SqlClient.SqlTransaction = connection.BeginTransaction()

            Try
                ' --- Retrieve session data ---
                Dim fromAcc As String = Session("FromAccount")?.ToString().Trim()
                Dim toAcc As String = Session("ToAccount")?.ToString().Trim()
                Dim transAmount As Decimal = CType(Session("Amount"), Decimal)
                Dim transDescInput As String = If(String.IsNullOrWhiteSpace(InputTransDescription.Text), "", InputTransDescription.Text)

                ' --- Retrieve sender's balance ---
                Dim selectBalanceCmd As New SqlClient.SqlCommand(
                    "SELECT current_balance, available_balance FROM account WHERE account_number = @from_acc", connection, transaction)
                selectBalanceCmd.Parameters.AddWithValue("@from_acc", fromAcc)

                Dim currentBalance As Decimal = 0
                Dim availableBalance As Decimal = 0
                Using reader As SqlClient.SqlDataReader = selectBalanceCmd.ExecuteReader()
                    If reader.Read() Then
                        currentBalance = Convert.ToDecimal(reader("current_balance"))
                        availableBalance = Convert.ToDecimal(reader("available_balance"))
                    Else
                        Throw New Exception("Sender account not found.")
                    End If
                End Using

                ' --- Check sufficient balance ---
                If currentBalance < transAmount OrElse availableBalance < transAmount Then
                    Throw New Exception("Insufficient balance.")
                End If

                ' --- Generate base transaction ID ---
                Dim lastSix As String = If(fromAcc.Length >= 6, fromAcc.Substring(fromAcc.Length - 6), fromAcc)
                Dim baseTransId As String = DateTime.Now.ToString("yyMMddHHmmss") & lastSix
                Dim transDate As DateTime = DateTime.Now

                ' --- Insert DEBIT transaction for sender ---
                Dim debitTransId As String = baseTransId & "D"
                Dim insertDebitCmd As New SqlClient.SqlCommand(
                    "INSERT INTO transactions (trans_id, from_acc, to_acc, trans_type, trans_amount, trans_date, trans_description, bill_id) " &
                    "VALUES (@trans_id, @from_acc, @to_acc, 'DEBIT', @amount, @trans_date, @description, NULL)", connection, transaction)
                insertDebitCmd.Parameters.AddWithValue("@trans_id", debitTransId)
                insertDebitCmd.Parameters.AddWithValue("@from_acc", fromAcc)
                insertDebitCmd.Parameters.AddWithValue("@to_acc", toAcc)
                insertDebitCmd.Parameters.AddWithValue("@amount", transAmount)
                insertDebitCmd.Parameters.AddWithValue("@trans_date", transDate)
                insertDebitCmd.Parameters.AddWithValue("@description", "TXF Debit-" & debitTransId & "-" & transDescInput)
                insertDebitCmd.ExecuteNonQuery()

                ' --- Update sender's balance ---
                Dim updateFromCmd As New SqlClient.SqlCommand(
                    "UPDATE account SET current_balance = current_balance - @amount, available_balance = available_balance - @amount " &
                    "WHERE account_number = @from_acc AND current_balance >= @amount AND available_balance >= @amount", connection, transaction)
                updateFromCmd.Parameters.AddWithValue("@amount", transAmount)
                updateFromCmd.Parameters.AddWithValue("@from_acc", fromAcc)
                If updateFromCmd.ExecuteNonQuery() = 0 Then Throw New Exception("Insufficient balance or concurrent conflict.")

                ' --- Check if recipient is internal ---
                Dim isInternal As Boolean = False
                Dim checkAccCmd As New SqlClient.SqlCommand(
                    "SELECT COUNT(*) FROM account WHERE account_number = @to_acc", connection, transaction)
                checkAccCmd.Parameters.AddWithValue("@to_acc", toAcc)
                Dim count As Integer = Convert.ToInt32(checkAccCmd.ExecuteScalar())
                If count > 0 Then isInternal = True

                ' --- If internal, update recipient's balance ---
                If isInternal Then
                    Dim updateToCmd As New SqlClient.SqlCommand(
                        "UPDATE account SET current_balance = current_balance + @amount, available_balance = available_balance + @amount " &
                        "WHERE account_number = @to_acc", connection, transaction)
                    updateToCmd.Parameters.AddWithValue("@amount", transAmount)
                    updateToCmd.Parameters.AddWithValue("@to_acc", toAcc)
                    updateToCmd.ExecuteNonQuery()
                End If

                ' --- Log CREDIT transaction for recipient ---
                Dim creditTransId As String = baseTransId & If(isInternal, "C", "E")
                Dim logToCmd As New SqlClient.SqlCommand(
                    "INSERT INTO transactions (trans_id, from_acc, to_acc, trans_type, trans_amount, trans_date, trans_description) " &
                    "VALUES (@trans_id, @from_acc, @to_acc, 'CREDIT', @amount, @trans_date, @description)", connection, transaction)
                logToCmd.Parameters.AddWithValue("@trans_id", creditTransId)
                logToCmd.Parameters.AddWithValue("@from_acc", fromAcc)
                logToCmd.Parameters.AddWithValue("@to_acc", toAcc)
                logToCmd.Parameters.AddWithValue("@amount", transAmount)
                logToCmd.Parameters.AddWithValue("@trans_date", transDate)
                logToCmd.Parameters.AddWithValue("@description", "TXF Credit-" & creditTransId & "-" & transDescInput)
                logToCmd.ExecuteNonQuery()

                ' --- Commit transaction ---
                transaction.Commit()

                ' --- Redirect to success page ---
                Response.Redirect("fund_transfer_successful.aspx", False)

            Catch ex As Exception
                Try
                    If transaction IsNot Nothing AndAlso transaction.Connection IsNot Nothing Then
                        transaction.Rollback()
                    End If
                Catch
                End Try

                Dim safeMessage As String = HttpUtility.JavaScriptStringEncode(ex.Message)
                ClientScript.RegisterStartupScript(Me.GetType(), "errorAlert",
                "alert('Error saving data: " & safeMessage & "');", True)
            End Try
        End Using
    End Sub

    ' six event for the side menu button

    Private Sub BtnAccOverview_Click(sender As Object, e As EventArgs) Handles BtnAccOverview.Click
        Response.Redirect("main_menu.aspx")
    End Sub

    Private Sub BtnFundTransfer_Click(sender As Object, e As EventArgs) Handles BtnFundTransfer.Click
        Response.Redirect("fund_transfer.aspx")
    End Sub

    Private Sub BtnBillPayment_Click(sender As Object, e As EventArgs) Handles BtnBillPayment.Click
        Response.Redirect("bill_payment.aspx")
    End Sub

    Private Sub BtnUpdateProfile_Click(sender As Object, e As EventArgs) Handles BtnUpdateProfile.Click
        Response.Redirect("profile_update.aspx")
    End Sub

    Private Sub BtnContactUs_Click(sender As Object, e As EventArgs) Handles BtnContactUs.Click
        Response.Redirect("contact_us.aspx")
    End Sub

    Private Sub BtnLogout_Click(sender As Object, e As EventArgs) Handles BtnLogout.Click
        ' Save logout timestamp in session
        Dim utcNow As DateTime = DateTime.UtcNow
        Session("LogoutTime") = TimeZoneInfo.ConvertTimeFromUtc(utcNow, TimeZoneInfo.FindSystemTimeZoneById("Singapore Standard Time"))
        ' Update database
        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
        Dim updateSql As String = "
            UPDATE dbo.login
            SET logout_time = @logoutTime
            WHERE username = @username"
        Using connection As New SqlConnection(connectionString)
            Using command As New SqlCommand(updateSql, connection)
                command.Parameters.AddWithValue("@logoutTime", utcNow)
                command.Parameters.AddWithValue("@username", Session("Username").ToString())
                connection.Open()
                command.ExecuteNonQuery()
            End Using
        End Using
        ' Redirect after update
        Response.Redirect("logout.aspx")
    End Sub

End Class