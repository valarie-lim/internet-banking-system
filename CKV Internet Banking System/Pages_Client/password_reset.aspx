<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="password_reset.aspx.vb" Inherits="CKV_Internet_Banking_System.password_reset" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reset Password</title>
    <link rel="stylesheet" href="../CSS/style.css"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="background-container">
            <div class="background-image-overlay"></div>
            <div class="content-container">
            <div class="content">
                <div class="logo-align"><img class="logo-style" src="../Images/logo.png" /></div>
                <p class="logo-tagline"> Secure. Smart. Seamless </p>
                <p>Please enter a secure password.</p>
                <div class="content-row">
                    <!-- New Password -->
                    <label for="TxtNewPass" style="font-size: 16px; text-align:center;">New Password</label>
                    <asp:TextBox ID="TxtNewPass" runat="server" TextMode="Password" CssClass="input-font">
                    </asp:TextBox>
                    <div></div> <!-- empty placeholder cell -->
                    <asp:RequiredFieldValidator ID="CheckTxtNewPass" runat="server"
                        ErrorMessage="Please enter your new password."
                        ControlToValidate="TxtNewPass"
                        CssClass="validator-font"
                        Display="Dynamic" 
                        ClientIDMode="Static">
                    </asp:RequiredFieldValidator>
                    <!-- Validator to check New Pass Format -->
                    <asp:RegularExpressionValidator
                        ID="PasswordValidator"
                        runat="server"
                        ControlToValidate="TxtNewPass"
                        ErrorMessage="Password must be 8-20 characters, have at least 1 lowercase (a-z), 1 uppercase (A-Z), and 1 symbol or number (0-9 or !@#$)."
                        ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9!@#$]).{8,20}$"
                        CssClass="validator-font"
                        Display="Dynamic">
                    </asp:RegularExpressionValidator>

                    <!-- Confirm New Password -->
                    <label for="TxtVerifyNewPass" class="label-font" style="font-size:16px; text-align:center;">Confirm Password</label>
                    <asp:TextBox ID="TxtVerifyNewPass" runat="server" TextMode="Password" CssClass="input-font">
                    </asp:TextBox>
                    <asp:RequiredFieldValidator ID="CheckVerifyNewPass" runat="server"
                        ErrorMessage="Please confirm your password."
                        ControlToValidate="TxtVerifyNewPass"
                        CssClass="validator-font"
                        Display="Dynamic" 
                        ClientIDMode="Static">
                    </asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvVerifyNewPass" runat="server"
                        ControlToCompare="TxtNewPass"
                        ControlToValidate="TxtVerifyNewPass"
                        ErrorMessage="Password not match! Please check."
                        CssClass="validator-font">
                    </asp:CompareValidator>

                    <!-- Show Password Checkbox -->
                    <div class="content-font-style">
                        <asp:CheckBox ID="showPass" runat="server"
                            ClientIDMode="Static" Style="text-align: center;" Text="Show password" />
                    </div>
                </div>
                    <!-- Reset Button -->
                <div class="btn-align">
                    <asp:Button ID="BtnResetPass" runat="server" CssClass="btn-style" Text="Reset Now" />
                </div>
              </div>
            </div>
        </div>
    </form>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            var checkbox = document.getElementById("showPass");
            var txtNewPass = document.getElementById("TxtNewPass");
            var txtVerifyNewPass = document.getElementById("TxtVerifyNewPass");

            checkbox.addEventListener("change", function () {
                if (this.checked) {
                    txtNewPass.type = "text";
                    txtVerifyNewPass.type = "text";
                } else {
                    txtNewPass.type = "password";
                    txtVerifyNewPass.type = "password";
                }
            });
        });
    </script>
    <footer>
        <p>© DCS2102E Group Project by Group 2. All right reserved.</p>
        <p>Best viewed on the latest version of Chrome, Firefox, Edge, Safari, Opera.</p>
    </footer>
</body>
</html>
