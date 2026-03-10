Imports System.Data.SqlClient

Public Class admin_profile_update_successful
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            EmployeeName.Text = Session("StaffFullName")
            If Session("StaffLoginTime") IsNot Nothing Then
                ' Format the datetime as "06-Sep-2025 12:34 PM"
                LoginTimestamp.Text = Convert.ToDateTime(Session("StaffLoginTime")).ToString("dd-MMM-yyyy hh:mm tt")
            End If
            StaffName.Text = Session("StaffFullName")
            StaffEmail.Text = Session("StaffEmail")
            StaffBirthDate.Text = Session("StaffBirthDate")
            StaffGender.Text = Session("StaffGender")
            StaffPosition.Text = Session("StaffPosition")
            If Session("EmploymentDate") IsNot Nothing Then
                ' Format the datetime as "12-Sep-2025"
                EmploymentDate.Text = Convert.ToDateTime(Session("EmploymentDate")).ToString("yyyy-MMM-dd")
            End If
        End If
    End Sub

    Private Sub BtnUpdate_Click(sender As Object, e As EventArgs) Handles BtnUpdate.Click
        If Page.IsValid Then
            ' Retrieve the connection string from Web.config
            Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim transaction As SqlTransaction = connection.BeginTransaction()

                ' Database transaction error handling
                Try
                    ' Update new contact_no into customer Table
                    Dim phoneQuery As String = "
                UPDATE e
                SET e.contact_no = @contact_no
                FROM dbo.employee e
                INNER Join dbo.employeeLogin el ON e.staff_ic = el.staff_ic
                WHERE el.username = @username"

                    Using updateCommand As New SqlCommand(phoneQuery, connection, transaction)
                        updateCommand.Parameters.AddWithValue("@contact_no", txtUpdatePhone.Text.Trim())
                        updateCommand.Parameters.AddWithValue("@username", Session("StaffUsername"))

                        updateCommand.ExecuteNonQuery()

                        Session("StaffPhone") = txtUpdatePhone.Text
                        ' Commit inserts
                        transaction.Commit()

                        ' Show alert and redirect to Page_Update_Profile.aspx
                        Dim script As String = "alert('Contact Number updated successfully!'); window.location='admin_profile_update.aspx';"
                        If ScriptManager.GetCurrent(Page) IsNot Nothing Then
                            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertRedirect", script, True)
                        Else
                            ClientScript.RegisterStartupScript(Me.GetType(), "alertRedirect", script, True)
                        End If
                    End Using

                Catch ex As Exception
                    transaction.Rollback()
                    ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('System Error: " & ex.Message.Replace("'", "\'") & "');", True)
                End Try
            End Using
        End If
    End Sub

    Private Sub BtnCancel_Click(sender As Object, e As EventArgs) Handles BtnCancel.Click
        Response.Redirect("admin_profile_update.aspx")
    End Sub


    ' three event for the side menu button
    Private Sub BtnDashboard_Click(sender As Object, e As EventArgs) Handles BtnDashboard.Click
        Response.Redirect("admin_main_menu.aspx")
    End Sub

    Private Sub BtnUpdateProfile_Click(sender As Object, e As EventArgs) Handles BtnUpdateProfile.Click
        Response.Redirect("admin_profile_update.aspx")
    End Sub

    Private Sub BtnLogout_Click(sender As Object, e As EventArgs) Handles BtnLogout.Click
        ' Save logout timestamp in session
        Dim utcNow As DateTime = DateTime.UtcNow
        Session("StaffLogoutTime") = TimeZoneInfo.ConvertTimeFromUtc(utcNow, TimeZoneInfo.FindSystemTimeZoneById("Singapore Standard Time"))

        ' Update database
        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
        Dim updateSql As String = "
            UPDATE dbo.employeeLogin
            SET logout_time = @logoutTime
            WHERE username = @username"

        Using connection As New SqlConnection(connectionString)
            Using command As New SqlCommand(updateSql, connection)
                command.Parameters.AddWithValue("@logoutTime", utcNow)
                command.Parameters.AddWithValue("@username", Session("StaffUsername").ToString())
                connection.Open()
                command.ExecuteNonQuery()
            End Using
        End Using

        ' Redirect after update
        Response.Redirect("admin_logout.aspx")
    End Sub
End Class