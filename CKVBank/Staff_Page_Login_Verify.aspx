<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Staff_Page_Login_Verify.aspx.vb" Inherits="CKVBank.Staff_Page_Login_Verify" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin - Login Verify</title>
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

                    <!-- Greeting -->
                    <div class="content-font-align">
                        <label for="Hi">Hi,&nbsp;</label>
                        <asp:Label ID="lblUser" runat="server"></asp:Label>
                    </div>
                    <!-- Login Phrase -->
                    <div class="content-font-style">
                        <label for="lblPhrase" style="font-size: 16px; text-align: center;">Is this your login phrase? </label>
                        <asp:Label ID="lblPhrase" runat="server"
                            CssClass="content-phrase-align content-phrase-style"
                            Text=""></asp:Label>

                        <!-- Phrase Confirmation Radio Buttons -->
                        <asp:RadioButtonList ID="RblPhraseConfirm" runat="server"
                            AutoPostBack="True"
                            OnSelectedIndexChanged="RblPhraseConfirm_SelectedIndexChanged"
                            RepeatDirection="Horizontal">
                            <asp:ListItem Value="Yes">Yes</asp:ListItem>
                            <asp:ListItem Value="No">No</asp:ListItem> 
                        </asp:RadioButtonList>
                    </div>

                    <!-- Password Section (Initially Hidden) -->
                    <asp:Panel ID="panelPassword" runat="server" Visible="False">
                        <!-- Password Input -->
                        <div class="content-row content-font-style" id="lblPass">
                            <label for="txtPass" style="font-size: 14px; text-align: center;">Enter your Password</label>
                            <asp:TextBox ID="txtPass" runat="server"
                                ClientIDMode="Static"
                                TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="CheckTxtPass" runat="server"
                                ErrorMessage="Please enter your password."
                                ControlToValidate="txtPass"
                                CssClass="validator-font"
                                Display="Dynamic"
                                ClientIDMode="Static">
                            </asp:RequiredFieldValidator>
                        </div>

                        <!-- Show Password Checkbox -->
                        <div class="content-font-style">
                            <asp:CheckBox ID="showPass" runat="server"
                                ClientIDMode="Static" Style="text-align: center;" Text="Show password" />
                        </div>
                        <%--<!-- Forgot Password -->
                        <div class="content-font-style">
                            <asp:LinkButton ID="ForgotPass" runat="server"
                                Style="font-size: 12px; text-align: center; margin-top: 10px;"
                                CausesValidation="false">Forgot Password?</asp:LinkButton>
                        </div>--%>
                    </asp:Panel>

                    <!-- Login Button -->
                    <div class="btn-align">
                        <asp:Button ID="BtnLogin" runat="server"
                            CssClass="btn-style" Text="Login" />
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            var showPass = document.getElementById("showPass");
            var txtPass = document.getElementById("txtPass");

            showPass.addEventListener("change", function () {
                if (this.checked) {
                    txtPass.type = "text";
                } else {
                    txtPass.type = "password";
                }
            });
        });
    </script>
</body>
</html>
