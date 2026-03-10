<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="fund_transfer.aspx.vb" Inherits="CKV_Internet_Banking_System.fund_transfer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Fund Transfer</title>
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
                    <h2>Fund Transfer</h2>
                    <div>
                        <!-- TO ACCOUNT -->
                        <p style="margin-bottom: 3px;">Transfer To</p>
                        <asp:TextBox ID="TxtToAccount" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckTxtToAccount" runat="server"
                            ErrorMessage="Please enter an account number."
                            CssClass="validator-font"
                            Display="Dynamic"
                            ControlToValidate="TxtToAccount"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                        <br />
                        <br />
                        <!-- FROM USER ACCOUNT -->
                        <p style="margin-bottom: 3px;">From</p>
                        <asp:DropDownList ID="DdlUserAccount" runat="server"
                            DataSourceID="SqlDataSource1_customer"
                            DataTextField="DisplayField"
                            DataValueField="account_number">
                            <asp:ListItem Text="" Value="" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="CheckDdlUserAccount" runat="server"
                            ControlToValidate="DdlUserAccount"
                            ErrorMessage="Please choose an account."
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate">
                        </asp:RequiredFieldValidator>
                        <asp:SqlDataSource ID="SqlDataSource1_customer" runat="server"
                            ConnectionString="<%$ ConnectionStrings:CkvBankDBConnection %>"
                            SelectCommand="SELECT account_number, account_type, account_number + ' - ' + account_type AS DisplayField FROM [account] WHERE user_ic = @UserIC AND account_type <> 'Fixed Deposit'">
                            <SelectParameters>
                                <asp:SessionParameter Name="UserIC" SessionField="UserIC" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <br />
                        <br />
                        <!-- PAY AMOUNT -->
                        <p style="margin-bottom: 3px;">Amount and When</p>
                        <asp:TextBox ID="TransferAmount" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckTransferAmount" runat="server"
                            ErrorMessage="Please enter an amount."
                            CssClass="validator-font"
                            Display="Dynamic"
                            ControlToValidate="TransferAmount"
                            ValidationGroup="RequiredFieldValidate">
                        </asp:RequiredFieldValidator>
                        <br />
                        <br />
                        <!-- PAYMENT DATE -->
                        <p style="margin-bottom: 3px;">When</p>
                        <asp:TextBox ID="TransferDate" runat="server" TextMode="Date"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckTransferDate" runat="server"
                            ErrorMessage="Please choose a date."
                            ControlToValidate="TransferDate"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate">
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CvTransferDate" runat="server"
                            ControlToValidate="TransferDate"
                            ErrorMessage="The transfer date cannot be earlier than today."
                            OnServerValidate="CvTransferDate_ServerValidate"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate">
                        </asp:CustomValidator>
                        <br />
                        <br />
                        <p style="margin-bottom: 3px;">Descriptions (Optional)</p>
                        <asp:TextBox ID="TxtTransDescription" runat="server"
                            placeholder="Your Transaction Detail" MaxLength="100"></asp:TextBox>
                        <br />
                        <!-- BUTTON -->
                        <asp:Button ID="BtnNext" runat="server"
                            CssClass="btn-style"
                            Text="Next"
                            ValidationGroup="RequiredFieldValidate" />
                    </div>
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
