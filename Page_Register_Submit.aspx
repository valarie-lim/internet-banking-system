<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Page_Register_Submit.aspx.vb" Inherits="CKVBank.Page_Register_Submit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reset Password</title>
    <link rel="stylesheet" href="CSS/style.css"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="background-container">
            <div class="background-image-overlay"></div>
            <div class="content-container">
                <div class="content">
                    <div class="logo-align">
                        <img class="logo-style" src="Images/logo.png" />
                    </div>
                    <p class="logo-tagline">Secure. Smart. Seamless </p>
                    <p>Please create your login details.</p>
                    <div class="content-row">
                        <!-- Username -->
                        <label for="TxtUsername" style="font-size: 16px; text-align: center;">Username</label>
                        <asp:TextBox ID="TxtUsername" runat="server" CssClass="input-font">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckTxtUsername" runat="server"
                            ErrorMessage="Please enter a username."
                            ControlToValidate="TxtUsername"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ClientIDMode="Static">
                        </asp:RequiredFieldValidator>
                        <!-- Password -->
                        <label for="TxtPass" style="font-size: 16px; text-align: center;">Password</label>
                        <asp:TextBox ID="TxtPass" runat="server" TextMode="Password" CssClass="input-font">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckTxtPass" runat="server"
                            ErrorMessage="Please enter your password."
                            ControlToValidate="TxtPass"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ClientIDMode="Static">
                        </asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator
                            ID="PasswordValidator"
                            runat="server"
                            ControlToValidate="TxtPass"
                            ErrorMessage="Password must be 8-20 characters, have at least 1 lowercase (a-z), 1 uppercase (A-Z), and 1 symbol or number (0-9 or !@#$)."
                            ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9!@#$]).{8,20}$"
                            CssClass="validator-font"
                            Display="Dynamic">
                        </asp:RegularExpressionValidator>
                        <!-- Show Password Checkbox -->
                        <div class="content-font-style">
                            <asp:CheckBox ID="showPass" runat="server"
                                ClientIDMode="Static" Style="text-align: center;" Text="Show password" />
                        </div>
                        <br />
                        <!-- Login Phrase -->
                        <label for="TxtLoginPhrase" style="font-size: 16px; text-align: center;">Login Phrase</label>
                        <asp:TextBox ID="TxtLoginPhrase" runat="server" CssClass="input-font">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckLoginPhrase" runat="server"
                            ErrorMessage="Please enter your login phrase."
                            ControlToValidate="TxtLoginPhrase"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ClientIDMode="Static">
                        </asp:RequiredFieldValidator>
                    </div>
                    <div class="btn-align">
                        <asp:Button ID="BtnSubmit" runat="server" CssClass="btn-style" Text="Submit" />
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            var showPass = document.getElementById("showPass");
            var TxtPass = document.getElementById("TxtPass");

            showPass.addEventListener("change", function () {
                if (this.checked) {
                    TxtPass.type = "text";
                } else {
                    TxtPass.type = "password";
                }
            });
        });
    </script>
</body>
</html>
