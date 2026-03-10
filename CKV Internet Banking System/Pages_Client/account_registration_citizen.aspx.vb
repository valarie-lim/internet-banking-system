Imports System.Data.SqlClient

Public Class account_registration_citizen
    Inherits System.Web.UI.Page

    Private Sub BtnVerifyIC_Click(sender As Object, e As EventArgs) Handles BtnVerifyIC.Click
        If Page.IsValid Then
            Dim userIC As String = TxtCustomerIC.Text.Trim()

            Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
            Dim sql As String = "
            SELECT user_ic 
            FROM dbo.login 
            WHERE acc_status = 'new' AND user_ic = @userIC"
            Try
                Using connection As New SqlConnection(connectionString)
                    Using command As New SqlCommand(sql, connection)
                        command.Parameters.AddWithValue("@userIC", userIC)
                        connection.Open()

                        Dim result As Object = command.ExecuteScalar()

                        If result Is Nothing OrElse IsDBNull(result) Then
                            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Invalid IC. Please check again or contact the bank.');", True)
                            Exit Sub
                        Else
                            ' Store in Session
                            Session("UserIC") = result.ToString()
                        End If
                    End Using
                End Using
            Catch ex As Exception
                ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('System Error: " & ex.Message.Replace("'", "\'") & "');", True)
            End Try

            ' Redirect to verification page
            Response.Redirect("account_registration_submit.aspx", False)
            Context.ApplicationInstance.CompleteRequest()
        End If
    End Sub

    Private Sub BtnCancel_Click(sender As Object, e As EventArgs) Handles BtnCancel.Click
        Response.Redirect(ResolveUrl("~/index.html"), False)
    End Sub

End Class