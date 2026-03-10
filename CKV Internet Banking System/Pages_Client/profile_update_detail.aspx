<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="profile_update_detail.aspx.vb" Inherits="CKV_Internet_Banking_System.profile_update_detail" %>

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
                    <h2>Update Details</h2>
                    <div>
                        Account Holder:&nbsp;<asp:Label ID="CustName" runat="server"></asp:Label>
                        <br />
                        <br />
                        Email Address:&nbsp;<asp:TextBox ID="txtUpdateEmail" runat="server" PlaceHolder="example@email.com" ClientIDMode="Static"></asp:TextBox>
                        <br />
                        <br />
                        Phone Number:&nbsp;<asp:Label ID="CustPhone" runat="server"></asp:Label>
                        <br />
                        <br />
                        Billing Address:&nbsp;<asp:Label ID="CustAddress" runat="server"></asp:Label>
                        <br />
                        <p class="validator-font">The email is for password reset and marketing purpose. Kindly proceed to the CKV outlets to update others information.</p>
                        <div class="btn-align">
                            <asp:Button ID="BtnUpdate" runat="server"
                                CssClass="btn-style"
                                ClientIDMode="Static"
                                ValidationGroup="RequiredFieldValidate"
                                Text="Update" />
                            <asp:Button ID="BtnCancel" runat="server"
                                CssClass="btn-style"
                                ClientIDMode="Static"
                                Text="Cancel" />
                        </div>
                        <asp:RequiredFieldValidator ID="CheckTxtUpdateEmail" runat="server"
                            ErrorMessage="This field is required."
                            ControlToValidate="txtUpdateEmail"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ClientIDMode="Static"
                            ValidationGroup="RequiredFieldValidate">
                        </asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                            ControlToValidate="txtUpdateEmail"
                            ErrorMessage="Invalid email format. Please provide a valid email address (e.g., john2025@gmail.com)"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                            CssClass="validator-font"
                            Display="Dynamic">
                        </asp:RegularExpressionValidator>
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