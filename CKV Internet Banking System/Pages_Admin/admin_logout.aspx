<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="admin_logout.aspx.vb" Inherits="CKV_Internet_Banking_System.admin_logout" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CKV Bank - Secure. Smart. Seamless.</title>
    <link rel="stylesheet" href="../CSS/style.css"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="background-container">
              <div class="background-image-overlay-staff"></div>
              <div class="content-container">
                  <div class="content">
                        <div class="logo-align"><img class="logo-style" src="../Images/logo.png" /></div>
                        <p class="logo-tagline"> Secure. Smart. Seamless </p>
                        <div>
                             <p class="content-font-style" style="font-size:20px">You are now logged out</p>
                             <p class="content-font-style">Thank you for using CKV Internet Banking System</p>
                             <asp:Label ID="LogoutTimestamp" runat="server" CssClass="content-font-style"></asp:Label></div>
                             <br />
                             <div class="content-font-style">Accessed Time <asp:Label ID="TimeAccessed" runat="server"/>
                        </div>
                      <div class="btn-align">
                             <asp:Button ID="BtnBackHome" runat="server" CssClass="btn-style" Text="Return to Home" />
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