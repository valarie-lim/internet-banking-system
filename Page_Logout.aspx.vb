Public Class Page_Logout
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim loginTime As DateTime
            Dim logoutTime As DateTime

            If Session("LoginTime") IsNot Nothing Then
                loginTime = Convert.ToDateTime(Session("LoginTime"))
            End If

            If Session("LogoutTime") IsNot Nothing Then
                logoutTime = Convert.ToDateTime(Session("LogoutTime"))
                LogoutTimestamp.Text = logoutTime.ToString("dd-MMM-yyyy hh:mm tt")
            End If

            ' Only calculate duration if both exist
            If Session("LoginTime") IsNot Nothing AndAlso Session("LogoutTime") IsNot Nothing Then
                Dim duration As TimeSpan = logoutTime - loginTime
                Dim totalHours As Integer = duration.Days * 24 + duration.Hours
                TimeAccessed.Text = String.Format("{0} hours {1} minutes {2} seconds",
                                                  totalHours, duration.Minutes, duration.Seconds)
            End If
        End If
    End Sub

    Private Sub BtnBackHome_Click(sender As Object, e As EventArgs) Handles BtnBackHome.Click
        Response.Redirect("Page_Home.aspx")
    End Sub
End Class