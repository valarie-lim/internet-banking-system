<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Page_Home.aspx.vb" Inherits="CKVBank.Page_Home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CKV Bank - Secure. Smart. Seamless.</title>
    <link rel="stylesheet" href="CSS/style.css"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="background-container">
              <div class="background-image-overlay"></div>
              <div class="content-container">
                  <div class="content">
                      <div class="logo-align">
                          <img class="logo-style" src="Images/logo.png" /></div>
                      <p class="logo-tagline">Secure. Smart. Seamless</p>
                      <div class="content-font-align">
                          <p>Your One Stop Financial Service</p>
                      </div>
                      <div class="btn-align">
                          <asp:Button ID="BtnRegister" runat="server" CssClass="btn-style" Text="Register" />
                          <asp:Button ID="BtnLogin" runat="server" CssClass="btn-style" Text="Login Now" />
                      </div>
                  </div>
              </div>
        </div>
    </form>
</body>
</html>
