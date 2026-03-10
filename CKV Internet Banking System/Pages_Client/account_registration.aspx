<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="account_registration.aspx.vb" Inherits="CKV_Internet_Banking_System.account_registration" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Register Online Banking Account</title>
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
                      <p class="logo-tagline">Secure. Smart. Seamless</p>
                      <div class="home-font-align">
                          <h4>Welcome to CKV Online Banking</h4>
                          <p>Enjoy convenient, safe and instant banking access to your CKV accounts online. Register an online banking account now, to perform your desired banking transactions swiftly.</p>
                          <p style="color: red; font-size: 14px;">Note: CKV Online Banking is only available for CKV Bank account holders.</p>

                      <p>Select Your Status</p>
                      <div class="btn-align">
                          <asp:Button ID="BtnCitizen" runat="server" CssClass="btn-style" Text="Citizen" />
                          <asp:Button ID="BtnForeigner" runat="server" CssClass="btn-style" Text="Foreigner" />
                      </div>
                      <a href="../index.html">Return to Home</a></div>

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
