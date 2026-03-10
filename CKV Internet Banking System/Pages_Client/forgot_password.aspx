<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="forgot_password.aspx.vb" Inherits="CKV_Internet_Banking_System.forgot_password" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Forgot Password</title>
    <link rel="stylesheet" href="../CSS/style.css"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="background-container">
            <div class="background-image-overlay"></div>
            <div class="content-container">
                <div class="content">
                    <div class="logo-align">
                        <img class="logo-style" src="../Images/logo.png" />
                    </div>
                    <p class="logo-tagline">Secure. Smart. Seamless </p>
                    <p>Please enter your email address.</p>
                    <div class="content-row">
                        <%-- Send Code to Email --%>
                        <asp:TextBox ID="TxtSendCode" runat="server" CssClass="input-font">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckSendCode" runat="server"
                            ErrorMessage="This field is required."
                            ControlToValidate="TxtSendCode"
                            CssClass="validator-font"
                            Display="Dynamic" 
                            ClientIDMode="Static"
                            ValidationGroup="RequiredFieldValidate">
                        </asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                            ControlToValidate="TxtSendCode"
                            ErrorMessage="Invalid email format. Please provide a valid email address (e.g., example@email.com)"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                            CssClass="validator-font"
                            Display="Dynamic">
                        </asp:RegularExpressionValidator>
                    </div>
                </div>
                <div class="btn-align">
                    <asp:Button ID="BtnSendCode" runat="server" 
                        CssClass="btn-style" 
                        ValidationGroup="RequiredFieldValidate"
                        Text="Send Code" />
                    <asp:Button ID="BtnCancel" runat="server" 
                        CssClass="btn-style" Text="Cancel" />
                </div>
            </div>

            <asp:label ID="lblBugCheck" runat="server"></asp:label>
        </div>
</form>
    <footer>
        <p>© DCS2102E Group Project by Group 2. All right reserved.</p>
        <p>Best viewed on the latest version of Chrome, Firefox, Edge, Safari, Opera.</p>
    </footer>
</body>
</html>