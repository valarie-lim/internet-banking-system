<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Page_Register_Citizen.aspx.vb" Inherits="CKVBank.Page_Register_Citizen" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Local Registration</title>
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
                                    ClientIDMode="Static">
                                </asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="RevCustomerIC" runat="server"
                                    ControlToValidate="TxtCustomerIC"
                                    ErrorMessage="Please follow the format (e.g., 990201225560)."
                                    ValidationExpression="^\d{12}$"
                                    CssClass="validator-font"
                                    Display="Dynamic"
                                    ValidationGroup="RequiredFieldValidate"></asp:RegularExpressionValidator>
                            </div>
                        </div>
                    </div>
                    <br />
                    <div class="btn-align">
                        <asp:Button ID="BtnVerifyIC" runat="server"
                            CssClass="btn-style"
                            Text="Verify IC" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>