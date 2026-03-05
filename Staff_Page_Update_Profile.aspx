<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Staff_Page_Update_Profile.aspx.vb" Inherits="CKVBank.Staff_Page_Update_Profile1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>View Profile</title>
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
                <div>
                    <h2>My Profile</h2>
                    <p>
                        Full Name:&nbsp;<asp:Label ID="StaffName" runat="server"></asp:Label><br />
                        <br />
                        Email Address:&nbsp;<asp:Label ID="StaffEmail" runat="server"></asp:Label><br />
                        <br />
                        Contact Number:&nbsp;<asp:Label ID="StaffPhone" runat="server"></asp:Label><br />
                        <br />
                        Date of Birth:&nbsp;<asp:Label ID="StaffBirthDate" runat="server"></asp:Label><br />
                        <br />
                        Gender:&nbsp;<asp:Label ID="StaffGender" runat="server"></asp:Label><br />
                        <br />
                        Position:&nbsp;<asp:Label ID="StaffPosition" runat="server"></asp:Label><br />
                        <br />
                        Employment Date:&nbsp;<asp:Label ID="EmploymentDate" runat="server"></asp:Label>
                    </p>
                    <asp:Button ID="BtnModify" runat="server"
                        CssClass="btn-style"
                        ClientIDMode="Static"
                        Text="Modify Contact Number" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>