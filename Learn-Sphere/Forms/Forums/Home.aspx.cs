using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;


namespace Learn_Sphere.Forms.Forums
{
    public partial class Home : System.Web.UI.Page
    {
        protected int CurrentUserID = 0;
        protected bool IsAdmin = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                CurrentUserID = Convert.ToInt32(Session["UserID"]);
            }

            if (Session["Role"] != null && Session["Role"].ToString() == "Administrator")
            {
                IsAdmin = true;
            }

            if (!IsPostBack)
            {
                hlCreatePost.Visible = !IsAdmin;
                hlManageReports.Visible = IsAdmin;
                LoadPosts();
            }
        }

        private void LoadPosts()
        {
            string query = @"
                SELECT 
                    fp.PostID,
                    fp.UserID,
                    fp.Title,
                    CASE 
                        WHEN LEN(fp.Content) > 220 THEN LEFT(fp.Content, 220) + '...'
                        ELSE fp.Content
                    END AS ShortContent,
                    fp.DatePosted,
                    fp.IsPinned,
                    u.Username
                FROM ForumPosts fp
                INNER JOIN Users u ON fp.UserID = u.UserID
                WHERE fp.IsDeleted = 0
                ORDER BY fp.IsPinned DESC, fp.DatePosted DESC";

            DataTable dt = DatabaseHelper.ExecuteSelect(query);
            rptPosts.DataSource = dt;
            rptPosts.DataBind();
        }

        protected void rptPosts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "TogglePin")
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("~/Forms/Auth/Login.aspx");
                    return;
                }

                int userId = Convert.ToInt32(Session["UserID"]);
                int postId = Convert.ToInt32(e.CommandArgument);

                string checkOwnerQuery = @"
                    SELECT COUNT(*) 
                    FROM ForumPosts 
                    WHERE PostID=@PostID AND UserID=@UserID AND IsDeleted=0";

                int ownerCount = Convert.ToInt32(DatabaseHelper.ExecuteScalar(
                    checkOwnerQuery,
                    new SqlParameter("@PostID", postId),
                    new SqlParameter("@UserID", userId)
                ));

                if (ownerCount > 0)
                {
                    string updateQuery = @"
                        UPDATE ForumPosts
                        SET IsPinned = CASE WHEN IsPinned = 1 THEN 0 ELSE 1 END
                        WHERE PostID = @PostID";

                    DatabaseHelper.ExecuteNonQuery(
                        updateQuery,
                        new SqlParameter("@PostID", postId)
                    );
                }

                LoadPosts();
            }
        }
    }
}