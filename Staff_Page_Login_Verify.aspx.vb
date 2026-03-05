Imports System.Data.SqlClient
Imports System.Security.Cryptography

Public Class Staff_Page_Login_Verify
    Inherits System.Web.UI.Page


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            lblUser.Text = Session("StaffUsername")

            If Session("StaffLoginPhrase") IsNot Nothing Then
                lblPhrase.Text = Session("StaffLoginPhrase").ToString()
            Else
                ' If session expired or accessed directly
                Response.Redirect("Staff_Page_Login.aspx")
            End If
        End If
    End Sub

    Protected Sub RblPhraseConfirm_SelectedIndexChanged(sender As Object, e As EventArgs)
        If RblPhraseConfirm.SelectedValue = "Yes" Then
            panelPassword.Visible = True
        Else
            panelPassword.Visible = False
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('Login abort!'); setTimeout(function(){ window.location='Staff_Page_Login.aspx'; }, 0);", True)
        End If
    End Sub

    Private Sub BtnLogin_Click(sender As Object, e As EventArgs) Handles BtnLogin.Click
        Dim pass As String = txtPass.Text.Trim()

        ' Connect and update database
        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
        Dim sql As String = "
        SELECT password_hash, failed_attempts, admin_status, login_time, staff_ic
        FROM dbo.employeeLogin 
        WHERE username = @username AND login_phrase = @phrase"

        Try
            Using connection As New SqlConnection(connectionString)
                Using loginCommand As New SqlCommand(sql, connection)
                    loginCommand.Parameters.AddWithValue("@username", lblUser.Text)
                    loginCommand.Parameters.AddWithValue("@phrase", lblPhrase.Text)

                    connection.Open()

                    Using reader As SqlDataReader = loginCommand.ExecuteReader()
                        If Not reader.Read() Then
                            ' User not found or wrong phrase
                            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Invalid login attempt.');", True)
                            Exit Sub
                        End If

                        Dim dbPassHash As Byte() = CType(reader("password_hash"), Byte())
                        Dim failedAttempts As Integer = If(IsDBNull(reader("failed_attempts")), 0, Convert.ToInt32(reader("failed_attempts")))
                        Dim adminStatus As String = If(IsDBNull(reader("admin_status")), "active", reader("admin_status").ToString())
                        ' Store login_time and user_ic in session
                        Session("StaffLoginTime") = If(IsDBNull(reader("login_time")), Nothing, Convert.ToDateTime(reader("login_time")))
                        Session("StaffIC") = If(IsDBNull(reader("staff_ic")), Nothing, reader("staff_ic").ToString())

                        reader.Close()

                        ' Check if account is locked
                        If adminStatus = "locked" Then
                            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Your account is locked. Please contact the IT department to reactivate it.');", True)
                            Exit Sub
                        End If

                        ' Compare password_hash
                        Dim enteredHash As Byte() = GetSHA256HashBytes(pass)
                        If dbPassHash.SequenceEqual(enteredHash) Then
                            ' Reset attempts when password entered match the hashed password in database
                            Dim resetSql As String = "
                                UPDATE dbo.employeeLogin
                                SET failed_attempts = 0
                                WHERE username = @username"
                            Using resetCommand As New SqlCommand(resetSql, connection)
                                resetCommand.Parameters.AddWithValue("@username", lblUser.Text)
                                resetCommand.ExecuteNonQuery()
                            End Using

                            ' Update login_timestamp, retrieve and store in Session
                            Dim updateTimeSql As String = "
                                UPDATE dbo.employeeLogin
                                SET login_time = @loginTime 
                                WHERE username = @username"
                            Using updateCommand As New SqlCommand(updateTimeSql, connection)
                                Dim utcNow As DateTime = DateTime.UtcNow
                                updateCommand.Parameters.AddWithValue("@loginTime", DateTime.UtcNow)
                                updateCommand.Parameters.AddWithValue("@username", lblUser.Text)
                                updateCommand.ExecuteNonQuery()

                                Dim localTime As DateTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, TimeZoneInfo.FindSystemTimeZoneById("Singapore Standard Time"))
                                Session("StaffLoginTime") = localTime
                            End Using

                            GetEmployeeInfoQuery(connectionString) 'call private sub to retrieve info and store in Session
                            ' Redirect to main menu
                            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Welcome to CKV Bank Management System.'); window.location='Staff_Page_Main_Menu.aspx';", True)

                        Else
                            failedAttempts += 1

                            If failedAttempts >= 3 Then
                                ' Lock account
                                Dim lockSql As String = "
                                    UPDATE dbo.employeeLogin
                                    SET failed_attempts = @fa, admin_status = 'locked'
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
                                    UPDATE dbo.employeeLogin
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

    'Private Sub ForgotPass_Click(sender As Object, e As EventArgs) Handles ForgotPass.Click
    '    Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
    '    GetEmployeeInfoQuery(connectionString) 'call private sub to retrieve Session("Email")
    '    Response.Redirect("Staff_Page_Forgot_Pass.aspx")
    'End Sub

    Private Sub GetEmployeeInfoQuery(connectionString As String)
        Using connection As New SqlConnection(connectionString)
            connection.Open()

            ' Before redirect to the next page, get user fullname, contact, email from employee table
            Dim employeeSql As String = "
                                SELECT e.full_name, e.contact_no, e.email, e.dob, e.gender, e.employ_date, el.position
                                FROM dbo.employee e
                                INNER JOIN dbo.employeeLogin el ON e.staff_ic = el.staff_ic
                                WHERE el.username = @username"

            Using employeeCommand As New SqlCommand(employeeSql, connection)
                employeeCommand.Parameters.AddWithValue("@username", lblUser.Text)

                Using employeeReader As SqlDataReader = employeeCommand.ExecuteReader()
                    If employeeReader.Read() Then
                        ' Store in session
                        Session("StaffFullName") = employeeReader("full_name").ToString()
                        Session("StaffEmail") = employeeReader("email").ToString()
                        Session("StaffPhone") = employeeReader("contact_no").ToString()
                        Session("StaffBirthDate") = Convert.ToDateTime(employeeReader("dob")).ToString("yyyy-MM-dd")
                        Session("StaffGender") = employeeReader("gender").ToString()
                        Session("StaffPosition") = employeeReader("position").ToString()
                        Session("EmploymentDate") = Convert.ToDateTime(employeeReader("employ_date")).ToString("yyyy-MM-dd")

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