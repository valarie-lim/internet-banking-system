<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="view_account.aspx.vb" Inherits="CKV_Internet_Banking_System.view_account" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>View Account</title>
    <link rel="stylesheet" href="../CSS/style.css"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="menu-container">
            <div class="side-menu-container">
                <div>
                    <div class="logo-align">
                        <img class="logo-style" src="../Images/logo.png" />
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
                Hi,&nbsp;<asp:Label ID="CustomerName" runat="server"></asp:Label>
                <br />
                <asp:Label ID="LoginTimestamp" runat="server" CssClass="timestamp-font-size"></asp:Label>
                <br />
                <br />
                <h2>View Account</h2>
                <asp:Label ID="lblAccountHolder" runat="server" ForeColor="Red">Account Holder</asp:Label>
                <asp:Label ID="txtAccountHolder" runat="server"></asp:Label>
                <br />
                <br />
                <asp:Label ID="lblAccountType" runat="server" ForeColor="Red">Account Type</asp:Label>
                <asp:Label ID="txtAccountType" runat="server"></asp:Label>
                <br />
                <br />
                <asp:Label ID="lblCurrentBalance" runat="server" ForeColor="Red">Current Balance</asp:Label>
                <asp:Label ID="txtCurrentBalance" runat="server"></asp:Label>
                <br />
                <br />
                <asp:Label ID="lblAvailableBalance" runat="server" ForeColor="Red">Available Balance</asp:Label>
                <asp:Label ID="txtAvailableBalance" runat="server"></asp:Label>
                <br />
                <br />
                <asp:Label ID="lblStatementDate" runat="server" ForeColor="Red">Account Details as at:</asp:Label>
                <asp:Label ID="txtStatementDate" runat="server"
                    ReadOnly="True"></asp:Label>
                <br />
                <br />
                <h2>Account Transaction</h2>
                <asp:GridView ID="gvStatement" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="grid"
                    BorderColor="#CCCCCC"
                    BorderStyle="None"
                    BorderWidth="1px"
                    Height="239px" Width="1130px"
                    AllowPaging="True"
                    DataSourceID="SqlDataSource_transaction"
                    BackColor="White"
                    CellPadding="4"
                    ForeColor="Black"
                    GridLines="Horizontal">
                    <Columns>
                        <asp:BoundField DataField="trans_date" HeaderText="Date" SortExpression="trans_date" DataFormatString="{0:dd-MMM-yyyy HH:mm}" />

                        <asp:TemplateField HeaderText="References">
                            <ItemTemplate>
                                <%# GetReference(Eval("trans_description")) %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Description">
                            <ItemTemplate>
                                <%# GetDescription(Eval("trans_description")) %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="CreditAmount" HeaderText="Credit"
                            DataFormatString="{0:N2}" HtmlEncode="False" />

                        <asp:BoundField DataField="DebitAmount" HeaderText="Debit"
                            DataFormatString="{0:N2}" HtmlEncode="False" />
                    </Columns>
                    <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
                    <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Right" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
                    <SortedAscendingCellStyle BackColor="#F7F7F7" />
                    <SortedAscendingHeaderStyle BackColor="#4B4B4B" />
                    <SortedDescendingCellStyle BackColor="#E5E5E5" />
                    <SortedDescendingHeaderStyle BackColor="#242121" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource_transaction" runat="server"
                    ConnectionString="<%$ ConnectionStrings:CkvBankDBConnection %>"
                    SelectCommand="SELECT t.trans_date, t.trans_description,
                        CASE WHEN t.from_acc = a.account_number AND t.trans_type = 'DEBIT' THEN t.trans_amount END AS DebitAmount,
                        CASE WHEN t.to_acc = a.account_number AND t.trans_type = 'CREDIT' THEN t.trans_amount END AS CreditAmount
                        FROM transactions t
                        INNER JOIN account a ON (t.from_acc = a.account_number OR t.to_acc = a.account_number)
                        WHERE a.account_id = @AccountId
                          AND ((t.from_acc = a.account_number AND t.trans_type = 'DEBIT')
                            OR (t.to_acc = a.account_number AND t.trans_type = 'CREDIT'))
                        ORDER BY t.trans_date DESC">
                    <SelectParameters>
                        <asp:SessionParameter Name="AccountId" SessionField="SelectedAccountId" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>

                <br />
                <!-- View Statement Button -->
                <asp:Button ID="BtnViewStatement" runat="server" 
                    Text="View Statement" 
                    CssClass="btn-style" />
            </div>
        </div>
    </form>
    <footer>
        <p>© DCS2102E Group Project by Group 2. All right reserved.</p>
        <p>Best viewed on the latest version of Chrome, Firefox, Edge, Safari, Opera.</p>
    </footer>
</body>
</html>