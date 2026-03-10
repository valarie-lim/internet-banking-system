<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="client_management.aspx.vb" Inherits="CKV_Internet_Banking_System.client_management" %>

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
                    <asp:Button ID="BtnDashboard" runat="server" 
                        CssClass="btn-menu" Style="margin-top:50px;" Text="Dashboard"/>
                    <asp:Button ID="BtnUpdateProfile" runat="server" 
                        CssClass="btn-menu" Text="My Profile" />
                    <asp:Button ID="BtnLogout" runat="server" 
                        CssClass="btn-menu" Text="Logout" 
                        OnClientClick="return confirm('Are you sure you want to log out?');"/>
                </div>
            </div>
            <div class="right-menu-container">
                Hi,&nbsp;<asp:Label ID="EmployeeName" runat="server"></asp:Label>
                <br />
                <asp:Label ID="LoginTimestamp" runat="server" CssClass="timestamp-font-size"></asp:Label>
                <br />
                <br />
                <h2>Customer Management</h2>
                <br />
                <asp:TextBox ID="txtSearchName" runat="server"
                    Placeholder="Enter Full Name..." Width="250px"></asp:TextBox>
                <asp:Button ID="BtnSearch" runat="server" Text="Search" />
                <br />
                <br />
                <asp:GridView ID="GridView1" runat="server"
                    AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px"
                    CellPadding="3" DataSourceID="SqlDataSource_CustomerInformation"
                    ForeColor="Black" GridLines="Vertical" Width="1209px"
                    DataKeyNames="user_ic">

                    <AlternatingRowStyle BackColor="#CCCCCC" />
                    <Columns>
                        <asp:BoundField DataField="user_ic" HeaderText="IC" SortExpression="user_ic" ReadOnly="True" />
                        <asp:BoundField DataField="full_name" HeaderText="Full Name" SortExpression="full_name" ReadOnly="True" />
                        <asp:BoundField DataField="dob" HeaderText="Date of Birth" SortExpression="dob" ReadOnly="True"
                            DataFormatString="{0:dd/MM/yyyy}" HtmlEncode="False" />
                        <asp:BoundField DataField="gender" HeaderText="Gender" SortExpression="gender" ReadOnly="True" />
                        <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" ReadOnly="True" />
                        <asp:BoundField DataField="acc_status" HeaderText="Status" SortExpression="acc_status" />
                        <asp:BoundField DataField="failed_attempts" HeaderText="Attempts" SortExpression="failed_attempts" />
                        <asp:CommandField ShowEditButton="True" />
                        <asp:CommandField ShowSelectButton="True" />
                    </Columns>
                    <FooterStyle BackColor="#CCCCCC" />
                    <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                    <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
                    <SortedAscendingCellStyle BackColor="#F1F1F1" />
                    <SortedAscendingHeaderStyle BackColor="Gray" />
                    <SortedDescendingCellStyle BackColor="#CAC9C9" />
                    <SortedDescendingHeaderStyle BackColor="#383838" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource_CustomerInformation" runat="server"
                    ConnectionString="<%$ ConnectionStrings:CkvBankDBConnection %>"
                    SelectCommand="
                        SELECT c.user_ic, c.full_name, c.dob, c.gender, c.email, l.acc_status, l.failed_attempts
                                
                        FROM customer c
                        LEFT JOIN login l ON c.user_ic = l.user_ic
                        WHERE LTRIM(RTRIM(c.full_name)) = LTRIM(RTRIM(@full_name))"
                    UpdateCommand="
                        UPDATE login
                        SET acc_status = @acc_status, failed_attempts = @failed_attempts
                        WHERE user_ic = @original_user_ic;"
                    OldValuesParameterFormatString="original_{0}">

                    <SelectParameters>
                        <asp:ControlParameter Name="full_name" ControlID="txtSearchName" PropertyName="Text" Type="String" />
                    </SelectParameters>

                    <UpdateParameters>
                        <asp:Parameter Name="acc_status" Type="String" />
                        <asp:Parameter Name="failed_attempts" Type="Int32" />
                        <asp:Parameter Name="original_user_ic" Type="String" />
                    </UpdateParameters>
                </asp:SqlDataSource>
                <br />
                <asp:Button ID="BtnEmailCustomer" runat="server"
                    CssClass="btn-style" 
                    Visible="False"
                    Text="Send Reactivation Email" />
            </div>
        </div>
    </form>
    <footer>
        <p>© DCS2102E Group Project by Group 2. All right reserved.</p>
        <p>Best viewed on the latest version of Chrome, Firefox, Edge, Safari, Opera.</p>
    </footer>
</body>
</html>
