<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="profile_update.aspx.vb" Inherits="CKV_Internet_Banking_System.profile_update" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Update Profile</title>
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
                    <asp:Button ID="BtnAccOverview" runat="server"
                        CssClass="btn-menu"
                        Style="margin-top: 50px;" Text="Account Overview" />
                    <asp:Button ID="BtnFundTransfer" runat="server"
                        CssClass="btn-menu" Text="Fund Transfer" />
                    <asp:Button ID="BtnBillPayment" runat="server"
                        CssClass="btn-menu" Text="Bill Payment" />
                    <asp:Button ID="BtnUpdateProfile" runat="server"
                        CssClass="btn-menu" Text="Update Profile" />
                    <asp:Button ID="BtnContactUs" runat="server"
                        CssClass="btn-menu" Text="Contact Us" />
                    <asp:Button ID="BtnLogout" runat="server"
                        CssClass="btn-menu" Text="Logout"
                        OnClientClick="return confirm('Are you sure you want to log out?');" />
                </div>
            </div>
            <div class="right-menu-container">
                Hi,&nbsp;<asp:Label ID="CustomerName" runat="server"></asp:Label>
                <br />
                <asp:Label ID="LoginTimestamp" runat="server" CssClass="timestamp-font-size"></asp:Label>
                <br />
                <br />
                <div>
                    <h2>My Profile</h2>
                    <p>
                        Account Holder:&nbsp;<asp:Label ID="CustName" runat="server"></asp:Label><br /><br />
                        Email Address:&nbsp;<asp:Label ID="CustEmail" runat="server"></asp:Label>
                        <br /><br />
                        Phone Number:&nbsp;<asp:Label ID="CustPhone" runat="server"></asp:Label><br /><br />
                        Billing Address:&nbsp;<asp:Label ID="CustAddress" runat="server"></asp:Label>
                    </p>
                    <asp:Button ID="BtnModify" runat="server"
                        CssClass="btn-style" 
                        ClientIDMode="Static" 
                        Text="Modify Details" />
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