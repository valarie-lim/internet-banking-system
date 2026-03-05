Imports System.Data.SqlClient

Public Class Page_Update_Details
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CustomerName.Text = Session("FullName")
            If Session("LoginTime") IsNot Nothing Then
                ' Format the datetime as "06-Sep-2025 12:34 PM"
                LoginTimestamp.Text = Convert.ToDateTime(Session("LoginTime")).ToString("dd-MMM-yyyy hh:mm tt")
            End If
            CustName.Text = Session("FullName")
            CustPhone.Text = Session("Phone")
            CustAddress.Text = Session("Address")
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
                    ' Update new email into customer Table
                    Dim emailQuery As String = "
                        UPDATE c
                        SET c.email = @email
                        FROM dbo.customer c
                        INNER Join dbo.login l ON c.user_ic = l.user_ic
                        WHERE l.username = @username"

                    Using updateCommand As New SqlCommand(emailQuery, connection, transaction)
                        updateCommand.Parameters.AddWithValue("@email", txtUpdateEmail.Text.Trim())
                        updateCommand.Parameters.AddWithValue("@username", Session("Username"))

                        updateCommand.ExecuteNonQuery()

                        Session("Email") = txtUpdateEmail.Text
                        ' Commit inserts
                        transaction.Commit()

                        ' Show alert and redirect to Page_Update_Profile.aspx
                        Dim script As String = "alert('Email updated successfully!'); window.location='Page_Update_Profile.aspx';"
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
        Response.Redirect("Page_Update_Profile.aspx")
    End Sub

    ' six event for the side menu button
    Private Sub BtnAccOverview_Click(sender As Object, e As EventArgs) Handles BtnAccOverview.Click
        Response.Redirect("Page_Main_Menu.aspx")
    End Sub

    Private Sub BtnFundTransfer_Click(sender As Object, e As EventArgs) Handles BtnFundTransfer.Click
        Response.Redirect("Page_Fund_Transfer.aspx")
    End Sub

    Private Sub BtnBillPayment_Click(sender As Object, e As EventArgs) Handles BtnBillPayment.Click
        Response.Redirect("Page_Bill_Payment.aspx")
    End Sub

    Private Sub BtnUpdateProfile_Click(sender As Object, e As EventArgs) Handles BtnUpdateProfile.Click
        Response.Redirect("Page_Update_Profile.aspx")
    End Sub

    Private Sub BtnContactUs_Click(sender As Object, e As EventArgs) Handles BtnContactUs.Click
        Response.Redirect("Page_Contact_Us.aspx")
    End Sub

    Private Sub BtnLogout_Click(sender As Object, e As EventArgs) Handles BtnLogout.Click
        ' Save logout timestamp in session
        Dim utcNow As DateTime = DateTime.UtcNow
        Session("LogoutTime") = TimeZoneInfo.ConvertTimeFromUtc(utcNow, TimeZoneInfo.FindSystemTimeZoneById("Singapore Standard Time"))

        ' Update database
        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
        Dim updateSql As String = "
            UPDATE dbo.login
            SET logout_time = @logoutTime
            WHERE username = @username"

        Using connection As New SqlConnection(connectionString)
            Using command As New SqlCommand(updateSql, connection)
                command.Parameters.AddWithValue("@logoutTime", utcNow)
                command.Parameters.AddWithValue("@username", Session("Username").ToString())
                connection.Open()
                command.ExecuteNonQuery()
            End Using
        End Using

        ' Redirect after update
        Response.Redirect("Page_Logout.aspx")
    End Sub

End Class