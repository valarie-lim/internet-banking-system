<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="view_statement.aspx.vb" Inherits="CKV_Internet_Banking_System.view_statement" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Account Statement</title>
    <link rel="stylesheet" href="../CSS/style.css"/>
    <style type="text/css">
        .grid {
            border-collapse: collapse;
            width: 100%;
        }

            .grid th, .grid td {
                padding: 8px;
                border: 1px solid #ccc;
            }

            .grid th {
                background-color: #333;
                color: #fff;
                font-weight: bold;
            }

            .grid tr:nth-child(even) {
                background-color: #f7f7f7;
            }
    </style>
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
                <h2>Account Statement</h2>

                <asp:DropDownList ID="ddlMonth" runat="server"></asp:DropDownList>
                <asp:DropDownList ID="ddlYear" runat="server"></asp:DropDownList>
                <asp:Button ID="BtnFilter" runat="server" Text="Filter" OnClick="BtnFilter_Click" />

                <br />
                <br />

                <asp:GridView ID="gvStatement" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="grid" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Horizontal" Width="1109px">
                    <Columns>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <%# If(Eval("trans_date") IsNot Nothing, Convert.ToDateTime(Eval("trans_date")).ToString("dd-MMM-yyyy HH:mm"), "") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Reference">
                            <ItemTemplate>
                                <%# GetReference(Eval("trans_description")) %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Description">
                            <ItemTemplate>
                                <%# GetDescription(Eval("trans_description")) %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Credit">
                            <ItemTemplate>
                                <%# If(Eval("CreditAmount") IsNot Nothing, String.Format("{0:N2}", Eval("CreditAmount")), "") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Debit">
                            <ItemTemplate>
                                <%# If(Eval("DebitAmount") IsNot Nothing, String.Format("{0:N2}", Eval("DebitAmount")), "") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Balance">
                            <ItemTemplate>
                                <%# If(Eval("RunningBalance") IsNot Nothing, String.Format("{0:N2}", Eval("RunningBalance")), "") %>
                            </ItemTemplate>
                        </asp:TemplateField>
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
                <br />
                <asp:Button ID="BtnExportPDF" runat="server" CssClass="btn-style" Text="Export To PDF" />
                <br />

            </div>
        </div>
    </form>
    <footer>
        <p>© DCS2102E Group Project by Group 2. All right reserved.</p>
        <p>Best viewed on the latest version of Chrome, Firefox, Edge, Safari, Opera.</p>
    </footer>
</body>
</html>