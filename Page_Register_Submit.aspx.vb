Imports System.Data.SqlClient
Imports System.Security.Cryptography

Public Class Page_Register_Submit
    Inherits System.Web.UI.Page

    Private Sub BtnSubmit_Click(sender As Object, e As EventArgs) Handles BtnSubmit.Click
        ' Retrieve the connection string from Web.config
        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
        ' Establish SQL Server connection using the connection string
        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim transaction As SqlTransaction = connection.BeginTransaction()
            ' Database transaction error handling
            Try
                Dim userIC As String = Session("UserIC").ToString()
                Dim rawPassword As String = TxtPass.Text.Trim()
                Dim hashedPassword As Byte() = ComputeSha256HashBytes(rawPassword)
                Dim sql As String = "
                    UPDATE dbo.login
                    SET username = @Username,
                        password_hash = @Password,
                        login_phrase = @LoginPhrase,
                        acc_status = @AccStatus
                    WHERE user_ic = @UserIC"

                Using command As New SqlCommand(sql, connection, transaction)
                    command.Parameters.AddWithValue("@Username", TxtUsername.Text.Trim())
                    command.Parameters.Add("@Password", SqlDbType.VarBinary, 64).Value = hashedPassword
                    command.Parameters.AddWithValue("@LoginPhrase", TxtLoginPhrase.Text.Trim())
                    command.Parameters.AddWithValue("@AccStatus", "active")
                    command.Parameters.AddWithValue("@UserIC", userIC)
                    command.ExecuteNonQuery()
                End Using

                transaction.Commit()
                ClientScript.RegisterStartupScript(Me.GetType(), "alertRedirect",
                    "alert('You online account has been successfully created. You can login now.'); window.location='Page_Login.aspx';", True)
            Catch ex As Exception
                ' Attempt rollback inside nested Try...Catch to avoid errors if rollback fails
                Try
                    If transaction IsNot Nothing AndAlso transaction.Connection IsNot Nothing Then
                        transaction.Rollback()
                    End If
                Catch
                    ' Ignore rollback failure
                End Try

                Dim safeMessage As String = HttpUtility.JavaScriptStringEncode(ex.Message)
                ClientScript.RegisterStartupScript(Me.GetType(), "errorAlert", "alert('Error saving data: " & safeMessage & "');", True)
            End Try
        End Using
    End Sub

    Private Function ComputeSha256HashBytes(rawData As String) As Byte()
        Using sha256 As SHA256 = SHA256.Create()
            Return sha256.ComputeHash(Encoding.UTF8.GetBytes(rawData))
        End Using
    End Function
End Class