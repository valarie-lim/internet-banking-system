Imports System.Data
Imports System.Data.SqlClient
Imports System.Security.Cryptography

Public Class Page_Forgot_Pass_Reset
    Inherits System.Web.UI.Page

    Private Sub BtnResetPass_Click(sender As Object, e As EventArgs) Handles BtnResetPass.Click
        If Page.IsValid Then
            ' Retrieve the connection string from Web.config
            Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString

            ' Hash the password into VARBINARY
            Dim passHash As Byte()
            Using sha256 As SHA256 = SHA256.Create()
                passHash = sha256.ComputeHash(Encoding.UTF8.GetBytes(TxtNewPass.Text))
            End Using

            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim transaction As SqlTransaction = connection.BeginTransaction()

                ' Database transaction error handling
                Try
                    ' Update new password into Login Table
                    Dim passwordQuery As String = "
                UPDATE dbo.login
                SET password_hash = @password_hash
                WHERE username = @username;"

                    Using resetCommand As New SqlCommand(passwordQuery, connection, transaction)
                        resetCommand.Parameters.Add("@password_hash", SqlDbType.VarBinary, 64).Value = passHash
                        resetCommand.Parameters.AddWithValue("@username", Session("Username"))

                        Dim rowsAffected As Integer = resetCommand.ExecuteNonQuery()

                        If rowsAffected > 0 Then
                            ' Commit inserts
                            transaction.Commit()

                            ' Redirect to reset confirmation page
                            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                                                               "alert('Password reset successful! You can now log in with your new password.');
                                                               window.location='Page_Login.aspx';", True)
                        End If
                    End Using

                Catch ex As Exception
                    transaction.Rollback()
                    ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('System Error: " & ex.Message.Replace("'", "\'") & "');", True)
                End Try
            End Using
        End If
    End Sub
End Class