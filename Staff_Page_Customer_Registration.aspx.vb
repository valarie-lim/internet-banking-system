Imports System.Data.SqlClient
Imports System.Drawing

Public Class Staff_Page_Customer_Registration
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Display logger name and time
            EmployeeName.Text = Session("StaffFullName")
            If Session("StaffLoginTime") IsNot Nothing Then
                ' Format the datetime as "06-Sep-2025 12:34 PM"
                LoginTimestamp.Text = Convert.ToDateTime(Session("StaffLoginTime")).ToString("dd-MMM-yyyy hh:mm tt")
            End If

            ' Display auto-generated account number and open date 
            Dim openDate As DateTime = DateTime.Now
            TxtOpenDate.Text = openDate.ToString("yyyy-MM-dd")
            Dim today As String = DateTime.Now.ToString("ddMMyy")
            Dim rnd As New Random()
            Dim randomNumber As Integer = rnd.Next(100000, 999999) ' 6-digit random number
            LblAccNo.Text = today & randomNumber.ToString() ' combine date and random number, display to the page

            ' Retrieve user input data back from the confirmation page
            If Session("FirstName") IsNot Nothing Then
                TxtFirstName.Text = Session("FirstName").ToString()
            End If
            If Session("MiddleName") IsNot Nothing Then
                TxtMiddleName.Text = Session("MiddleName").ToString()
            End If
            If Session("LastName") IsNot Nothing Then
                TxtLastName.Text = Session("LastName").ToString()
            End If
            If Session("CustomerIC") IsNot Nothing Then
                TxtCustomerIC.Text = Session("CustomerIC").ToString()
            End If
            If Session("DateOfBirth") IsNot Nothing Then
                TxtDateOfBirth.Text = Session("DateOfBirth").ToString()
            End If
            If Session("Gender") IsNot Nothing Then
                RblGender.SelectedValue = Session("Gender").ToString()
            End If
            If Session("ContactNo") IsNot Nothing Then
                TxtContactNo.Text = Session("ContactNo").ToString()
            End If
            If Session("Email") IsNot Nothing Then
                TxtEmail.Text = Session("Email").ToString()
            End If
            If Session("StreetAddress") IsNot Nothing Then
                TxtStreetAddress.Text = Session("StreetAddress").ToString()
            End If
            If Session("City") IsNot Nothing Then
                TxtCity.Text = Session("City").ToString()
            End If
            If Session("Postcode") IsNot Nothing Then
                TxtPostcode.Text = Session("Postcode").ToString()
            End If
            If Session("State") IsNot Nothing Then
                DdlState.SelectedValue = Session("State").ToString()
            End If
            If Session("AccNo") IsNot Nothing Then
                LblAccNo.Text = Session("AccNo").ToString()
            End If
            If Session("AccType") IsNot Nothing Then
                DdlAccType.SelectedValue = Session("AccType").ToString()
            End If
            If Session("AccOpenDate") IsNot Nothing Then
                TxtOpenDate.Text = Session("AccOpenDate").ToString()
            End If
            If Session("InitialDeposit") IsNot Nothing Then
                TxtInitialDeposit.Text = Session("InitialDeposit").ToString()
            End If
        End If
    End Sub

    Protected Sub CvTxtInitialDeposit_ServerValidate(source As Object, args As ServerValidateEventArgs)
        Dim deposit As Decimal

        ' Check if input is numeric
        If Decimal.TryParse(args.Value, deposit) Then
            ' Validate minimum RM20
            If deposit >= 20D Then
                args.IsValid = True
            Else
                args.IsValid = False
            End If
        Else
            ' Not a valid number
            args.IsValid = False
        End If
    End Sub

    Private Sub BtnConfirm_Click(sender As Object, e As EventArgs) Handles BtnConfirm.Click
        If Page.IsValid Then
            ' Customer details
            Session("FirstName") = TxtFirstName.Text
            Session("MiddleName") = TxtMiddleName.Text
            Session("LastName") = TxtLastName.Text
            Session("CustomerIC") = TxtCustomerIC.Text
            Session("DateOfBirth") = TxtDateOfBirth.Text
            Session("Gender") = RblGender.SelectedValue
            Session("ContactNo") = TxtContactNo.Text
            Session("Email") = TxtEmail.Text
            Session("StreetAddress") = TxtStreetAddress.Text
            Session("City") = TxtCity.Text
            Session("Postcode") = TxtPostcode.Text
            Session("State") = DdlState.SelectedValue
            ' Account details
            Session("AccNo") = LblAccNo.Text
            Session("AccType") = DdlAccType.SelectedValue
            Session("AccOpenDate") = TxtOpenDate.Text
            Dim deposit As Decimal
            If Decimal.TryParse(TxtInitialDeposit.Text, deposit) Then
                Session("InitialDeposit") = deposit
            End If
            Dim fullname As String = Session("FirstName") & " " & Session("MiddleName") & " " & Session("LastName")
            Session("AccName") = fullname.Trim()

            ' Redirect to the display page
            Response.Redirect("Staff_Page_Customer_Add_Account_Confirmation.aspx")
        End If
    End Sub

    Private Sub BtnCancel_Click(sender As Object, e As EventArgs) Handles BtnCancel.Click
        Response.Redirect("Staff_Page_Main_Menu.aspx")
    End Sub


    ' three event for the side menu button
    Private Sub BtnDashboard_Click(sender As Object, e As EventArgs) Handles BtnDashboard.Click
        Response.Redirect("Staff_Page_Main_Menu.aspx")
    End Sub

    Private Sub BtnUpdateProfile_Click(sender As Object, e As EventArgs) Handles BtnUpdateProfile.Click
        Response.Redirect("Staff_Page_Update_Profile.aspx")
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
        Response.Redirect("Staff_Page_Logout.aspx")
    End Sub


End Class