Imports System.Data.SqlClient

Public Class Staff_Page_Login
    Inherits System.Web.UI.Page

    Private Sub BtnLoginVerify_Click(sender As Object, e As EventArgs) Handles BtnLoginVerify.Click
        Dim username As String = txtUser.Text.Trim()

        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
        Dim sql As String = "
            SELECT login_phrase
            FROM dbo.employeeLogin
            WHERE username = @username AND admin_status = 'active'"
        Try
            Using connection As New SqlConnection(connectionString)
                Using loginCommand As New SqlCommand(sql, connection)
                    loginCommand.Parameters.AddWithValue("@username", username)
                    connection.Open()

                    Dim result As Object = loginCommand.ExecuteScalar()

                    If result Is Nothing OrElse IsDBNull(result) Then
                        ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Invalid username. Please check your input.');", True)
                    Else
                        Dim phrase As String = result.ToString()

                        ' Store in Session
                        Session("StaffUsername") = username
                        Session("StaffLoginPhrase") = phrase

                        ' Redirect to verification page
                        Response.Redirect("Staff_Page_Login_Verify.aspx", False)
                        Context.ApplicationInstance.CompleteRequest() ' Redirect directly (don’t use client-side alert)
                    End If
                End Using
            End Using
        Catch ex As Exception
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('System Error: " & ex.Message.Replace("'", "\'") & "');", True)
        End Try
    End Sub
End Class