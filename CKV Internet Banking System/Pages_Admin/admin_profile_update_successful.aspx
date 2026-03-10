<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="admin_profile_update_successful.aspx.vb" Inherits="CKV_Internet_Banking_System.admin_profile_update_successful" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Modify Detail</title>
    <link rel="stylesheet" href="../CSS/style.css"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="menu-container">
            <div class="side-menu-container">
                <div>
                    <div class="logo-align">
                        <img class="logo-style" src="../Images/logo.png" />
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
                <div>
                    <h2>Update My Profile</h2>
                    <p>
                        Full Name:&nbsp;<asp:Label ID="StaffName" runat="server"></asp:Label><br />
                        <br />
                        Email Address:&nbsp;<asp:Label ID="StaffEmail" runat="server"></asp:Label><br />
                        <br />
                        Contact Number:&nbsp;<asp:TextBox ID="txtUpdatePhone" runat="server" PlaceHolder="+60123456789" ClientIDMode="Static"></asp:TextBox><br />
                        <br />
                        Date of Birth:&nbsp;<asp:Label ID="StaffBirthDate" runat="server"></asp:Label><br />
                        <br />
                        Gender:&nbsp;<asp:Label ID="StaffGender" runat="server"></asp:Label><br />
                        <br />
                        Position:&nbsp;<asp:Label ID="StaffPosition" runat="server"></asp:Label><br />
                        <br />
                        Employment Date:&nbsp;<asp:Label ID="EmploymentDate" runat="server"></asp:Label><br />
                    </p>
                    <div class="btn-align">
                        <asp:Button ID="BtnUpdate" runat="server"
                            CssClass="btn-style"
                            ClientIDMode="Static"
                            ValidationGroup="RequiredFieldValidate"
                            Text="Update" />
                        <asp:Button ID="BtnCancel" runat="server"
                            CssClass="btn-style"
                            ClientIDMode="Static"
                            CausesValidation="False"
                            Text="Cancel" />
                    </div>
                    <asp:RequiredFieldValidator ID="CheckTxtUpdatePhone" runat="server"
                        ErrorMessage="This field is required."
                        ControlToValidate="txtUpdatePhone"
                        CssClass="validator-font"
                        Display="Dynamic"
                        ClientIDMode="Static"
                        ValidationGroup="RequiredFieldValidate">
                    </asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revContactNo" runat="server"
                        ControlToValidate="txtUpdatePhone"
                        ErrorMessage="Please enter a valid phone number (e.g., +60123456789)." 
                        ValidationExpression="^\+[1-9][0-9]{7,14}$"
                        CssClass="validator-font"
                        Display="Dynamic">
                    </asp:RegularExpressionValidator>
                </div>
            </div>
        </div>
    </form>
    <footer>
        <p>© DCS2102E Group Project by Group 2. All right reserved.</p>
        <p>Best viewed on the latest version of Chrome, Firefox, Edge, Safari, Opera.</p>
    </footer>
</body>
</html>