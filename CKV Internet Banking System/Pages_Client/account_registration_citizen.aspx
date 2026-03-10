<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="account_registration_citizen.aspx.vb" Inherits="CKV_Internet_Banking_System.account_registration_citizen" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Local Registration</title>
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
                            <!-- Malaysia Citizen IC Number -->
                            <div class="content-row">
                                <label for="txtCustomerIC" style="font-size: 16px; text-align: center;">Malaysia IC Number</label>
                                <asp:TextBox ID="TxtCustomerIC" runat="server"
                                    CssClass="input-font">
                                </asp:TextBox>
                                <div></div>
                                <!-- empty placeholder cell -->
                                <asp:RequiredFieldValidator ID="CheckTxtCustomerIC" runat="server"
                                    ErrorMessage="This field is required."
                                    ControlToValidate="TxtCustomerIC"
                                    CssClass="validator-font"
                                    Display="Dynamic"
                                    ClientIDMode="Static"
                                    ValidationGroup="RequiredFieldValidate">
                                </asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="RevCustomerIC" runat="server"
                                    ControlToValidate="TxtCustomerIC"
                                    ErrorMessage="Please follow the format (e.g., 990201225560)."
                                    ValidationExpression="^\d{12}$"
                                    CssClass="validator-font"
                                    Display="Dynamic"></asp:RegularExpressionValidator>
                            </div>
                        </div>
                    </div>
                    <br />
                    <div class="btn-align">
                        <asp:Button ID="BtnVerifyIC" runat="server"
                            CssClass="btn-style"
                            ValidationGroup="RequiredFieldValidate"
                            Text="Verify IC" />
                        <asp:Button ID="BtnCancel" runat="server"
                            CssClass="btn-style"
                            ClientIDMode="Static"
                            Text="Cancel" />
                    </div>
                </div>
            </div>
        </div>
    </form>
    <footer>
        <p>© DCS2102E Group 2 Project. All right reserved.</p>
        <p>Best viewed on the latest version of Chrome, Firefox, Edge, Safari, Opera.</p>
    </footer>
</body>
</html>