Imports System.Data.SqlClient

Public Class admin_profile_update
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
            StaffPhone.Text = Session("StaffPhone")
            StaffBirthDate.Text = Session("StaffBirthDate")
            StaffGender.Text = Session("StaffGender")
            StaffPosition.Text = Session("StaffPosition")
            If Session("EmploymentDate") IsNot Nothing Then
                ' Format the datetime as "2026-Sep-12"
                EmploymentDate.Text = Convert.ToDateTime(Session("EmploymentDate")).ToString("yyyy-MM-dd")
            End If
        End If
    End Sub

    Private Sub BtnModify_Click(sender As Object, e As EventArgs) Handles BtnModify.Click
        Response.Redirect("admin_profile_update_successful.aspx")
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