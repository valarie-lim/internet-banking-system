Imports System.Data.SqlClient
Imports System.Net
Imports System.Net.Mail

Public Class Staff_Page_Customer_Management
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            EmployeeName.Text = Session("StaffFullName")
            If Session("StaffLoginTime") IsNot Nothing Then
                ' Format the datetime as "06-Sep-2025 12:34 PM"
                LoginTimestamp.Text = Convert.ToDateTime(Session("StaffLoginTime")).ToString("dd-MMM-yyyy hh:mm tt")
            End If
            BtnEmailCustomer.Visible = False
        End If
    End Sub

    Private Sub BtnSearch_Click(sender As Object, e As EventArgs) Handles BtnSearch.Click
        ' Rebind GridView so SqlDataSource uses updated @full_name parameter
        GridView1.DataBind()
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles GridView1.SelectedIndexChanged
        ' Get the selected user_ic from DataKeyNames
        Dim selectedUserIC As String = GridView1.SelectedDataKey("user_ic").ToString()
        ' Store in session for later use
        Session("SelectedUserIC") = selectedUserIC

        BtnEmailCustomer.Visible = True
    End Sub

    Private Sub BtnEmailCustomer_Click(sender As Object, e As EventArgs) Handles BtnEmailCustomer.Click
        If Session("SelectedUserIC") Is Nothing Then
            ' No customer selected
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Please select a customer first.');", True)
            Return
        End If

        Dim userIC As String = Session("SelectedUserIC").ToString()
        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
        Dim email As String = ""
        Dim username As String = ""

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim sql As String = "
            SELECT c.email, l.username
            FROM customer c
            INNER JOIN login l ON c.user_ic = l.user_ic
            WHERE c.user_ic = @user_ic"
            Using command As New SqlCommand(sql, connection)
                command.Parameters.AddWithValue("@user_ic", userIC)
                Using reader As SqlDataReader = command.ExecuteReader()
                    If reader.Read() Then
                        email = reader("email").ToString()
                        username = reader("username").ToString()
                    End If
                End Using
            End Using
        End Using

        If String.IsNullOrEmpty(email) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Customer email not found.');", True)
            Return
        End If

        ' Email setup
        Dim from As String = "ckvsystem@gmail.com"
        Dim smtpUser As String = "966f9a001@smtp-brevo.com"
        Dim smtpPass As String = "ydTfGbkvHZ2KAc01"
        Dim uniqueTimestamp As String = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")

        Dim message As New MailMessage()
        message.To.Add(email)  ' use the DB email
        message.From = New MailAddress(from)
        message.Subject = "Your CKV Bank Account Has Been Reactivated – Action Required"

        ' Build reset link with query string
        Dim resetLink As String = Request.Url.GetLeftPart(UriPartial.Authority) &
                          "/Staff_Page_Customer_Reset_Pass.aspx?user=" & userIC
        Dim customerName As String = If(TryCast(Session("FullName"), String), username)
        Dim emailBody As String =
            "<html><body><!-- Unique ID: " & Guid.NewGuid().ToString() & " -->" &
            "<div style='font-family:Arial, sans-serif;'>" &
            "<p>Hi <b>" & customerName & "</b>,</p>" &
            "<p>Your account with <b>CKV Bank</b> has been successfully reactivated.</p>" &
            "<p>For security reasons, you are required to reset your password before logging in again.
                <br/>Please click the button below to reset your password:</p>" &
            "<p><a href='" & resetLink & "' " &
            "style='display:inline-block;padding:10px 20px;background-color:#007BFF;color:#fff;text-decoration:none;border-radius:5px;'>" &
            "Reset My Password</a></p>" &
            "<p>If you did not request this reactivation, please ignore this email or contact our support team immediately.</p>" &
            "<br/>" &
            "<p>Thank you,<br/>CKV Bank Support Team</p>" &
            "<hr/>" &
            "<p style='font-size:10px;color:#888;'>Email Sent On: " & uniqueTimestamp & "</p>" &
            "</div></body></html>"

        ' Use HTML for better formatting
        message.IsBodyHtml = True
        message.Body = emailBody

        ' Configure SMTP client to send emails via Brevo (3rd party email service provider company)
        Dim smtp As New SmtpClient("smtp-relay.brevo.com", 587)
        smtp.EnableSsl = True
        smtp.UseDefaultCredentials = False
        smtp.Credentials = New NetworkCredential(smtpUser, smtpPass)
        smtp.DeliveryMethod = SmtpDeliveryMethod.Network
        Try
            smtp.Send(message)
            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
            "alert('If the customer email is valid, a reset link has been sent.'); window.location='Staff_Page_Main_Menu.aspx';", True)
        Catch ex As Exception
            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
            "alert('System Error: " & ex.Message.Replace("'", "\'") & "');", True)
        End Try
    End Sub



    ' three event for the side menu button
    Private Sub BtnDashboard_Click(sender As Object, e As EventArgs) Handles BtnDashboard.Click
        Response.Redirect("Staff_Page_Main_Menu.aspx")
    End Sub

    Private Sub BtnUpdateProfile_Click(sender As Object, e As EventArgs) Handles BtnUpdateProfile.Click
        Response.Redirect("Staff_Page_Update_Profile.aspx")
    End Sub

    Private Sub BtnLogout_Click(sender As Object, e As EventArgs) Handles BtnLogout.Click
        ' Save logout timestamp in session
        Dim utcNow As DateTime = DateTime.UtcNow
        Session("StaffLogoutTime") = TimeZoneInfo.ConvertTimeFromUtc(utcNow, TimeZoneInfo.FindSystemTimeZoneById("Singapore Standard Time"))

        ' Update database
        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
        Dim updateSql As String = "
            UPDATE dbo.employeeLogin
            SET logout_time = @logoutTime
            WHERE username = @username"

        Using connection As New SqlConnection(connectionString)
            Using command As New SqlCommand(updateSql, connection)
                command.Parameters.AddWithValue("@logoutTime", utcNow)
                command.Parameters.AddWithValue("@username", Session("StaffUsername").ToString())
                connection.Open()
                command.ExecuteNonQuery()
            End Using
        End Using

        ' Redirect after update
        Response.Redirect("Staff_Page_Logout.aspx")
    End Sub


End Class