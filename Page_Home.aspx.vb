Imports System.Web.Services.Description

Public Class Page_Home
    Inherits System.Web.UI.Page

    Private Sub BtnRegister_Click(sender As Object, e As EventArgs) Handles BtnRegister.Click
        Response.Redirect("Page_Register_Account.aspx")
    End Sub

    Private Sub BtnLogin_Click(sender As Object, e As EventArgs) Handles BtnLogin.Click
        Response.Redirect("Page_Login.aspx")
    End Sub
End Class