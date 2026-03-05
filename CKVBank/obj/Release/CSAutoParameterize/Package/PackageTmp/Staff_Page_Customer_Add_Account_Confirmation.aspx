<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Staff_Page_Customer_Add_Account_Confirmation.aspx.vb" Inherits="CKVBank.Staff_Page_Customer_Add_Account_Confirmation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Account Confirmation Page</title>
    <link rel="stylesheet" href="CSS/style.css"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="menu-container">
            <div class="side-menu-container">
                <div>
                    <div class="logo-align">
                        <img class="logo-style" src="Images/logo.png" />
                    </div>
                    <asp:Button ID="BtnDashboard" runat="server"
                        CssClass="btn-menu" Style="margin-top: 50px;" Text="Dashboard" />
                    <asp:Button ID="BtnUpdateProfile" runat="server"
                        CssClass="btn-menu" Text="My Profile" />
                    <asp:Button ID="BtnLogout" runat="server"
                        CssClass="btn-menu" Text="Logout"
                        OnClientClick="return confirm('Are you sure you want to log out?');" />
                </div>
            </div>
            <div class="right-menu-container">
                Hi,&nbsp;<asp:Label ID="EmployeeName" runat="server"></asp:Label>
                <br />
                <asp:Label ID="LoginTimestamp" runat="server" CssClass="timestamp-font-size"></asp:Label>
                <br />
                <br />
                <h2>New Customer Registration</h2>
                <br />
                <div class="form-container">
                    <p class="title-container section-title">1. Personal Details</p>
                    <div class="display-field">
                        <span class="field-label">First Name:</span>
                        <asp:Label ID="InputFirstName" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Middle Name:</span>
                        <asp:Label ID="InputMiddleName" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Last Name:</span>
                        <asp:Label ID="InputLastName" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Malaysia IC:</span>
                        <asp:Label ID="InputCustomerIC" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Date of Birth:</span>
                        <asp:Label ID="InputDateOfBirth" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Gender:</span>
                        <asp:Label ID="InputGender" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Contact No.:</span>
                        <asp:Label ID="InputContactNo" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Email:</span>
                        <asp:Label ID="InputEmail" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Street Address:</span>
                        <asp:Label ID="InputStreetAddress" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">City:</span>
                        <asp:Label ID="InputCity" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Postcode:</span>
                        <asp:Label ID="InputPostcode" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">State:</span>
                        <asp:Label ID="InputState" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Country:</span>
                        <asp:Label ID="InputCountry" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <p class="title-container section-title">2. Account Information</p>
                    <div class="display-field">
                        <span class="field-label">Account Number:</span>
                        <asp:Label ID="InputAccNo" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Account Name:</span>
                        <asp:Label ID="InputAccName" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Account Type:</span>
                        <asp:Label ID="InputAccType" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Account Open Date:</span>
                        <asp:Label ID="InputAccOpenDate" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Initial Deposit:</span>
                        <asp:Label ID="InputInitialDeposit" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                </div>
                <!-- Buttons -->
                <div class="btn-align" style="justify-content: flex-start;">
                    <asp:Button ID="BtnReturn" runat="server"
                        Text="Return"
                        CssClass="btn-style" />
                    <asp:Button ID="BtnSubmit" runat="server"
                        Text="Submit Registration"
                        CssClass="btn-style" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
