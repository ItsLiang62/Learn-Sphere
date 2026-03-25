using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Learn_Sphere.Forms.Admin
{
    public partial class ManageReports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"] == null)
            {
                Response.Redirect("~/Forms/Auth/Login.aspx");
                return;
            }

            if (Session["Role"].ToString() != "Administrator")
            {
                Response.Redirect("~/Forms/Assessments/Home.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadReports();
            }
        }

        protected string GetTypeCss(string reportType)
        {
            if (reportType == "Post") return "type-post";
            if (reportType == "Comment") return "type-comment";
            if (reportType == "Resource") return "type-resource";
            return "type-post";
        }

        private void LoadReports()
        {
            string query = @"
                SELECT
                    'Forum' + CAST(r.ReportID AS NVARCHAR(20)) AS CommandArgumentValue,
                    r.ReportID AS UnifiedReportID,
                    u.Username AS ReporterName,
                    r.ReportType,
                    r.Reason,
                    r.Explanation,
                    r.DateCreated,
                    r.ReportStatus,
                    r.ReportedPostID,
                    r.ReportedCommentID,
                    CAST(NULL AS INT) AS ResourceID,
                    CASE
                        WHEN r.ReportType = 'Post' THEN ISNULL(fp.Title, 'Forum Post')
                        WHEN r.ReportType = 'Comment' THEN
                            CASE
                                WHEN LEN(ISNULL(fc.CommentText, 'Forum Comment')) > 60
                                    THEN LEFT(fc.CommentText, 60) + '...'
                                ELSE ISNULL(fc.CommentText, 'Forum Comment')
                            END
                        ELSE 'Forum Item'
                    END AS ReportedItemTitle
                FROM Reports r
                INNER JOIN Users u ON r.ReporterUserID = u.UserID
                LEFT JOIN ForumPosts fp ON r.ReportedPostID = fp.PostID
                LEFT JOIN ForumComments fc ON r.ReportedCommentID = fc.CommentID

                UNION ALL

                SELECT
                    'Resource' + CAST(rr.ResourceReportID AS NVARCHAR(20)) AS CommandArgumentValue,
                    rr.ResourceReportID AS UnifiedReportID,
                    u.Username AS ReporterName,
                    'Resource' AS ReportType,
                    rr.Reason,
                    rr.Explanation,
                    rr.ReportDate AS DateCreated,
                    rr.ReportStatus,
                    CAST(NULL AS INT) AS ReportedPostID,
                    CAST(NULL AS INT) AS ReportedCommentID,
                    rr.ResourceID,
                    ISNULL(res.Title, 'Learning Resource') AS ReportedItemTitle
                FROM ResourceReports rr
                INNER JOIN Users u ON rr.ReporterUserID = u.UserID
                LEFT JOIN Resources res ON rr.ResourceID = res.ResourceID

                ORDER BY DateCreated DESC";

            DataTable dt = DatabaseHelper.ExecuteSelect(query);
            gvReports.DataSource = dt;
            gvReports.DataBind();
        }

        protected void gvReports_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string commandArg = e.CommandArgument.ToString();
            int adminId = Convert.ToInt32(Session["UserID"]);

            if (e.CommandName == "MarkReviewed")
            {
                if (commandArg.StartsWith("Forum"))
                {
                    int reportId = Convert.ToInt32(commandArg.Replace("Forum", ""));

                    DatabaseHelper.ExecuteNonQuery(
                        @"UPDATE Reports
                          SET ReportStatus = 'ReviewedOnly'
                          WHERE ReportID = @ReportID",
                        new SqlParameter("@ReportID", reportId)
                    );

                    int ownerId = GetReportedContentOwnerId(reportId);
                    if (ownerId > 0)
                    {
                        CreateNotification(ownerId, "Your reported content has been reviewed by admin.");
                    }
                }
                else if (commandArg.StartsWith("Resource"))
                {
                    int reportId = Convert.ToInt32(commandArg.Replace("Resource", ""));

                    DatabaseHelper.ExecuteNonQuery(
                        @"UPDATE ResourceReports
                          SET ReportStatus = 'ReviewedOnly'
                          WHERE ResourceReportID = @ReportID",
                        new SqlParameter("@ReportID", reportId)
                    );

                    int ownerId = GetReportedResourceOwnerId(reportId);
                    if (ownerId > 0)
                    {
                        CreateNotification(ownerId, "Your reported resource has been reviewed by admin.");
                    }
                }

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Report marked as reviewed.";
                LoadReports();
            }
            else if (e.CommandName == "DeleteItem")
            {
                if (commandArg.StartsWith("Forum"))
                {
                    int reportId = Convert.ToInt32(commandArg.Replace("Forum", ""));
                    DeleteForumReportedItem(reportId, adminId);
                }
                else if (commandArg.StartsWith("Resource"))
                {
                    int reportId = Convert.ToInt32(commandArg.Replace("Resource", ""));
                    DeleteReportedResource(reportId, adminId);
                }

                LoadReports();
            }
        }

        private void DeleteForumReportedItem(int reportId, int adminId)
        {
            DataTable dt = DatabaseHelper.ExecuteSelect(
                @"SELECT ReportType, ReportedPostID, ReportedCommentID
                  FROM Reports
                  WHERE ReportID = @ReportID",
                new SqlParameter("@ReportID", reportId)
            );

            if (dt.Rows.Count == 0) return;

            string reportType = dt.Rows[0]["ReportType"].ToString();
            int ownerId = GetReportedContentOwnerId(reportId);
            string newStatus = "ReviewedOnly";

            if (reportType == "Post" && dt.Rows[0]["ReportedPostID"] != DBNull.Value)
            {
                int postId = Convert.ToInt32(dt.Rows[0]["ReportedPostID"]);

                DatabaseHelper.ExecuteNonQuery(
                    @"UPDATE ForumPosts
                      SET IsDeleted = 1,
                          DeletedByAdminID = @AdminID,
                          DeletedDate = GETDATE()
                      WHERE PostID = @PostID",
                    new SqlParameter("@AdminID", adminId),
                    new SqlParameter("@PostID", postId)
                );

                newStatus = "PostDeleted";
            }
            else if (reportType == "Comment" && dt.Rows[0]["ReportedCommentID"] != DBNull.Value)
            {
                int commentId = Convert.ToInt32(dt.Rows[0]["ReportedCommentID"]);

                DatabaseHelper.ExecuteNonQuery(
                    @"UPDATE ForumComments
                      SET IsDeleted = 1,
                          DeletedByAdminID = @AdminID,
                          DeletedDate = GETDATE()
                      WHERE CommentID = @CommentID",
                    new SqlParameter("@AdminID", adminId),
                    new SqlParameter("@CommentID", commentId)
                );

                newStatus = "CommentDeleted";
            }

            DatabaseHelper.ExecuteNonQuery(
                @"UPDATE Reports
                  SET ReportStatus = @Status
                  WHERE ReportID = @ReportID",
                new SqlParameter("@Status", newStatus),
                new SqlParameter("@ReportID", reportId)
            );

            if (ownerId > 0)
            {
                CreateNotification(ownerId, "Your reported content was deleted by admin.");
            }

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "Reported forum item deleted successfully.";
        }

        private void DeleteReportedResource(int resourceReportId, int adminId)
        {
            DataTable dt = DatabaseHelper.ExecuteSelect(
                @"SELECT ResourceID
                  FROM ResourceReports
                  WHERE ResourceReportID = @ReportID",
                new SqlParameter("@ReportID", resourceReportId)
            );

            if (dt.Rows.Count == 0) return;
            if (dt.Rows[0]["ResourceID"] == DBNull.Value) return;

            int resourceId = Convert.ToInt32(dt.Rows[0]["ResourceID"]);
            int ownerId = GetReportedResourceOwnerId(resourceReportId);

            DatabaseHelper.ExecuteNonQuery(
                @"UPDATE Resources
                  SET IsDeleted = 1,
                      DeletedByAdminID = @AdminID,
                      DeletedDate = GETDATE()
                  WHERE ResourceID = @ResourceID",
                new SqlParameter("@AdminID", adminId),
                new SqlParameter("@ResourceID", resourceId)
            );

            DatabaseHelper.ExecuteNonQuery(
                @"UPDATE ResourceReports
                  SET ReportStatus = 'ResourceDeleted'
                  WHERE ResourceReportID = @ReportID",
                new SqlParameter("@ReportID", resourceReportId)
            );

            if (ownerId > 0)
            {
                CreateNotification(ownerId, "Your reported resource was deleted by admin.");
            }

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "Reported resource deleted successfully.";
        }

        private int GetReportedContentOwnerId(int reportId)
        {
            DataTable dt = DatabaseHelper.ExecuteSelect(
                @"SELECT r.ReportType, r.ReportedPostID, r.ReportedCommentID
                  FROM Reports r
                  WHERE r.ReportID = @ReportID",
                new SqlParameter("@ReportID", reportId)
            );

            if (dt.Rows.Count == 0) return 0;

            string reportType = dt.Rows[0]["ReportType"].ToString();

            if (reportType == "Post" && dt.Rows[0]["ReportedPostID"] != DBNull.Value)
            {
                object obj = DatabaseHelper.ExecuteScalar(
                    "SELECT UserID FROM ForumPosts WHERE PostID = @PostID",
                    new SqlParameter("@PostID", Convert.ToInt32(dt.Rows[0]["ReportedPostID"]))
                );
                return obj == null ? 0 : Convert.ToInt32(obj);
            }

            if (reportType == "Comment" && dt.Rows[0]["ReportedCommentID"] != DBNull.Value)
            {
                object obj = DatabaseHelper.ExecuteScalar(
                    "SELECT UserID FROM ForumComments WHERE CommentID = @CommentID",
                    new SqlParameter("@CommentID", Convert.ToInt32(dt.Rows[0]["ReportedCommentID"]))
                );
                return obj == null ? 0 : Convert.ToInt32(obj);
            }

            return 0;
        }

        private int GetReportedResourceOwnerId(int resourceReportId)
        {
            object obj = DatabaseHelper.ExecuteScalar(
                @"SELECT r.UserID
                  FROM ResourceReports rr
                  INNER JOIN Resources r ON rr.ResourceID = r.ResourceID
                  WHERE rr.ResourceReportID = @ReportID",
                new SqlParameter("@ReportID", resourceReportId)
            );

            return obj == null ? 0 : Convert.ToInt32(obj);
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