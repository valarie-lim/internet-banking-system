<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewAccount.aspx.vb" Inherits="CKVBank.ViewAccount" %>

<<!DOCTYPE html>

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
                        <img class="logo-style" src="Images/logo.png" />
                    </div>
                    <asp:Button ID="BtnAccOverview" runat="server"
                        CssClass="btn-menu"
                        Style="margin-top: 50px;" Text="Account Overview" />
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
                        OnClientClick="return confirm('Are you sure you want to log out?');" />
                </div>
            </div>
            <div class="right-menu-container">
                Hi,&nbsp;
                <asp:Label ID="CustomerName" runat="server"></asp:Label>
                <br />
                <asp:Label ID="LoginTimestamp" runat="server" CssClass="timestamp-font-size"></asp:Label>
                <br />
                <br />
                <h2>View Account</h2>
                <br />
                <asp:Label ID="lblAccountHolder" runat="server" ForeColor="Red">Account Holder</asp:Label>
                <asp:TextBox ID="txtAccountHolder" runat="server" BackColor="White" ReadOnly="True"></asp:TextBox>
                <br />
                <br />
                <asp:Label ID="lblAccountType" runat="server" ForeColor="Red">Account Type</asp:Label>
                <asp:TextBox ID="txtAccountType" runat="server" BackColor="White" ReadOnly="True"></asp:TextBox>
                <br />
                <br />
                <asp:Label ID="lblCurrentBalance" runat="server" ForeColor="Red">Current Balance</asp:Label>
                <asp:TextBox ID="txtCurrentBalance" runat="server" BackColor="White" ReadOnly="True"></asp:TextBox>
                <br />
                <br />
                <asp:Label ID="lblAvailableBalance" runat="server" ForeColor="Red">Available Balance</asp:Label>
                <asp:TextBox ID="txtAvailableBalance" runat="server" BackColor="White" ReadOnly="True"></asp:TextBox>
                <br />
                <br />
                <asp:Label ID="lblStatementDate" runat="server" ForeColor="Red">Account Details as at:</asp:Label>
                <asp:TextBox ID="txtStatementDate" runat="server" BackColor="White" Width="308px" ReadOnly="True" Height="26px" Style="margin-bottom: 0px"></asp:TextBox>

                <br />
                <h2>Transaction History</h2>
                <!-- Date Range Panel -->
                <asp:Panel ID="pnlDateRange" runat="server">

                    <!-- From Date -->
                    <asp:TextBox ID="txtFromDate" runat="server" ReadOnly="true" />
                    <asp:Button ID="BtnShowCalFrom" runat="server" Text="📅" OnClick="BtnShowCalFrom_Click" />
                    <asp:Calendar ID="Calendar2" runat="server" Visible="False" OnSelectionChanged="CalFrom_SelectionChanged" />


                    <!-- Calendar (initially hidden at runtime) -->
                    <br />
                    <br />
                    <!-- To Date -->
                    <asp:TextBox ID="txtToDate" runat="server" ReadOnly="true" />
                    <asp:Button ID="BtnShowCalTo" runat="server" Text="📅" OnClick="BtnShowCalTo_Click" />
                    <asp:Calendar ID="CalTo" runat="server" Visible="False" OnSelectionChanged="CalTo_SelectionChanged" />

                    <!-- Calendar (initially hidden at runtime) -->
                    <br />
                    <br />
                    <!-- Filter Button -->
                    <asp:Button ID="BtnFilter" runat="server" Text="Show Transactions" OnClick="BtnFilter_Click" />
                    <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>

                </asp:Panel>

                <asp:GridView ID="gvStatement" runat="server" AutoGenerateColumns="False" CssClass="grid"
                    BorderColor="#ccc" BorderStyle="Solid" BorderWidth="1px" Height="239px" Width="1130px">
                <Columns>
                     <asp:BoundField DataField="TransactionDate" HeaderText="Date" DataFormatString="{0:dd/MM/yyyy}" NullDisplayText="" HtmlEncode="false" />
                     <asp:BoundField DataField="TransactionType" HeaderText="Transaction Details" NullDisplayText="" HtmlEncode="false" />
                     <asp:BoundField DataField="moneyin" HeaderText="Money In" DataFormatString="{0:N2}" HtmlEncode="False" NullDisplayText="" />
                     <asp:BoundField DataField="moneyout" HeaderText="Money Out" DataFormatString="{0:N2}" HtmlEncode="False" NullDisplayText="" />
                     <asp:BoundField DataField="Balance" HeaderText="Balance (RM)" DataFormatString="{0:N2}" HtmlEncode="False" NullDisplayText="" />
                </Columns>
                </asp:GridView>

                <br />
                <!-- Export Button -->
                <asp:Button ID="BtnExportPDF" runat="server" Text="Export to PDF" CssClass="btn-style" OnClick="BtnExportPDF_Click" />
            </div>
        </div>
    </form>
</body>
</html>



