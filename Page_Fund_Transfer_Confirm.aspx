<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Page_Fund_Transfer_Confirm.aspx.vb" Inherits="CKVBank.Page_Fund_Transfer_Confirm" %>

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
                <h2>Fund Transfer Confirmation</h2>
                <br />
                <div class="form-container">
                    <p class="title-container section-title">Please confirm your transaction detail.</p>
                    <div class="display-field">
                        <span class="field-label">TRANSFER TO:</span>
                        <asp:Label ID="InputTransferTo" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">FROM ACCOUNT:</span>
                        <asp:Label ID="InputTransferFrom" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Amount:</span>
                        <asp:Label ID="InputTransferAmount" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Transfer Date:</span>
                        <asp:Label ID="InputTransferPaymentDate" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                    <div class="display-field">
                        <span class="field-label">Transaction Details:</span>
                        <asp:Label ID="InputTransDescription" runat="server" CssClass="field-value"></asp:Label>
                    </div>
                </div>
                <!-- Buttons -->
                <div class="btn-align" style="justify-content: flex-start;">
                    <asp:Button ID="BtnCancel" runat="server"
                        Text="Cancel"
                        OnClientClick="if (confirm('Your current transaction will be aborted if you cancel. Are you sure?')) { window.location='Page_Main_Menu.aspx'; } return false;"
                        CssClass="btn-style" />
                    <asp:Button ID="BtnTransferNow" runat="server"
                        Text="Transfer Now"
                        CssClass="btn-style" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
