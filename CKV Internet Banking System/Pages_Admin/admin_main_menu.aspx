<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="admin_main_menu.aspx.vb" Inherits="CKV_Internet_Banking_System.admin_main_menu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Main Menu</title>
    <link rel="stylesheet" href="../CSS/style.css"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="menu-container">
            <div class="side-menu-container">
                <div>
                    <div class="logo-align">
                        <img  class="logo-style" src="../Images/logo.png" />
                    </div>
                    <asp:Button ID="BtnDashboard" runat="server" 
                        CssClass="btn-menu" Style="margin-top:50px;" Text="Dashboard"/>
                    <asp:Button ID="BtnUpdateProfile" runat="server" 
                        CssClass="btn-menu" Text="My Profile" />
                    <asp:Button ID="BtnLogout" runat="server" 
                        CssClass="btn-menu" Text="Logout" 
                        OnClientClick="return confirm('Are you sure you want to log out?');"/>
                </div>
            </div>
            <div class="right-menu-container">
                Hi,&nbsp;<asp:Label ID="EmployeeName" runat="server"></asp:Label>
                <br />
                <asp:Label ID="LoginTimestamp" runat="server" CssClass="timestamp-font-size"></asp:Label>
                <br />
                <br />
                <h2>Admin Dashboard</h2>
                <br />
                <asp:Button ID="BtnAddLocalCustomer" runat="server"
                    CssClass="btn-style-normal" Text="New Customer Registration" />
                <br />
                <asp:Button ID="BtnCustomerManagement" runat="server"
                    CssClass="btn-style-normal" Text="Customer Login Management" />
            </div>
        </div>
    </form>
    <footer>
        <p>© DCS2102E Group Project by Group 2. All right reserved.</p>
        <p>Best viewed on the latest version of Chrome, Firefox, Edge, Safari, Opera.</p>
    </footer>
</body>
</html>
