<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Page_Main_Menu.aspx.vb" Inherits="CKVBank.Page_Main_Menu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Main Menu</title>
    <link rel="stylesheet" href="CSS/style.css"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="menu-container">
            <div class="side-menu-container">
                <div>
                    <div class="logo-align">
                        <img  class="logo-style" src="Images/logo.png" />
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
                    DataKeyNames="AccountId">
                    <Columns>
                        <asp:BoundField DataField="AccountNumber" HeaderText="Account Number" SortExpression="AccountNumber" />
                        <asp:BoundField DataField="AccountName" HeaderText="Account Name" SortExpression="AccountName" />
                        <asp:BoundField DataField="AccountType" HeaderText="Account Type" SortExpression="AccountType" />
                        <asp:BoundField DataField="Balance" HeaderText="Current Balance" SortExpression="Balance" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="AvailableBalance" HeaderText="Available Balance" SortExpression="AvailableBalance" DataFormatString="{0:C}" />
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
                           SELECT a.AccountNumber, a.AccountName, a.Balance, a.AvailableBalance, a.AccountType, a.AccountId
                           FROM Accounts a
                           INNER JOIN Login l ON a.UserIc = l.user_ic
                           WHERE l.Username = @Username">
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
</body>
</html>
