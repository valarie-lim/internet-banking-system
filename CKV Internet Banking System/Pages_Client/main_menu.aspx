<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="main_menu.aspx.vb" Inherits="CKV_Internet_Banking_System.main_menu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Main Menu</title>
    <link rel="stylesheet" href="../CSS/style.css"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="menu-container">
            <div class="side-menu-container">
                <div>
                    <div class="logo-align">
                        <img  class="logo-style" src="../Images/logo.png" />
                    </div>
                    <asp:Button ID="BtnAccOverview" runat="server" 
                        CssClass="btn-menu" 
                        Style="margin-top:50px;" Text="Account Overview"/>
                    <asp:Button ID="BtnFundTransfer" runat="server" 
                        CssClass="btn-menu" Text="Fund Transfer" />
                    <asp:Button ID="BtnBillPayment" runat="server" 
                        CssClass="btn-menu" Text="Bill Payment" />
                    <asp:Button ID="BtnUpdateProfile" runat="server" 
                        CssClass="btn-menu" Text="Update Profile" />
                    <asp:Button ID="BtnContactUs" runat="server" 
                        CssClass="btn-menu" Text="Contact Us" />
                    <asp:Button ID="BtnLogout" runat="server" 
                        CssClass="btn-menu" Text="Logout" 
                        OnClientClick="return confirm('Are you sure you want to log out?');"/>
                </div>
            </div>
            <div class="right-menu-container">
                Hi,&nbsp;<asp:Label ID="CustomerName" runat="server"></asp:Label>
                <br />
                <asp:Label ID="LoginTimestamp" runat="server" CssClass="timestamp-font-size"></asp:Label>
                <br />
                <br />
                <h2>My Account Overview</h2>
                <!-- Grid View Table (2 column * 1 rows) display account type, total balance -->
                <asp:GridView ID="GridView1" runat="server"
                    AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#CC9966" BorderStyle="None" BorderWidth="1px"
                    CellPadding="4" DataSourceID="SqlDataSource_AccountOverview" Width="987px"
                    OnSelectedIndexChanged="GridView1_SelectedIndexChanged"
                    DataKeyNames="account_id">
                    <Columns>
                        <asp:BoundField DataField="account_number" HeaderText="Account Number" SortExpression="AccountNumber" />
                        <asp:BoundField DataField="account_type" HeaderText="Account Type" SortExpression="AccountType" />
                        <asp:BoundField DataField="current_balance" HeaderText="Current Balance" SortExpression="Balance" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="available_balance" HeaderText="Available Balance" SortExpression="AvailableBalance" DataFormatString="{0:C}" />
                        <asp:CommandField ShowSelectButton="True" SelectText="✔" />
                    </Columns>
                    <FooterStyle BackColor="#FFFFCC" ForeColor="#330099" />
                    <HeaderStyle BackColor="#363535" Font-Bold="True" ForeColor="#FFFFFF" />
                    <PagerStyle BackColor="#FFFFCC" ForeColor="#330099" HorizontalAlign="Center" />
                    <RowStyle BackColor="White" ForeColor="#330099" />
                    <SelectedRowStyle BackColor="#ffeecc" Font-Bold="True" ForeColor="#FF0000" />
                    <SortedAscendingCellStyle BackColor="#FEFCEB" />
                    <SortedAscendingHeaderStyle BackColor="#AF0101" />
                    <SortedDescendingCellStyle BackColor="#F6F0C0" />
                    <SortedDescendingHeaderStyle BackColor="#7E0000" />
                </asp:GridView>

                <asp:SqlDataSource ID="SqlDataSource_AccountOverview" runat="server"
                    ConnectionString="<%$ ConnectionStrings:CkvBankDBConnection %>"
                    SelectCommand="
                           SELECT a.account_number, a.account_name, a.current_balance, a.available_balance, a.account_type, a.account_id
                           FROM account a
                           INNER JOIN login l ON a.user_ic = l.user_ic
                           WHERE l.username = @Username">
                    <SelectParameters>
                        <asp:SessionParameter Name="Username" SessionField="Username" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>

                <br />
                <br />
                <asp:Button ID="BtnViewAccount" runat="server"
                    CssClass="btn-style" 
                    Visible="False" 
                    Text="View Account" />

            </div>
        </div>
    </form>
    <footer>
        <p>© DCS2102E Group Project by Group 2. All right reserved.</p>
        <p>Best viewed on the latest version of Chrome, Firefox, Edge, Safari, Opera.</p>
    </footer>
</body>
</html>