<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Staff_Page_Customer_Registration.aspx.vb" Inherits="CKVBank.Staff_Page_Customer_Registration" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>New Account Registration</title>
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
                    <!-- First Name -->
                    <div class="form-field">
                        <label for="firstName">First Name</label>
                        <asp:TextBox ID="TxtFirstName" runat="server"
                            CssClass="input-size"
                            ToolTip="Given Name"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckFirstName" runat="server"
                            ErrorMessage="Please enter customer given name."
                            ControlToValidate="TxtFirstName"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                    </div>
                    <br />
                    <!-- Middle Name -->
                    <div class="form-field">
                        <label for="middleName">Middle Name (Optional)</label>
                        <asp:TextBox ID="TxtMiddleName" runat="server"
                            CssClass="input-size"
                            ToolTip="Middle Name"></asp:TextBox>
                    </div>
                    <br />
                    <!-- Last Name -->
                    <div class="form-field">
                        <label for="lastName">Last Name</label>
                        <asp:TextBox ID="TxtLastName" runat="server"
                            CssClass="input-size"
                            ToolTip="Family Name"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckLastName" runat="server"
                            ErrorMessage="Please enter customer family name."
                            ControlToValidate="TxtLastName"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                    </div>
                    <br />
                    <!-- Customer IC -->
                    <div class="form-field">
                        <label for="customerIC">Malaysia IC (e.g.,990201225560)</label>
                        <asp:TextBox ID="TxtCustomerIC" runat="server"
                            CssClass="input-size"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckCustomerIC" runat="server"
                            ErrorMessage="This field is required."
                            ControlToValidate="TxtCustomerIC"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RevCustomerIC" runat="server"
                            ControlToValidate="TxtCustomerIC"
                            ErrorMessage="Please follow the format (e.g., 990201225560)."
                            ValidationExpression="^\d{12}$"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RegularExpressionValidator>
                    </div>
                    <br />
                    <!-- Date of Birth -->
                    <div class="form-field">
                        <label for="dateOfBirth">Date of Birth</label>
                        <asp:TextBox ID="TxtDateOfBirth" runat="server"
                            Width="250px"
                            TextMode="Date"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckDateOfBirth" runat="server"
                            ErrorMessage="Date of birth is required."
                            ControlToValidate="TxtDateOfBirth"
                            CssClass="validator-font" 
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RvDateOfBirth" runat="server"
                            ControlToValidate="TxtDateOfBirth"
                            ErrorMessage="Birth Date must be between 01/01/1960 and 31/12/2013."
                            MaximumValue="2013-12-31"
                            MinimumValue="1960-01-01"
                            CausesValidation="True"
                            Display="Dynamic"
                            CssClass="validator-font"
                            ValidationGroup="RequiredFieldValidate"></asp:RangeValidator>
                    </div>
                    <br />
                    <!-- Gender -->
                    <div class="form-field">
                        <label for="gender">Gender</label>
                        <asp:RadioButtonList ID="RblGender" runat="server"
                            GroupName="gender"
                            RepeatDirection="Horizontal"
                            CssClass="radio-inline"
                            DataTextField="gender"
                            DataValueField="gender">
                            <asp:ListItem>female</asp:ListItem>
                            <asp:ListItem>male</asp:ListItem>
                        </asp:RadioButtonList>
                        <asp:RequiredFieldValidator ID="CheckGender" runat="server"
                            ErrorMessage="Gender is required."
                            ControlToValidate="RblGender"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                    </div>
                    <br />
                    <!-- Contact Number -->
                    <div class="form-field">
                        <label for="contactNo">Contact No.</label>
                        <asp:TextBox ID="TxtContactNo" runat="server"
                            CssClass="input-size"
                            Placeholder="+60129876543"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="checkContactNo" runat="server"
                            ErrorMessage="This field is required."
                            ControlToValidate="TxtContactNo"
                            CssClass="validator-font" 
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RevContactNo" runat="server"
                            ControlToValidate="TxtContactNo"
                            ErrorMessage="Please enter a valid phone number (e.g., +60129876543)."
                            ValidationExpression="^\+[1-9][0-9]{7,14}$"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RegularExpressionValidator>
                    </div>
                    <br />
                    <!-- Email -->
                    <div class="form-field">
                        <label for="email">E-mail Address</label>
                        <asp:TextBox ID="TxtEmail" runat="server"
                            CssClass="input-size"
                            Placeholder="example@email.com"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckEmail" runat="server"
                            ControlToValidate="TxtEmail"
                            ErrorMessage="This field is required."
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RevEmail" runat="server"
                            ControlToValidate="TxtEmail"
                            ErrorMessage="Please enter a valid email. (e.g., johndoe@gmail.com)."
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RegularExpressionValidator>
                    </div>
                    <br />
                    <!-- Street Address -->
                    <div class="form-field">
                        <label for="streetAddress">Street Address</label>
                        <asp:TextBox ID="TxtStreetAddress" runat="server"
                            CssClass="input-size"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckStreetAddress" runat="server"
                            ErrorMessage="This field is required."
                            ControlToValidate="TxtStreetAddress"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                    </div>
                    <br />
                    <!-- City -->
                    <div class="form-field">
                        <label for="city">City</label>
                        <asp:TextBox ID="TxtCity" runat="server"
                            CssClass="input-size"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckCity" runat="server"
                            ErrorMessage="This field is required."
                            ControlToValidate="TxtCity"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                    </div>
                    <br />
                    <!-- Postcode -->
                    <div class="form-field">
                        <label for="postcode">Postcode</label>
                        <asp:TextBox ID="TxtPostcode" runat="server"
                            CssClass="input-size"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckPostcode" runat="server"
                            ErrorMessage="This field is required."
                            ControlToValidate="TxtPostcode"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RevPostcode" runat="server"
                            ControlToValidate="TxtPostcode"
                            ErrorMessage="Please enter a valid postcode (e.g., 93350)."
                            ValidationExpression="^\d{5}$"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RegularExpressionValidator>
                        <asp:RangeValidator ID="RvPostcode" runat="server"
                            ControlToValidate="TxtPostcode"
                            ErrorMessage="Malaysia postcode must be between 01000 to 98859."
                            MaximumValue="98859"
                            MinimumValue="01000"
                            CausesValidation="True"
                            Display="Dynamic"
                            CssClass="validator-font"
                            ValidationGroup="RequiredFieldValidate"></asp:RangeValidator>
                    </div>
                    <br />
                    <!-- State -->
                    <div class="form-field">
                        <label for="State">State</label>
                        <asp:DropDownList ID="DdlState" runat="server"
                            Style="width:200px;"
                            GroupName="MalaysiaState"
                            RepeatDirection="Horizontal">
                            <asp:ListItem></asp:ListItem>
                            <asp:ListItem>Perlis</asp:ListItem>
                            <asp:ListItem>Kedah</asp:ListItem>
                            <asp:ListItem>Penang</asp:ListItem>
                            <asp:ListItem>Perak</asp:ListItem>
                            <asp:ListItem>Selangor</asp:ListItem>
                            <asp:ListItem>Negeri Sembilan</asp:ListItem>
                            <asp:ListItem>Malacca</asp:ListItem>
                            <asp:ListItem>Johor</asp:ListItem>
                            <asp:ListItem>Kelantan</asp:ListItem>
                            <asp:ListItem>Terengganu</asp:ListItem>
                            <asp:ListItem>Pahang</asp:ListItem>
                            <asp:ListItem>Sabah</asp:ListItem>
                            <asp:ListItem>Sarawak</asp:ListItem>
                            <asp:ListItem>Kuala Lumpur</asp:ListItem>
                            <asp:ListItem>Putrajaya</asp:ListItem>
                            <asp:ListItem>Labuan</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="CheckState" runat="server"
                            ErrorMessage="State is required."
                            ControlToValidate="DdlState"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                    </div>
                    <br />
                    <!-- Country -->
                    <div class="form-field">
                        <label for="country">Country</label>Malaysia
                    </div>
                <br />
                    <p class="title-container section-title">2. Account Information</p>
                    <!-- Account Number -->
                    <div class="form-field">
                        <label for="Account Number">Account Number</label>
                        <asp:label ID="LblAccNo" runat="server" CssClass="input-size"></asp:label>
                    </div>
                    <br />
                    <!-- Account Type -->
                    <div class="form-field">
                        <label for="AccType">Account Type</label>
                        <asp:DropDownList ID="DdlAccType" runat="server"
                            Style="width: 200px;"
                            GroupName="MalaysiaState"
                            RepeatDirection="Horizontal">
                            <asp:ListItem></asp:ListItem>
                            <asp:ListItem>SAVINGS</asp:ListItem>
                            <asp:ListItem>CURRENT</asp:ListItem>
                            <asp:ListItem>FIXED DEPOSIT</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="CheckDdlAccType" runat="server"
                            ErrorMessage="Please choose the type of account."
                            ControlToValidate="DdlAccType"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                    </div>
                    <br />
                    <!-- Currency -->
                    <div class="form-field">
                        <label for="currency">Currency</label>MYR
                    </div>
                    <br />
                    <!-- Open Date -->
                    <div class="form-field">
                        <label for="openDate">Open Date</label>
                        <asp:TextBox ID="TxtOpenDate" runat="server" ReadOnly="True" CssClass="input-size"></asp:TextBox>
                    </div>
                    <br />
                    <!-- Initial Deposit -->
                    <div class="form-field">
                        <label for="InitialDeposit">Initial Deposit</label>
                        <asp:TextBox ID="TxtInitialDeposit" runat="server"
                            CssClass="input-size"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckTxtInitialDeposit" runat="server"
                            ErrorMessage="This field is required."
                            ControlToValidate="TxtInitialDeposit"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CvTxtInitialDeposit" runat="server"
                            ControlToValidate="TxtInitialDeposit"
                            ErrorMessage="A minimum initial deposit of RM20 is required to open an account."
                            OnServerValidate="CvTxtInitialDeposit_ServerValidate"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:CustomValidator>
                    </div>
                </div>
                <!-- Buttons -->
                <div class="btn-align" style="justify-content: flex-start;">
                    <asp:Button ID="BtnConfirm" runat="server"
                        CssClass="btn-style" 
                        ClientIDMode="Static"
                        ValidationGroup="RequiredFieldValidate"
                        Text="Confirm Details" />
                    <asp:Button ID="BtnCancel" runat="server"
                        CssClass="btn-style" 
                        ClientIDMode="Static"
                        OnClientClick="return confirm('All unsaved data will be lost if you cancel. Are you sure?');"
                        Text="Cancel" />
                    </div>
                </div>
               
        </div>
    </form>
</body>
</html>
