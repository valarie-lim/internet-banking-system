<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="bill_payment.aspx.vb" Inherits="CKV_Internet_Banking_System.bill_payment" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bill Payment</title>
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
                    <h2>Bill Payment</h2>
                    <div>
                        <!-- TO BILLER ACCOUNT -->
                        <p style="margin-bottom: 3px;">Pay For</p>
                        <asp:DropDownList ID="DdlPaymentAccount" runat="server"
                            DataSourceID="SqlDataSource1_biller"
                            DataTextField="nickname"
                            DataValueField="company_acc_no">
                            <asp:ListItem></asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="CheckDdlPaymentAccount" runat="server"
                            ErrorMessage="Please choose the bill you want to pay."
                            CssClass="validator-font"
                            Display="Dynamic"
                            ControlToValidate="DdlPaymentAccount"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                        <asp:SqlDataSource ID="SqlDataSource1_biller" runat="server"
                            ConnectionString="<%$ ConnectionStrings:CkvBankDBConnection %>"
                            SelectCommand="SELECT [company_acc_no], [nickname] FROM [company]"></asp:SqlDataSource>
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
                        <asp:TextBox ID="BillAmount" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckBillAmount" runat="server"
                            ErrorMessage="Please enter an amount."
                            CssClass="validator-font"
                            Display="Dynamic"
                            ControlToValidate="BillAmount"
                            ValidationGroup="RequiredFieldValidate">
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CvBillAmount" runat="server"
                            ErrorMessage="The payment amount must be RM10 or higher."
                            CssClass="validator-font"
                            Display="Dynamic"
                            OnServerValidate="CvBillAmount_ServerValidate"
                            ControlToValidate="BillAmount"
                            ValidationGroup="RequiredFieldValidate"></asp:CustomValidator>
                        <br />
                        <br />
                        <!-- PAYMENT DATE -->
                        <p style="margin-bottom: 3px;">When</p>
                        <asp:TextBox ID="BillPaymentDate" runat="server" TextMode="Date"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckBillPaymentDate" runat="server"
                            ErrorMessage="Please choose a date."
                            ControlToValidate="BillPaymentDate"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate">
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CvBillPaymentDate" runat="server"
                            ControlToValidate="BillPaymentDate"
                            ErrorMessage="The payment date cannot be earlier than today."
                            OnServerValidate="CvBillPaymentDate_ServerValidate"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate">
                        </asp:CustomValidator>
                        <br />
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