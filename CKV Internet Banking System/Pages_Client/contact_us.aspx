<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="contact_us.aspx.vb" Inherits="CKV_Internet_Banking_System.contact_us" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Contact Us</title>
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
                <h2>Call Us Anytime</h2>
                <h3>We are contactable 24/7</h3>
                <h4 style="font-weight: bold; margin: 0;">Consumer Call Centre</h4>
                <p>
                    Telephone<br />
                    +603 6200 7700
                </p>
                <p style="margin: 0;">
                    Email<br />
                    support@ckvbank.com
                </p>
                <h5>About
                    <br />
                    Welcome to the CKV Online Banking.
                    <br />
                    Enjoy convenient, safe and instant banking access to your CKV accounts online.
                    <br />
                    Log in with your existing CKV User ID and Password to perform your desired banking transactions swiftly.
                    <br />
                    <br />
                    Note: CKV Online Banking is only available for CKV Bank account holders.
                </h5>
            </div>
        </div>
    </form>
    <footer>
        <p>© DCS2102E Group Project by Group 2. All right reserved.</p>
        <p>Best viewed on the latest version of Chrome, Firefox, Edge, Safari, Opera.</p>
    </footer>
</body>
</html>