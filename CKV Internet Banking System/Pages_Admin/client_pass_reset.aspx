<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="client_pass_reset.aspx.vb" Inherits="CKV_Internet_Banking_System.client_pass_reset" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login Now</title>
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
                    <div class="content-font-align">
                        <div class="content-font-style">
                            <!-- Enter Username to proceed with password reset -->
                            <div class="content-row">
                                <label for="txtUser" style="font-size: 16px; text-align: center;">To reset your password, </label>
                                <label for="txtUser" style="font-size: 16px; text-align: center;">please enter your username.</label>
                                <br />
                                <asp:TextBox ID="txtUser" runat="server"
                                    CssClass="input-font">
                                </asp:TextBox>
                                <div></div>
                                <!-- empty placeholder cell -->
                                <asp:RequiredFieldValidator ID="CheckTxtUsername" runat="server"
                                    ErrorMessage="This field is required."
                                    ControlToValidate="txtUser"
                                    CssClass="validator-font"
                                    Display="Dynamic"
                                    ClientIDMode="Static">
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>
                    <br />
                    <div class="btn-align">
                        <asp:Button ID="BtnNext" runat="server"
                            CssClass="btn-style"
                            Text="Next" />
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
