Imports System.Data.SqlClient
Imports System.IO
Imports System.Web.UI.WebControls
Imports iTextSharp.text
Imports iTextSharp.text.pdf
Imports iTextSharp.text.pdf.draw

Public Class Page_View_Statement
    Inherits System.Web.UI.Page

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            PopulateMonthDropdown()
            PopulateYearDropdown()
            LoadTransactions()
        End If
    End Sub

    ' ---------------- Split trans_description by last dash ----------------
    Protected Function GetReference(transDesc As Object) As String
        If transDesc Is Nothing Then Return ""
        Dim desc As String = transDesc.ToString()
        Dim lastDash As Integer = desc.LastIndexOf("-"c)
        If lastDash >= 0 Then
            Return desc.Substring(0, lastDash).Trim()
        End If
        Return desc.Trim()
    End Function

    Protected Function GetDescription(transDescription As Object) As String
        If transDescription Is Nothing Then Return ""
        Dim desc As String = transDescription.ToString()
        Dim lastDash As Integer = desc.LastIndexOf("-"c)
        If lastDash >= 0 AndAlso lastDash < desc.Length - 1 Then
            Return desc.Substring(lastDash + 1).Trim()
        End If
        Return ""
    End Function

    ' ---------------- Dropdown setup ----------------
    Private Sub PopulateYearDropdown()
        ddlYear.Items.Clear()
        ddlYear.Items.Add(New System.Web.UI.WebControls.ListItem("--Select Year--", ""))
        For y As Integer = DateTime.Now.Year To DateTime.Now.Year - 5 Step -1
            ddlYear.Items.Add(New System.Web.UI.WebControls.ListItem(y.ToString(), y.ToString()))
        Next
    End Sub

    Private Sub PopulateMonthDropdown()
        ddlMonth.Items.Clear()
        ddlMonth.Items.Add(New System.Web.UI.WebControls.ListItem("--Select Month--", ""))
        For i As Integer = 1 To 12
            ddlMonth.Items.Add(New System.Web.UI.WebControls.ListItem(New DateTime(2000, i, 1).ToString("MMMM"), i.ToString()))
        Next
    End Sub

    ' ---------------- Core data fetch ----------------
    Private Function GetTransactions(Optional month As Integer? = Nothing, Optional year As Integer? = Nothing) As DataTable
        Dim accountId As Integer = Convert.ToInt32(Request.QueryString("accountId"))
        Dim dt As New DataTable()

        Dim query As String = "
            SELECT t.trans_date,
                   t.trans_description,
                   CASE WHEN t.from_acc = a.account_number AND t.trans_type = 'DEBIT' THEN t.trans_amount END AS DebitAmount,
                   CASE WHEN t.to_acc = a.account_number AND t.trans_type = 'CREDIT' THEN t.trans_amount END AS CreditAmount
            FROM transactions t
            INNER JOIN account a ON (t.from_acc = a.account_number OR t.to_acc = a.account_number)
            WHERE a.account_id = @AccountId
              AND ((t.from_acc = a.account_number AND t.trans_type = 'DEBIT')
                OR (t.to_acc = a.account_number AND t.trans_type = 'CREDIT'))"

        If month.HasValue Then query &= " AND MONTH(t.trans_date) = @Month"
        If year.HasValue Then query &= " AND YEAR(t.trans_date) = @Year"
        query &= " ORDER BY t.trans_date ASC"

        Using connection As New SqlConnection(connectionString)
            Using cmd As New SqlCommand(query, connection)
                cmd.Parameters.AddWithValue("@AccountId", accountId)
                If month.HasValue Then cmd.Parameters.AddWithValue("@Month", month.Value)
                If year.HasValue Then cmd.Parameters.AddWithValue("@Year", year.Value)
                Using adapter As New SqlDataAdapter(cmd)
                    adapter.Fill(dt)
                End Using
            End Using
        End Using

        ' Add RunningBalance column
        dt.Columns.Add("RunningBalance", GetType(Decimal))

        ' Compute opening balance if filter applied
        Dim balance As Decimal = 0D
        If month.HasValue AndAlso year.HasValue Then
            balance = GetOpeningBalance(accountId, month.Value, year.Value)

            ' Insert Balance B/F row
            Dim bfRow As DataRow = dt.NewRow()
            bfRow("trans_date") = New DateTime(year.Value, month.Value, 1).AddSeconds(-1)
            bfRow("trans_description") = "Balance B/F"
            bfRow("RunningBalance") = balance
            bfRow("CreditAmount") = DBNull.Value
            bfRow("DebitAmount") = DBNull.Value
            dt.Rows.InsertAt(bfRow, 0)
        End If

        ' Calculate running balance
        For Each row As DataRow In dt.Rows
            Dim credit As Decimal = If(IsDBNull(row("CreditAmount")), 0D, Convert.ToDecimal(row("CreditAmount")))
            Dim debit As Decimal = If(IsDBNull(row("DebitAmount")), 0D, Convert.ToDecimal(row("DebitAmount")))
            balance += credit
            balance -= debit
            row("RunningBalance") = balance
        Next

        Return dt
    End Function

    Private Sub LoadTransactions(Optional month As Integer? = Nothing, Optional year As Integer? = Nothing)
        Dim dt As DataTable = GetTransactions(month, year)
        gvStatement.DataSource = dt
        gvStatement.DataBind()
    End Sub

    Private Function GetOpeningBalance(accountId As Integer, month As Integer, year As Integer) As Decimal
        Dim balance As Decimal = 0D

        Dim query As String = "
            SELECT 
                SUM(CASE WHEN t.to_acc = a.account_number AND t.trans_type = 'CREDIT' THEN t.trans_amount ELSE 0 END) - 
                SUM(CASE WHEN t.from_acc = a.account_number AND t.trans_type = 'DEBIT' THEN t.trans_amount ELSE 0 END)
            FROM transactions t
            INNER JOIN account a ON (t.from_acc = a.account_number OR t.to_acc = a.account_number)
            WHERE a.account_id = @AccountId
              AND t.trans_date < @StartDate
              AND ((t.from_acc = a.account_number AND t.trans_type = 'DEBIT')
                OR (t.to_acc = a.account_number AND t.trans_type = 'CREDIT'))"

        Using connection As New SqlConnection(connectionString)
            Using cmd As New SqlCommand(query, connection)
                cmd.Parameters.AddWithValue("@AccountId", accountId)
                cmd.Parameters.AddWithValue("@StartDate", New DateTime(year, month, 1))
                connection.Open()
                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                    balance = Convert.ToDecimal(result)
                End If
            End Using
        End Using

        Return balance
    End Function

    ' ---------------- Button: Filter ----------------
    Protected Sub BtnFilter_Click(sender As Object, e As EventArgs)
        Dim month As Integer? = Nothing
        Dim year As Integer? = Nothing
        If Not String.IsNullOrEmpty(ddlMonth.SelectedValue) Then month = Convert.ToInt32(ddlMonth.SelectedValue)
        If Not String.IsNullOrEmpty(ddlYear.SelectedValue) Then year = Convert.ToInt32(ddlYear.SelectedValue)
        LoadTransactions(month, year)
    End Sub

    ' ---------------- Button: Export PDF ----------------
    Protected Sub BtnExportPDF_Click(sender As Object, e As EventArgs) Handles BtnExportPDF.Click
        Dim month As Integer? = Nothing
        Dim year As Integer? = Nothing
        If Not String.IsNullOrEmpty(ddlMonth.SelectedValue) Then month = Convert.ToInt32(ddlMonth.SelectedValue)
        If Not String.IsNullOrEmpty(ddlYear.SelectedValue) Then year = Convert.ToInt32(ddlYear.SelectedValue)

        Dim dt As DataTable = GetTransactions(month, year)

        ' --- Fetch account info ---
        Dim accountId As Integer = Convert.ToInt32(Request.QueryString("accountId"))
        Dim accountNumber As String = ""
        Dim accountHolder As String = ""
        Using connection As New SqlConnection(connectionString)
            Dim query As String = "SELECT account_number, account_name FROM account WHERE account_id = @AccountId"
            Using cmd As New SqlCommand(query, connection)
                cmd.Parameters.AddWithValue("@AccountId", accountId)
                connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        accountNumber = reader("account_number").ToString()
                        accountHolder = reader("account_name").ToString()
                    End If
                End Using
            End Using
        End Using

        ' --- Create PDF ---
        Dim doc As New Document(PageSize.A4, 20, 20, 40, 40) ' top & bottom margin bigger for header/footer
        Dim ms As New MemoryStream()
        Dim writer As PdfWriter = PdfWriter.GetInstance(doc, ms)

        doc.Open()

        ' Fonts
        Dim bankInfoFont = FontFactory.GetFont("Arial", 10, Font.NORMAL)
        Dim titleFont = FontFactory.GetFont("Arial", 14, Font.BOLD)
        Dim normalFont = FontFactory.GetFont("Arial", 10, Font.NORMAL)

        ' --- Bank Logo ---
        Dim logoPath As String = Server.MapPath("~/Images/logo.png")
        If File.Exists(logoPath) Then
            Dim logo As iTextSharp.text.Image = iTextSharp.text.Image.GetInstance(logoPath)
            logo.ScaleToFit(120.0F, 60.0F)
            logo.Alignment = Element.ALIGN_CENTER
            doc.Add(logo)
        End If

        ' --- Bank Header ---
        Dim bankAddress As Paragraph = CreateCenteredTitle("123 Jalan Bank, Kuala Lumpur, Malaysia", bankInfoFont)
        doc.Add(bankAddress)
        Dim bankContact As Paragraph = CreateCenteredTitle("Phone: +60 3-1234 5678 | Email: info@ckvbank.com", bankInfoFont)
        doc.Add(bankContact)

        'doc.Add(New Paragraph("123 Jalan Bank, Kuala Lumpur, Malaysia", bankInfoFont))
        'doc.Add(New Paragraph("Phone: +60 3-1234 5678 | Email: info@ckvbank.com", bankInfoFont))
        doc.Add(New Chunk(New LineSeparator()))
        doc.Add(New Paragraph(" "))

        ' --- Account Statement Info ---
        Dim pdfTitle As Paragraph = CreateCenteredTitle("Account Statement", titleFont)
        doc.Add(pdfTitle)

        doc.Add(New Paragraph("Account Holder: " & accountHolder, normalFont))
        doc.Add(New Paragraph("Account Number: " & accountNumber, normalFont))
        If month.HasValue AndAlso year.HasValue Then
            Dim period As String = New DateTime(year.Value, month.Value, 1).ToString("MMMM yyyy")
            doc.Add(New Paragraph("Statement Period: " & period, normalFont))
        Else
            doc.Add(New Paragraph("Statement Period: All Transactions", normalFont))
        End If
        doc.Add(New Paragraph("Generated on: " & DateTime.Now.ToString("dd-MMM-yyyy HH:mm"), normalFont))
        doc.Add(New Paragraph(" "))

        ' --- Transaction Table ---
        Dim columns As New List(Of String) From {"trans_date", "Reference", "Description", "CreditAmount", "DebitAmount", "RunningBalance"}
        Dim headers As New Dictionary(Of String, String) From {
        {"trans_date", "Date"},
        {"Reference", "Reference"},
        {"Description", "Description"},
        {"CreditAmount", "Credit"},
        {"DebitAmount", "Debit"},
        {"RunningBalance", "Balance"}
    }

        Dim table As New PdfPTable(columns.Count) With {
    .WidthPercentage = 100
    }
        table.SetWidths(New Single() {15, 25, 20, 10, 10, 10})

        ' Table headers
        For Each colName As String In columns
            Dim cell As New PdfPCell(New Phrase(headers(colName), FontFactory.GetFont("Arial", 10, Font.BOLD))) With {
        .BackgroundColor = BaseColor.LIGHT_GRAY,
        .HorizontalAlignment = Element.ALIGN_CENTER,
        .VerticalAlignment = Element.ALIGN_MIDDLE,
        .Padding = 5
    }
            table.AddCell(cell)
        Next

        ' Table rows
        For Each row As DataRow In dt.Rows
            For Each colName As String In columns
                Dim text As String = ""
                If colName = "Reference" Then
                    text = GetReference(row("trans_description"))
                ElseIf colName = "Description" Then
                    text = GetDescription(row("trans_description"))
                ElseIf Not row.IsNull(colName) Then
                    Select Case colName
                        Case "trans_date"
                            text = Convert.ToDateTime(row(colName)).ToString("dd-MMM-yyyy HH:mm")
                        Case "CreditAmount", "DebitAmount", "RunningBalance"
                            text = String.Format("{0:N2}", Convert.ToDecimal(row(colName)))
                        Case Else
                            text = row(colName).ToString()
                    End Select
                End If

                Dim cell As New PdfPCell(New Phrase(text, FontFactory.GetFont("Arial", 10)))
                ' Align numeric columns to right, text columns to left
                If colName = "CreditAmount" Or colName = "DebitAmount" Or colName = "RunningBalance" Then
                    cell.HorizontalAlignment = Element.ALIGN_RIGHT
                Else
                    cell.HorizontalAlignment = Element.ALIGN_LEFT
                End If
                cell.VerticalAlignment = Element.ALIGN_MIDDLE
                cell.Padding = 5
                table.AddCell(cell)
            Next
        Next

        doc.Add(table)
        doc.Close()

        ' --- Send PDF ---
        Response.ContentType = "application/pdf"
        Response.AddHeader("content-disposition", $"attachment;filename=Statement_{accountNumber}_{DateTime.Now:yyyyMMddHHmmss}.pdf")
        Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.BinaryWrite(ms.ToArray())
        Response.End()
    End Sub

    ' Helper function to create a centered title
    Public Function CreateCenteredTitle(text As String, font As Font) As Paragraph
        Dim paragraph As New Paragraph(text, font) With {
        .Alignment = Element.ALIGN_CENTER
    }
        Return paragraph
    End Function












    ' six event for the side menu button
    Private Sub BtnAccOverview_Click(sender As Object, e As EventArgs) Handles BtnAccOverview.Click
        Response.Redirect("Page_Main_Menu.aspx")
    End Sub

    Private Sub BtnFundTransfer_Click(sender As Object, e As EventArgs) Handles BtnFundTransfer.Click
        Response.Redirect("Page_Fund_Transfer.aspx")
    End Sub

    Private Sub BtnBillPayment_Click(sender As Object, e As EventArgs) Handles BtnBillPayment.Click
        Response.Redirect("Page_Bill_Payment.aspx")
    End Sub

    Private Sub BtnUpdateProfile_Click(sender As Object, e As EventArgs) Handles BtnUpdateProfile.Click
        Response.Redirect("Page_Update_Profile.aspx")
    End Sub

    Private Sub BtnContactUs_Click(sender As Object, e As EventArgs) Handles BtnContactUs.Click
        Response.Redirect("Page_Contact_Us.aspx")
    End Sub

    Private Sub BtnLogout_Click(sender As Object, e As EventArgs) Handles BtnLogout.Click
        ' Save logout timestamp in session
        Dim utcNow As DateTime = DateTime.UtcNow
        Session("LogoutTime") = TimeZoneInfo.ConvertTimeFromUtc(utcNow, TimeZoneInfo.FindSystemTimeZoneById("Singapore Standard Time"))
        ' Update database
        Dim connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("CkvBankDBConnection").ConnectionString
        Dim updateSql As String = "
            UPDATE dbo.login
            SET logout_time = @logoutTime
            WHERE username = @username"
        Using connection As New SqlConnection(connectionString)
            Using command As New SqlCommand(updateSql, connection)
                command.Parameters.AddWithValue("@logoutTime", utcNow)
                command.Parameters.AddWithValue("@username", Session("Username").ToString())
                connection.Open()
                command.ExecuteNonQuery()
            End Using
        End Using
        ' Redirect after update
        Response.Redirect("Page_Logout.aspx")
    End Sub

End Class