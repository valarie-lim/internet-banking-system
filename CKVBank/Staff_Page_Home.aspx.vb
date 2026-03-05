Public Class Staff_Page_Home
    Inherits System.Web.UI.Page

    Private Sub BtnLogin_Click(sender As Object, e As EventArgs) Handles BtnLogin.Click
        Response.Redirect("Staff_Page_Login.aspx")
    End Sub
End Class