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
    public partial class PostDetails : System.Web.UI.Page
    {
        protected int PostID = 0;
        protected bool IsAdmin = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] != null && Session["Role"].ToString() == "Administrator")
                IsAdmin = true;

            if (Request.QueryString["PostID"] == null)
            {
                Response.Redirect("~/Forms/Forums/Home.aspx");
                return;
            }

            PostID = Convert.ToInt32(Request.QueryString["PostID"]);
            hlReportPost.NavigateUrl = "~/Forms/Forums/ReportItem.aspx?Type=Post&PostID=" + PostID;
            hlReportPost.Visible = !IsAdmin;
            btnDeletePost.Visible = IsAdmin;

            if (!IsPostBack)
            {
                LoadPost();
                LoadComments();
            }
        }

        private void LoadPost()
        {
            string query = @"
                SELECT fp.PostID, fp.Title, fp.Content, fp.DatePosted, u.Username, fp.UserID
                FROM ForumPosts fp
                INNER JOIN Users u ON fp.UserID = u.UserID
                WHERE fp.PostID = @PostID AND fp.IsDeleted = 0";

            DataTable dt = DatabaseHelper.ExecuteSelect(
                query,
                new SqlParameter("@PostID", PostID)
            );

            if (dt.Rows.Count == 0)
            {
                Response.Redirect("~/Forms/Forums/Home.aspx");
                return;
            }

            lblTitle.Text = dt.Rows[0]["Title"].ToString();
            lblAuthor.Text = dt.Rows[0]["Username"].ToString();
            lblDate.Text = Convert.ToDateTime(dt.Rows[0]["DatePosted"]).ToString("dd/MM/yyyy hh:mm tt");
            litContent.Text = Server.HtmlEncode(dt.Rows[0]["Content"].ToString())
                .Replace("\r\n", "<br />")
                .Replace("\n", "<br />");
        }

        private void LoadComments()
        {
            string query = @"
                SELECT fc.CommentID, fc.CommentText, fc.DateCommented, u.Username
                FROM ForumComments fc
                INNER JOIN Users u ON fc.UserID = u.UserID
                WHERE fc.PostID = @PostID AND fc.IsDeleted = 0
                ORDER BY fc.DateCommented ASC";

            DataTable dt = DatabaseHelper.ExecuteSelect(
                query,
                new SqlParameter("@PostID", PostID)
            );

            rptComments.DataSource = dt;
            rptComments.DataBind();

            pnlNoComments.Visible = dt.Rows.Count == 0;
        }

        protected void btnComment_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Forms/Auth/Login.aspx");
                return;
            }

            if (!Page.IsValid) return;

            int userId = Convert.ToInt32(Session["UserID"]);

            string insertCommentQuery = @"
                INSERT INTO ForumComments (PostID, UserID, CommentText)
                VALUES (@PostID, @UserID, @CommentText)";

            int rows = DatabaseHelper.ExecuteNonQuery(
                insertCommentQuery,
                new SqlParameter("@PostID", PostID),
                new SqlParameter("@UserID", userId),
                new SqlParameter("@CommentText", txtComment.Text.Trim())
            );

            if (rows > 0)
            {
                CreateCommentNotification(userId);

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Comment added successfully.";
                txtComment.Text = "";
                LoadComments();
            }
            else
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Failed to add comment.";
            }
        }

        protected void btnDeletePost_Click(object sender, EventArgs e)
        {
            if (!IsAdmin) return;

            object ownerObj = DatabaseHelper.ExecuteScalar(
                "SELECT UserID FROM ForumPosts WHERE PostID=@PostID",
                new SqlParameter("@PostID", PostID)
            );

            DatabaseHelper.ExecuteNonQuery(
                @"UPDATE ForumPosts
                  SET IsDeleted = 1,
                      DeletedByAdminID = @AdminID,
                      DeletedDate = GETDATE()
                  WHERE PostID = @PostID",
                new SqlParameter("@AdminID", Convert.ToInt32(Session["UserID"])),
                new SqlParameter("@PostID", PostID)
            );

            if (ownerObj != null)
            {
                CreateNotification(Convert.ToInt32(ownerObj), "Your forum post was deleted by admin.");
            }

            Response.Redirect("~/Forms/Forums/Home.aspx");
        }

        protected void rptComments_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteComment" && IsAdmin)
            {
                int commentId = Convert.ToInt32(e.CommandArgument);

                object ownerObj = DatabaseHelper.ExecuteScalar(
                    "SELECT UserID FROM ForumComments WHERE CommentID=@CommentID",
                    new SqlParameter("@CommentID", commentId)
                );

                DatabaseHelper.ExecuteNonQuery(
                    @"UPDATE ForumComments
                      SET IsDeleted = 1,
                          DeletedByAdminID = @AdminID,
                          DeletedDate = GETDATE()
                      WHERE CommentID = @CommentID",
                    new SqlParameter("@AdminID", Convert.ToInt32(Session["UserID"])),
                    new SqlParameter("@CommentID", commentId)
                );

                if (ownerObj != null)
                {
                    CreateNotification(Convert.ToInt32(ownerObj), "Your forum comment was deleted by admin.");
                }

                LoadComments();
            }
        }

        private void CreateCommentNotification(int commenterId)
        {
            string ownerQuery = "SELECT UserID FROM ForumPosts WHERE PostID=@PostID";
            object ownerObj = DatabaseHelper.ExecuteScalar(
                ownerQuery,
                new SqlParameter("@PostID", PostID)
            );

            if (ownerObj == null) return;

            int postOwnerId = Convert.ToInt32(ownerObj);

            if (postOwnerId == commenterId) return;

            string notificationQuery = @"
                INSERT INTO Notifications (UserID, NotificationContent, RelatedPostID)
                VALUES (@UserID, @NotificationContent, @RelatedPostID)";

            DatabaseHelper.ExecuteNonQuery(
                notificationQuery,
                new SqlParameter("@UserID", postOwnerId),
                new SqlParameter("@NotificationContent", "Someone commented on your post."),
                new SqlParameter("@RelatedPostID", PostID)
            );
        }

        private void CreateNotification(int userId, string content)
        {
            DatabaseHelper.ExecuteNonQuery(
                @"INSERT INTO Notifications (UserID, NotificationContent)
                  VALUES (@UserID, @Content)",
                new SqlParameter("@UserID", userId),
                new SqlParameter("@Content", content)
            );
        }
    }
}