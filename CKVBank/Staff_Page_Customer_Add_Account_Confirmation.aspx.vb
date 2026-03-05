Imports System.Data.SqlClient

Public Class Staff_Page_Customer_Add_Account_Confirmation
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            EmployeeName.Text = Session("StaffFullName")
            If Session("StaffLoginTime") IsNot Nothing Then
                ' Format the datetime as "06-Sep-2025 12:34 PM"
                LoginTimestamp.Text = Convert.ToDateTime(Session("StaffLoginTime")).ToString("dd-MMM-yyyy hh:mm tt")
            End If

            ' Retrieve Details from Session variables
            InputFirstName.Text = Session("FirstName")
            InputMiddleName.Text = Session("MiddleName")
            InputLastName.Text = Session("LastName")
            InputCustomerIC.Text = Session("CustomerIC")
            InputDateOfBirth.Text = Session("DateOfBirth")
            InputGender.Text = Session("Gender")
            InputContactNo.Text = Session("ContactNo")
            InputEmail.Text = Session("Email")
            InputStreetAddress.Text = Session("StreetAddress")
            InputCity.Text = Session("City")
            InputPostcode.Text = Session("Postcode")
            InputState.Text = Session("State")
            InputCountry.Text = "Malaysia"
            '2. Account
            InputAccNo.Text = Session("AccNo")
            InputAccName.Text = Session("AccName")
            InputAccType.Text = Session("AccType")
            InputAccOpenDate.Text = Session("AccOpenDate")
            InputInitialDeposit.Text = "RM " & CType(Session("InitialDeposit"), Decimal).ToString("N2")
        End If
    End Sub

    Private Sub BtnReturn_Click(sender As Object, e As EventArgs) Handles btnReturn.Click
        Response.Redirect("Staff_Page_Customer_Registration.aspx")
    End Sub


    Private Sub BtnSubmit_Click(sender As Object, e As EventArgs) Handles BtnSubmit.Click
        ' Retrieve the connection string from Web.config
        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
        ' Establish SQL Server connection using the connection string
        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim transaction As SqlTransaction = connection.BeginTransaction()
            ' Database transaction error handling
            Try
                ' 1. Insert into customer Table
                Dim customerQuery As String = "
                    INSERT INTO dbo.customer
                        (user_ic, first_name, middle_name, last_name, dob, gender, email, contact_no)
                    VALUES
                        (@UserIC, @FirstName, @MiddleName, @LastName, @DateOfBirth, @Gender, @Email, @ContactNo);"
                Using CustomerCommand As New SqlCommand(customerQuery, connection, transaction)
                    CustomerCommand.Parameters.AddWithValue("@UserIC", Session("CustomerIC"))
                    CustomerCommand.Parameters.AddWithValue("@FirstName", Session("FirstName"))
                    ' Handle NULL Middle Name safely
                    If String.IsNullOrWhiteSpace(TryCast(Session("MiddleName"), String)) Then
                        CustomerCommand.Parameters.AddWithValue("@MiddleName", DBNull.Value)
                    Else
                        CustomerCommand.Parameters.AddWithValue("@MiddleName", Session("MiddleName"))
                    End If
                    CustomerCommand.Parameters.AddWithValue("@LastName", Session("LastName"))
                    CustomerCommand.Parameters.AddWithValue("@DateOfBirth", Session("DateOfBirth"))
                    CustomerCommand.Parameters.AddWithValue("@Gender", Session("Gender"))
                    CustomerCommand.Parameters.AddWithValue("@Email", Session("Email"))
                    CustomerCommand.Parameters.AddWithValue("@ContactNo", Session("ContactNo"))
                    CustomerCommand.ExecuteNonQuery()
                End Using

                ' 2. Insert into login Table
                Dim loginQuery As String = "
                    INSERT INTO dbo.login
                        (user_ic)
                    VALUES
                        (@UserIC);"
                Using LoginCommand As New SqlCommand(loginQuery, connection, transaction)
                    LoginCommand.Parameters.AddWithValue("@UserIC", Session("CustomerIC"))
                    LoginCommand.ExecuteNonQuery()
                End Using

                ' 3. Insert into customerAddress Table
                Dim customerAddressQuery As String = "
                    INSERT INTO dbo.customerAddress
                        (user_ic, street_address, city, post_code, state_province)
                    VALUES
                        (@UserIC, @StreetAddress, @City, @Postcode, @StateProvince)"
                Using CustAddressCommand As New SqlCommand(customerAddressQuery, connection, transaction)
                    CustAddressCommand.Parameters.AddWithValue("@UserIC", Session("CustomerIC"))
                    CustAddressCommand.Parameters.AddWithValue("@StreetAddress", Session("StreetAddress"))
                    CustAddressCommand.Parameters.AddWithValue("@City", Session("City"))
                    CustAddressCommand.Parameters.AddWithValue("@Postcode", Session("Postcode"))
                    CustAddressCommand.Parameters.AddWithValue("@StateProvince", Session("State"))
                    CustAddressCommand.ExecuteNonQuery()
                End Using

                ' 4. Insert into account Table
                Dim accountQuery As String = "
                    INSERT INTO dbo.account
                        (user_ic, account_number, account_name, account_type, current_balance, available_balance, opened_date, status)
                    VALUES
                        (@UserIC, @AccNo, @AccName, @AccType, @Balance, @AvailableBalance, @AccOpenDate, 'Active');"
                Using AccountCommand As New SqlCommand(accountQuery, connection, transaction)
                    AccountCommand.Parameters.AddWithValue("@UserIC", Session("CustomerIC"))
                    AccountCommand.Parameters.AddWithValue("@AccNo", Session("AccNo"))
                    AccountCommand.Parameters.AddWithValue("@AccName", Session("AccName"))
                    AccountCommand.Parameters.AddWithValue("@Balance", CType(Session("InitialDeposit"), Decimal))
                    AccountCommand.Parameters.AddWithValue("@AccType", Session("AccType"))
                    AccountCommand.Parameters.AddWithValue("@AvailableBalance", CType(Session("InitialDeposit"), Decimal))
                    Dim openDate As DateTime = DateTime.Now
                    AccountCommand.Parameters.AddWithValue("@AccOpenDate", openDate)
                    AccountCommand.ExecuteNonQuery()
                End Using

                ' 4. Insert into transactions Table
                Dim transactionQuery As String = "
                    INSERT INTO dbo.transactions
                        (trans_id, from_acc, to_acc, trans_type, trans_amount, trans_date, trans_description)
                    VALUES (@TransId, @FromAcc, @ToAcc, 'CREDIT', @Amount, @TransDate, @Description);"
                Using TransactionCommand As New SqlCommand(transactionQuery, connection, transaction)
                    Dim lastSix As String = If(Session("AccNo").Length >= 6, Session("AccNo").Substring(Session("AccNo").Length - 6), Session("AccNo"))
                    Dim TransId As String = DateTime.Now.ToString("yyMMddHHmmss") & lastSix
                    TransactionCommand.Parameters.AddWithValue("@TransId", TransId)
                    TransactionCommand.Parameters.AddWithValue("@FromAcc", Session("AccNo"))
                    TransactionCommand.Parameters.AddWithValue("@ToAcc", Session("AccNo"))
                    TransactionCommand.Parameters.AddWithValue("@Amount", CType(Session("InitialDeposit"), Decimal))
                    Dim openDate As DateTime = DateTime.Now
                    TransactionCommand.Parameters.AddWithValue("@TransDate", openDate)
                    Dim openDesc As String = "Open ACC-" & Session("AccNo") & "-" & Session("AccType")
                    TransactionCommand.Parameters.AddWithValue("@Description", openDesc)
                    TransactionCommand.ExecuteNonQuery()
                End Using

                ' Commit all inserts
                transaction.Commit()

                ' Alert then redirect
                ClientScript.RegisterStartupScript(Me.GetType(), "alertRedirect",
                    "alert('New Customer account has been created.'); window.location='Staff_Page_Main_Menu.aspx';", True)
            Catch ex As Exception
                ' Safe rollback check
                Try
                    If transaction IsNot Nothing AndAlso transaction.Connection IsNot Nothing Then
                        transaction.Rollback()
                    End If
                Catch
                    ' Ignore rollback failure
                End Try

                Dim safeMessage As String = HttpUtility.JavaScriptStringEncode(ex.Message)
                ClientScript.RegisterStartupScript(Me.GetType(), "errorAlert",
                    "alert('Error saving data: " & safeMessage & "');", True)
            End Try
        End Using
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