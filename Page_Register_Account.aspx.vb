Public Class Page_Register_Account
    Inherits System.Web.UI.Page

    Private Sub BtnCitizen_Click(sender As Object, e As EventArgs) Handles BtnCitizen.Click
        Response.Redirect("Page_Register_Citizen.aspx")
    End Sub

    Private Sub BtnForeigner_Click(sender As Object, e As EventArgs) Handles BtnForeigner.Click
        ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('If you are a foreign customer, please contact our Customer Service at support@ckvbank.com.my to open your online account.');", True)
    End Sub
End Class