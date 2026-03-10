Public Class account_registration
    Inherits System.Web.UI.Page

    Private Sub BtnCitizen_Click(sender As Object, e As EventArgs) Handles BtnCitizen.Click
        Response.Redirect("account_registration_citizen.aspx")
    End Sub

    Private Sub BtnForeigner_Click(sender As Object, e As EventArgs) Handles BtnForeigner.Click
        ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('If you are a foreign customer, please contact our Customer Service at support@ckvbank.com to assist you with your online account registration.');", True)
    End Sub

End Class