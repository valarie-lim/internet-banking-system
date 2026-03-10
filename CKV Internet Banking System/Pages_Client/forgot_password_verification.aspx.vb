Public Class forgot_password_verification
    Inherits System.Web.UI.Page

    Private Sub BtnVerifyCode_Click(sender As Object, e As EventArgs) Handles BtnVerifyCode.Click
        If Page.IsValid Then
            If TxtVerifyCode.Text.Equals(Session("ResetCode")) Then
                Response.Redirect("password_reset.aspx")
            Else
                ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Wrong code!');", True)
            End If
        End If
    End Sub

End Class