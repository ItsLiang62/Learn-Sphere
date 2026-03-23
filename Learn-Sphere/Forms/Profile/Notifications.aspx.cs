using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace Learn_Sphere.Forms.Profile
{
    public partial class Notifications : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Forms/Auth/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadNotifications();
                MarkNotificationsAsRead();
            }
        }

        private void LoadNotifications()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            string query = @"
                SELECT NotificationID, NotificationContent, DateCreated, IsRead
                FROM Notifications
                WHERE UserID = @UserID
                ORDER BY DateCreated DESC";

            DataTable dt = DatabaseHelper.ExecuteSelect(
                query,
                new SqlParameter("@UserID", userId)
            );

            rptNotifications.DataSource = dt;
            rptNotifications.DataBind();

            if (dt.Rows.Count == 0)
                lblMessage.Text = "No notifications yet.";
        }

        private void MarkNotificationsAsRead()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            DatabaseHelper.ExecuteNonQuery(
                @"UPDATE Notifications
                  SET IsRead = 1
                  WHERE UserID = @UserID AND IsRead = 0",
                new SqlParameter("@UserID", userId)
            );
        }
    }
}