<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Page_Bill_Payment_Confirm.aspx.vb" Inherits="CKVBank.Page_Bill_Payment_Confirm" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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
                <h2>Bill Payment Confirmation</h2>
                <br />
                <div class="form-container">
                    <p class="title-container section-title">Please confirm your payment detail.</p>
                    <div class="display-field">
                        <span class="field-label">PAYMENT TO:</span>
                        <asp:Label ID="InputBillTo" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">FROM ACCOUNT:</span>
                        <asp:Label ID="InputBillFrom" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Amount:</span>
                        <asp:Label ID="InputBillAmount" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Payment Date:</span>
                        <asp:Label ID="InputBillPaymentDate" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                </div>
                <!-- Buttons -->
                <div class="btn-align" style="justify-content: flex-start;">
                    <asp:Button ID="BtnCancel" runat="server"
                        Text="Cancel"
                        OnClientClick="if (confirm('Your current transaction will be aborted if you cancel. Are you sure?')) { window.location='Page_Main_Menu.aspx'; } return false;"
                        CssClass="btn-style" />
                    <asp:Button ID="BtnPayNow" runat="server"
                        Text="Pay Now"
                        CssClass="btn-style" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
