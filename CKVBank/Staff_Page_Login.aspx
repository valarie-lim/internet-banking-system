<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Staff_Page_Login.aspx.vb" Inherits="CKVBank.Staff_Page_Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login Now</title>
    <link rel="stylesheet" href="CSS/style.css"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="background-container">
            <div class="background-image-overlay-staff"></div>
            <div class="content-container">
                <div class="content">
                    <div class="logo-align">
                        <img class="logo-style" src="Images/logo.png" />
                    </div>
                    <p class="logo-tagline">Secure. Smart. Seamless </p>
                    <div class="content-font-align">
                        <div class="content-font-style">
                            <!-- Username -->
                            <div class="content-row">
                                <label for="txtUser" style="font-size: 16px; text-align: center;">Username</label>
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
                        <asp:Button ID="BtnLoginVerify" runat="server"
                            CssClass="btn-style"
                            Text="Login" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>