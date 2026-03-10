Imports System.Net
Imports System.Net.Mail

Public Class forgot_password
    Inherits System.Web.UI.Page

    Public Shared toUser As String


    Private Sub BtnSendCode_Click(sender As Object, e As EventArgs) Handles BtnSendCode.Click
        ' Check if user email input is same as database email
        Dim userEmail As String = TxtSendCode.Text.Trim()
        If userEmail <> Session("Email") Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Email not found. Please check again.');", True)
            Exit Sub
        End If

        Dim randomCode As String
        Dim rand As New Random()
        randomCode = (rand.Next(999999)).ToString("D6")
        Session("ResetCode") = randomCode

        Dim from As String = "ckvsystem@gmail.com"
        Dim smtpUser As String = "966f9a001@smtp-brevo.com"
        Dim smtpPass As String = "ydTfGbkvHZ2KAc01"

        Dim message As New MailMessage()
        toUser = TxtSendCode.Text
        message.To.Add(toUser)
        message.From = New MailAddress(from)
        message.Subject = "CKV Bank - Password Reset Request"

        message.IsBodyHtml = True
        message.Body =
            "<html>" &
            "<body style='font-family:Arial, sans-serif;'>" &
            "<p>Hi <b>" & Session("FullName") & "</b>,</p>" &
            "<p>Your <b>verification code</b> is: <b>" & randomCode & "</b> </p>" &
            "<p>If you did not request this, please ignore this email or contact our support team immediately.</p>" &
            "<br/>" &
            "<p>Thank you,<br/>CKV Bank Support Team</p>" &
            "</body>" &
            "</html>"

        Dim smtp As New SmtpClient("smtp-relay.brevo.com", 587)
        smtp.EnableSsl = True
        smtp.UseDefaultCredentials = False
        smtp.Credentials = New NetworkCredential(smtpUser, smtpPass)
        smtp.DeliveryMethod = SmtpDeliveryMethod.Network

        Try
            smtp.Send(message)
            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                "alert('If the email address is registered for this account, you will receive a verification code.'); window.location='forgot_password_verification.aspx';", True)
        Catch ex As Exception
            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                "alert('System Error: " & ex.Message.Replace("'", "\'") & "');", True)
        End Try
    End Sub

    Private Sub BtnCancel_Click(sender As Object, e As EventArgs) Handles BtnCancel.Click
        Response.Redirect("login_verification.aspx")
    End Sub
End Class