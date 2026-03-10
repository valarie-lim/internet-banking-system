Imports System.Data.SqlClient
Imports System.Security.Cryptography

Public Class login_verification
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            lblUser.Text = Session("Username")

            If Session("LoginPhrase") IsNot Nothing Then
                lblPhrase.Text = Session("LoginPhrase").ToString()
            Else
                ' If session expired or accessed directly
                Response.Redirect("login.aspx")
            End If
        End If
    End Sub

    Protected Sub RblPhraseConfirm_SelectedIndexChanged(sender As Object, e As EventArgs)
        If RblPhraseConfirm.SelectedValue = "Yes" Then
            panelPassword.Visible = True
        Else
            panelPassword.Visible = False
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert",
                                                "alert('Login abort!'); setTimeout(function(){ window.location='login.aspx'; }, 0);", True)
        End If
    End Sub

    Private Sub BtnLogin_Click(sender As Object, e As EventArgs) Handles BtnLogin.Click
        Dim pass As String = txtPass.Text.Trim()
        ' Connect and update database
        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
        Dim sql As String = "
        SELECT password_hash, failed_attempts, acc_status, login_time, user_ic
        FROM dbo.login 
        WHERE username = @username AND login_phrase = @phrase"

        Try
            Using connection As New SqlConnection(connectionString)
                Using loginCommand As New SqlCommand(sql, connection)
                    loginCommand.Parameters.AddWithValue("@username", lblUser.Text)
                    loginCommand.Parameters.AddWithValue("@phrase", lblPhrase.Text)

                    connection.Open()
                    Using reader As SqlDataReader = loginCommand.ExecuteReader()
                        reader.Read() ' move to the first row
                        Dim dbPassHash As Byte() = CType(reader("password_hash"), Byte())
                        Dim failedAttempts As Integer = If(IsDBNull(reader("failed_attempts")), 0, Convert.ToInt32(reader("failed_attempts")))
                        Dim accStatus As String = If(IsDBNull(reader("acc_status")), "active", reader("acc_status").ToString())
                        ' Store user_ic in session for use in different pages later
                        Session("UserIC") = If(IsDBNull(reader("user_ic")), Nothing, reader("user_ic").ToString())

                        reader.Close()

                        ' Check if account is locked
                        If accStatus = "locked" Then
                            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Your account is locked. Please contact the bank.');", True)
                            Exit Sub
                        End If
                        ' Compare password_hash
                        Dim enteredHash As Byte() = GetSHA256HashBytes(pass)
                        If dbPassHash.SequenceEqual(enteredHash) Then
                            ' Reset attempts when password entered match the hashed password in database
                            Dim resetSql As String = "
                                UPDATE dbo.login
                                SET failed_attempts = 0
                                WHERE username = @username"
                            Using resetCommand As New SqlCommand(resetSql, connection)
                                resetCommand.Parameters.AddWithValue("@username", lblUser.Text)
                                resetCommand.ExecuteNonQuery()
                            End Using

                            ' Update login_timestamp, retrieve and store in Session
                            Dim updateTimeSql As String = "
                                UPDATE dbo.login
                                SET login_time = @loginTime 
                                WHERE username = @username"
                            Using updateCommand As New SqlCommand(updateTimeSql, connection)
                                Dim utcNow As DateTime = DateTime.UtcNow
                                updateCommand.Parameters.AddWithValue("@loginTime", DateTime.UtcNow)
                                updateCommand.Parameters.AddWithValue("@username", lblUser.Text)
                                updateCommand.ExecuteNonQuery()

                                Dim localTime As DateTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, TimeZoneInfo.FindSystemTimeZoneById("Singapore Standard Time"))
                                Session("LoginTime") = localTime
                            End Using

                            GetCustomerInfoQuery(connectionString) 'call private sub to retrieve info and store in Session
                            ' Redirect to main menu
                            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                                                               "alert('Welcome to CKV Online Banking.'); 
                                                               window.location='main_menu.aspx';", True)
                        Else
                            failedAttempts += 1
                            If failedAttempts >= 3 Then
                                ' Lock account
                                Dim lockSql As String = "
                                    UPDATE dbo.login
                                    SET failed_attempts = @fa, acc_status = 'locked'
                                    WHERE username = @username"
                                Using lockCommand As New SqlCommand(lockSql, connection)
                                    lockCommand.Parameters.AddWithValue("@fa", failedAttempts)
                                    lockCommand.Parameters.AddWithValue("@username", lblUser.Text)
                                    lockCommand.ExecuteNonQuery()
                                End Using
                                ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Account locked after 3 failed attempts.');", True)
                            Else
                                ' Update failed attempts only
                                Dim failSql As String = "
                                    UPDATE dbo.login
                                    SET failed_attempts = @fa
                                    WHERE username = @username"
                                Using failCommand As New SqlCommand(failSql, connection)
                                    failCommand.Parameters.AddWithValue("@fa", failedAttempts)
                                    failCommand.Parameters.AddWithValue("@username", lblUser.Text)
                                    failCommand.ExecuteNonQuery()
                                End Using
                                Dim left As Integer = 3 - failedAttempts
                                ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Invalid password. You have " & left & " more chance(s).');", True)
                            End If
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('System Error: " & ex.Message.Replace("'", "\'") & "');", True)
        End Try
    End Sub

    Private Sub ForgotPass_Click(sender As Object, e As EventArgs) Handles ForgotPass.Click
        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
        GetCustomerInfoQuery(connectionString) 'call private sub to retrieve Session("Email")
        Response.Redirect("forgot_password.aspx")
    End Sub

    Private Sub GetCustomerInfoQuery(connectionString As String)
        Using connection As New SqlConnection(connectionString)
            connection.Open()

            ' Before redirect to the next page, get user fullname, contact, email from customer table
            Dim customerSql As String = "
                                SELECT c.full_name, c.contact_no, c.email
                                FROM dbo.customer c
                                INNER JOIN dbo.login l ON c.user_ic = l.user_ic
                                WHERE l.username = @username"

            Using customerCommand As New SqlCommand(customerSql, connection)
                customerCommand.Parameters.AddWithValue("@username", lblUser.Text)

                Using customerReader As SqlDataReader = customerCommand.ExecuteReader()
                    If customerReader.Read() Then
                        ' Store in session
                        Session("FullName") = customerReader("full_name").ToString()
                        Session("Phone") = customerReader("contact_no").ToString()
                        Session("Email") = customerReader("email").ToString()

                    End If
                End Using
            End Using

            ' Before redirect to the next page, get user full address from address table
            Dim addressSql As String = "
                                SELECT ca.street_address, ca.city, ca.post_code, ca.state_province, ca.country
                                FROM dbo.customerAddress ca
                                INNER JOIN dbo.login l ON ca.user_ic = l.user_ic
                                WHERE l.username = @username"

            Using addressCommand As New SqlCommand(addressSql, connection)
                addressCommand.Parameters.AddWithValue("@username", lblUser.Text)

                Using addressReader As SqlDataReader = addressCommand.ExecuteReader()
                    If addressReader.Read() Then
                        Dim parts As New List(Of String) From {
                            addressReader("street_address").ToString(),
                            addressReader("city").ToString(),
                            addressReader("post_code").ToString(),
                            addressReader("state_province").ToString(),
                            addressReader("country").ToString()
                        }
                        ' Join with commas and skip blanks
                        Session("Address") = String.Join(", ", parts.Where(Function(p) Not String.IsNullOrEmpty(p)))
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Function GetSHA256HashBytes(input As String) As Byte()
        Using sha As SHA256 = SHA256.Create()
            Return sha.ComputeHash(Encoding.UTF8.GetBytes(input))
        End Using
    End Function

End Class