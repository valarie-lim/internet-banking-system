Imports System.Data.SqlClient
Imports WebGrease.Activities

Public Class Page_Bill_Payment_Confirm
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CustomerName.Text = Session("FullName")
            If Session("LoginTime") IsNot Nothing Then
                ' Format the datetime as "06-Sep-2025 12:34 PM"
                LoginTimestamp.Text = Convert.ToDateTime(Session("LoginTime")).ToString("dd-MMM-yyyy hh:mm tt")
            End If

            'load data from Page_Bill_Payment
            InputBillTo.Text = Session("Nickname")
            InputBillFrom.Text = Session("FromAccount")
            Dim amount As Decimal = CType(Session("Amount"), Decimal)
            InputBillAmount.Text = "RM " & amount.ToString("N2")
            InputBillPaymentDate.Text = Session("PaymentDate")
        End If
    End Sub

    Protected Sub BtnPayNow_Click(sender As Object, e As EventArgs) Handles BtnPayNow.Click
        ' Retrieve the connection string from Web.config
        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
        ' Establish SQL Server connection using the connection string
        Using connection As New SqlClient.SqlConnection(connectionString)
            connection.Open()

            ' Begin a transaction
            Dim transaction As SqlClient.SqlTransaction = connection.BeginTransaction()

            Try
                ' Retrieve current_balance and available_balance
                Dim fromAcc As String = Session("FromAccount")?.ToString().Trim()
                Dim toAcc As String = Session("ToAccount").ToString()
                Dim transAmount As Decimal = CType(Session("Amount"), Decimal)
                Dim selectBalanceCommand As New SqlClient.SqlCommand(
                "SELECT current_balance, available_balance
                 FROM account
                 WHERE account_number = @from_acc", connection, transaction)
                selectBalanceCommand.Parameters.AddWithValue("@from_acc", fromAcc)

                Dim currentBalance As Decimal = 0
                Dim availableBalance As Decimal = 0

                Using reader As SqlClient.SqlDataReader = selectBalanceCommand.ExecuteReader()
                    If reader.Read() Then
                        currentBalance = Convert.ToDecimal(reader("current_balance"))
                        availableBalance = Convert.ToDecimal(reader("available_balance"))
                    Else
                        Throw New Exception("Account not found.")
                    End If
                End Using

                ' Check for sufficient balance
                If currentBalance < transAmount OrElse availableBalance < transAmount Then
                    Throw New Exception("Insufficient balance.")
                End If

                ' Insert transaction into transactions table
                Dim transType As String = "debit"
                ' auto-generate transaction_id for every transaction
                Dim lastSix As String = If(fromAcc.Length >= 6, fromAcc.Substring(fromAcc.Length - 6), fromAcc)
                Dim transId As String = DateTime.Now.ToString("yyMMddHHmmss") & lastSix
                Dim transDesc As String = Session("Nickname").ToString() & "-" & transId & "-Bill Payment"
                Dim billID As String = "B" & transId
                Dim transDate As DateTime = DateTime.Now
                Dim insertCommand As New SqlClient.SqlCommand(
                "INSERT INTO transactions (trans_id, from_acc, to_acc, trans_type, trans_amount, trans_date, trans_description, bill_id) " &
                "VALUES (@tran_id, @from_acc, @to_acc, @trans_type, @trans_amount, @trans_date, @trans_description, @bill_id)", connection, transaction)


                insertCommand.Parameters.AddWithValue("@tran_id", transId)
                insertCommand.Parameters.AddWithValue("@from_acc", fromAcc)
                insertCommand.Parameters.AddWithValue("@to_acc", toAcc)
                insertCommand.Parameters.AddWithValue("@trans_type", transType)
                insertCommand.Parameters.Add("@trans_amount", SqlDbType.Decimal).Value = transAmount
                insertCommand.Parameters.AddWithValue("@trans_date", transDate)
                insertCommand.Parameters.AddWithValue("@trans_description", transDesc)
                insertCommand.Parameters.AddWithValue("@bill_id", billID)
                insertCommand.ExecuteNonQuery()

                ' Insert bill record into billPayment table
                Dim insertBillCommand As New SqlClient.SqlCommand(
                "INSERT INTO billPayment (bill_id, bill_pay_date, company_acc_no) " &
                "VALUES (@bill_id, @bill_payment_date, @company_acc_no)", connection, transaction)

                insertBillCommand.Parameters.AddWithValue("@bill_id", billID)
                insertBillCommand.Parameters.AddWithValue("@bill_payment_date", transDate)
                insertBillCommand.Parameters.AddWithValue("@company_acc_no", Session("ToAccount"))
                insertBillCommand.ExecuteNonQuery()

                ' Update balance into account table
                Dim accUpdateCommand As New SqlClient.SqlCommand(
                "UPDATE account SET current_balance = current_balance - @amount, available_balance = available_balance - @amount " &
                "WHERE account_number = @from_acc AND current_balance >= @amount AND available_balance >= @amount", connection, transaction)

                accUpdateCommand.Parameters.AddWithValue("@amount", transAmount)
                accUpdateCommand.Parameters.AddWithValue("@from_acc", fromAcc)
                Dim rowsAffected As Integer = accUpdateCommand.ExecuteNonQuery()

                If rowsAffected = 0 Then
                    Throw New Exception("Insufficient balance or concurrent transaction conflict.")
                End If

                ' Commit transaction
                transaction.Commit()

                ' Redirect to success page
                Response.Redirect("Page_Bill_Payment_Successful.aspx", False)

            Catch ex As Exception
                ' Safe rollback check
                Try
                    If transaction IsNot Nothing AndAlso transaction.Connection IsNot Nothing Then
                        transaction.Rollback()
                    End If
                Catch
                    ' Ignore rollback failure
                End Try

                Dim safeMessage As String = HttpUtility.JavaScriptStringEncode(ex.Message)
                ClientScript.RegisterStartupScript(Me.GetType(), "errorAlert",
                    "alert('Error saving data: " & safeMessage & "');", True)
            End Try
        End Using
    End Sub













    ' six event for the side menu button
    Private Sub BtnAccOverview_Click(sender As Object, e As EventArgs) Handles BtnAccOverview.Click
        Response.Redirect("Page_Main_Menu.aspx")
    End Sub

    Private Sub BtnFundTransfer_Click(sender As Object, e As EventArgs) Handles BtnFundTransfer.Click
        Response.Redirect("Page_Fund_Transfer.aspx")
    End Sub

    Private Sub BtnBillPayment_Click(sender As Object, e As EventArgs) Handles BtnBillPayment.Click
        Response.Redirect("Page_Bill_Payment.aspx")
    End Sub

    Private Sub BtnUpdateProfile_Click(sender As Object, e As EventArgs) Handles BtnUpdateProfile.Click
        Response.Redirect("Page_Update_Profile.aspx")
    End Sub

    Private Sub BtnContactUs_Click(sender As Object, e As EventArgs) Handles BtnContactUs.Click
        Response.Redirect("Page_Contact_Us.aspx")
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
        Response.Redirect("Page_Logout.aspx")
    End Sub

End Class