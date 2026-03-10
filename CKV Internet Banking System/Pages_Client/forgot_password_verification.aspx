<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="forgot_password_verification.aspx.vb" Inherits="CKV_Internet_Banking_System.forgot_password_verification" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Password Reset Request Verification</title>
    <link rel="stylesheet" href="../CSS/style.css"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="background-container">
            <div class="background-image-overlay"></div>
            <div class="content-container">
                <div class="content">
                    <div class="logo-align">
                        <img class="logo-style" src="../Images/logo.png" /></div>
                    <p class="logo-tagline">Secure. Smart. Seamless </p>
                    <p>Please enter your verification code.</p>
                    <div class="content-row">
                        <%-- Verification Code --%>
                        <asp:TextBox ID="TxtVerifyCode" runat="server" CssClass="input-font">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckVerifyCode" runat="server"
                            ErrorMessage="This field is required."
                            ControlToValidate="TxtVerifyCode"
                            CssClass="validator-font"
                            Display="Dynamic" 
                            ClientIDMode="Static">
                        </asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="btn-align">
                    <asp:Button ID="BtnVerifyCode" runat="server" CssClass="btn-style" Text="Verify Now" />
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