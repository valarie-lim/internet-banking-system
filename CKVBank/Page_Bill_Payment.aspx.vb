Imports System.Data.SqlClient

Public Class Page_Bill_Payment
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CustomerName.Text = Session("FullName")
            If Session("LoginTime") IsNot Nothing Then
                ' Format the datetime as "06-Sep-2025 12:34 PM"
                LoginTimestamp.Text = Convert.ToDateTime(Session("LoginTime")).ToString("dd-MMM-yyyy hh:mm tt")
            End If
            BillPaymentDate.Attributes("min") = DateTime.Today.ToString("yyyy-MM-dd")
        End If
    End Sub

    Protected Sub BtnNext_Click(sender As Object, e As EventArgs) Handles BtnNext.Click
        If Page.IsValid Then
            ' Store values into Session
            Session("ToAccount") = DdlPaymentAccount.SelectedValue
            Session("FromAccount") = DdlUserAccount.SelectedValue
            Dim transactionsAmount As Decimal

            ' Remove "RM" if present and any extra spaces
            Dim cleanAmount As String = BillAmount.Text.Replace("RM", "").Trim()

            ' Try parsing the numeric value
            If Decimal.TryParse(cleanAmount, transactionsAmount) Then
                Session("Amount") = transactionsAmount  ' store as Decimal
            Else
                ' Optional: handle invalid input
                Session("Amount") = 0D
            End If
            Session("PaymentDate") = BillPaymentDate.Text.Trim()
            Session("Nickname") = DdlPaymentAccount.SelectedItem.Text
            ' Redirect to confirm page
            Response.Redirect("Page_Bill_Payment_Confirm.aspx")
        End If
    End Sub

    Protected Sub CvBillAmount_ServerValidate(source As Object, args As ServerValidateEventArgs)
        Dim amount As Decimal

        ' Check if input is a valid decimal number
        If Decimal.TryParse(args.Value, amount) Then
            ' Validate minimum amount
            If amount >= 10D Then
                args.IsValid = True
            Else
                args.IsValid = False
            End If
        Else
            ' Invalid number
            args.IsValid = False
        End If
    End Sub

    Protected Sub CvBillPaymentDate_ServerValidate(source As Object, args As ServerValidateEventArgs)
        Dim inputDate As DateTime

        ' Parse using exact format sent by HTML5 date input
        If DateTime.TryParseExact(args.Value, "yyyy-MM-dd",
                              System.Globalization.CultureInfo.InvariantCulture,
                              System.Globalization.DateTimeStyles.None,
                              inputDate) Then
            ' Must be strictly after today
            If inputDate.Date >= DateTime.Today Then
                args.IsValid = True
            Else
                args.IsValid = False
            End If
        Else
            args.IsValid = False
        End If
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