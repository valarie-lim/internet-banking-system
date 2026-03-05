Imports System.Data.SqlClient

Public Class ViewAccount
    Inherits System.Web.UI.Page

    ' Connection string from Web.config
    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CustomerName.Text = Session("FullName")
            Session("LoginTime") = DateTime.Now
            LoginTimestamp.Text = DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt")

            ' Load account details
            If Session("SelectedAccountId") IsNot Nothing Then
                Dim accountId As Integer
                If Integer.TryParse(Session("SelectedAccountId").ToString(), accountId) Then
                    LoadAccountDetails(accountId)
                End If
            Else
                Response.Redirect("Login.aspx") ' handle missing session
            End If
        End If
    End Sub

    Private Sub LoadAccountDetails(accountId As Integer)
        Dim query As String = "
        SELECT account_number, account_name, account_type, current_balance, available_balance
        FROM dbo.account
        WHERE account_id = @AccountId"

        Using connection As New SqlConnection(connectionString)
            Using loadCommand As New SqlCommand(query, connection)
                loadCommand.Parameters.Add("@AccountId", SqlDbType.Int).Value = accountId
                connection.Open()

                Using reader As SqlDataReader = loadCommand.ExecuteReader()
                    If reader.Read() Then
                        txtAccountHolder.Text = reader("account_name").ToString()
                        txtAccountType.Text = reader("account_type").ToString()
                        txtCurrentBalance.Text = String.Format("{0:N2}", reader("current_balance"))
                        txtAvailableBalance.Text = String.Format("{0:N2}", reader("available_balance"))
                        txtStatementDate.Text = DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss")
                    End If
                End Using
            End Using
        End Using
    End Sub


    'helper function for split description and references
    Protected Function GetReference(transDesc As Object) As String
        If transDesc Is Nothing Then Return ""
        Dim desc As String = transDesc.ToString()
        Dim lastDash As Integer = desc.LastIndexOf("-"c)
        If lastDash >= 0 Then
            Return desc.Substring(0, lastDash)
        End If
        Return desc
    End Function

    Protected Function GetDescription(transDescription As Object) As String
        If transDescription Is Nothing Then Return ""
        Dim desc As String = transDescription.ToString()
        Dim lastDash As Integer = desc.LastIndexOf("-"c)
        If lastDash >= 0 Then
            Return desc.Substring(lastDash + 1)
        Else
            Return ""
        End If
    End Function


    Protected Sub BtnViewStatement_Click(sender As Object, e As EventArgs) Handles BtnViewStatement.Click
        ' Keep track of which account is selected
        Dim accountId As Integer = Convert.ToInt32(Session("SelectedAccountId"))

        ' Redirect to a new page for filtering (pass accountId)
        Response.Redirect("Page_View_Statement.aspx?accountId=" & accountId)
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
