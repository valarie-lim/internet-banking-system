<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Page_Register_Account.aspx.vb" Inherits="CKVBank.Page_Register_Account" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Register Online Banking Account</title>
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
                      <div style="text-align:center">
                          <h4>
                              Welcome to the CKV Online Banking.</h4>
                              <h5>Enjoy convenient, safe and instant banking access to your CKV accounts online.
                              Register an online banking account now, to perform your desired banking transactions swiftly.
                                  </h5>
                              <h6 style="color: red;">Note: CKV Online Banking is only available for CKV Bank account holders.</h6>
                          
                          <p>Please Select Your Status</p>
                      </div>
                      <div class="btn-align">
                          <asp:Button ID="BtnCitizen" runat="server" CssClass="btn-style" Text="Citizen" />
                          <asp:Button ID="BtnForeigner" runat="server" CssClass="btn-style" Text="Foreigner" />
                      </div>
                  </div>
              </div>
        </div>
    </form>
</body>
</html>