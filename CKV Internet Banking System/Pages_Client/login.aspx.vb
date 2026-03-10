Imports System.Data.SqlClient

Public Class login
    Inherits System.Web.UI.Page

    Private Sub BtnLoginVerify_Click(sender As Object, e As EventArgs) Handles BtnLoginVerify.Click
        Dim username As String = txtUser.Text.Trim()
        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
        Dim sql As String = "
            SELECT login_phrase FROM dbo.login
            WHERE username = @username
            AND acc_status = 'active'"
        Try
            Using connection As New SqlConnection(connectionString)
                Using loginCommand As New SqlCommand(sql, connection)
                    loginCommand.Parameters.AddWithValue("@username", username)
                    connection.Open()
                    ' Check if the login phrase retrieve is null
                    Dim result As Object = loginCommand.ExecuteScalar()
                    If result Is Nothing OrElse IsDBNull(result) Then
                        ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Invalid username. Please check your input.');", True)
                    Else
                        Dim phrase As String = result.ToString()
                        ' Store in Session
                        Session("Username") = username
                        Session("LoginPhrase") = phrase
                        ' Redirect to verification page
                        Response.Redirect("login_verification.aspx", False)
                        Context.ApplicationInstance.CompleteRequest() ' Redirect directly (don’t use client-side alert)
                    End If
                End Using
            End Using
        Catch ex As Exception
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('System Error: " & ex.Message.Replace("'", "\'") & "');", True)
        End Try
    End Sub

    Private Sub BtnCancel_Click(sender As Object, e As EventArgs) Handles BtnCancel.Click
        Response.Redirect(ResolveUrl("~/index.html"), False)
    End Sub

End Class