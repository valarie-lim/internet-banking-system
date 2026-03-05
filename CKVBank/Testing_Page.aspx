<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Testing_Page.aspx.vb" Inherits="CKVBank.Testing_Page" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="CSS/style.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="menu-container">
            <div class="side-menu-container">
                <div>
                    <div class="logo-align">
                        <img  class="logo-style" src="Images/logo.png" />
                    </div>
                    <asp:Button ID="BtnFundTransfer" runat="server" CssClass="btn-menu" Style="margin-top:50px;" Text="Fund Transfer" />
                    <asp:Button ID="BtnBillPayment" runat="server" CssClass="btn-menu" Text="Bill Payment" />
                    <asp:Button ID="BtnUpdateProfile" runat="server" CssClass="btn-menu" Text="Update Profile" />
                    <asp:Button ID="BtnContactUs" runat="server" CssClass="btn-menu" Text="Contact Us" />
                    <asp:Button ID="BtnLogout" runat="server" CssClass="btn-menu" Text="Logout" />
                </div>
            </div>
            <div class="right-menu-container">
                Hi ,&nbsp;
                <asp:Label ID="CustomerName" runat="server"></asp:Label>
                <asp:Label ID="LoginTimestamp" runat="server" CssClass="timestamp-font-size"></asp:Label>
                <br />
                <br />
                My Account Overview<br />
                <asp:Label ID="LblAccountBalance" runat="server" Text="Transactions display HERE"></asp:Label>
                
                <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource_Transactions">
                </asp:GridView>
                
                <asp:SqlDataSource ID="SqlDataSource_Transactions" runat="server"></asp:SqlDataSource>
                
            </div>
        </div>
    </form>
</body>
</html>
