Imports System.Data.SqlClient

Public Class Staff_Page_Customer_Reset_Pass
    Inherits System.Web.UI.Page

    Private Sub BtnNext_Click(sender As Object, e As EventArgs) Handles BtnNext.Click
        Dim username As String = txtUser.Text.Trim()
        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
        Dim sql As String = "
            SELECT c.full_name, c.email, l.username
            FROM dbo.customer c
            INNER JOIN dbo.login l ON c.user_ic = l.user_ic
            WHERE l.username = @username
            AND l.acc_status = 'active'"
        Try
            Using connection As New SqlConnection(connectionString)
                Using loginCommand As New SqlCommand(sql, connection)
                    loginCommand.Parameters.AddWithValue("@username", username)
                    connection.Open()

                    Using reader As SqlDataReader = loginCommand.ExecuteReader()
                        If reader.Read() Then
                            Dim email As String = reader("email").ToString()
                            Dim foundUsername As String = reader("username").ToString()
                            Dim fullname As String = reader("full_name").ToString()
                            ' Store in Session
                            Session("Username") = foundUsername
                            Session("Email") = email
                            Session("FullName") = fullname
                            ' Redirect to the Forgot Password page to verify email and code before proceeding to the Password Reset page.
                            Response.Redirect("Page_Forgot_Pass.aspx", False)
                            Context.ApplicationInstance.CompleteRequest()
                        Else
                            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Invalid username. Please check your input.');", True)
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            ' Friendlier alert for the user, but log the full error internally
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('System error. Please try again later.');", True)
        End Try
    End Sub
End Class


