using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

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

        private void LoadReports()
        {
            string query = @"
                SELECT 
                    r.ReportID,
                    u.Username AS ReporterName,
                    r.ReportType,
                    r.Reason,
                    r.Explanation,
                    r.DateCreated,
                    r.ReportStatus,
                    r.ReportedPostID,
                    r.ReportedCommentID
                FROM Reports r
                INNER JOIN Users u ON r.ReporterUserID = u.UserID
                ORDER BY r.DateCreated DESC";

            DataTable dt = DatabaseHelper.ExecuteSelect(query);
            gvReports.DataSource = dt;
            gvReports.DataBind();
        }

        protected void gvReports_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int reportId = Convert.ToInt32(e.CommandArgument);
            int adminId = Convert.ToInt32(Session["UserID"]);

            if (e.CommandName == "MarkReviewed")
            {
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

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Report marked as reviewed.";
                LoadReports();
            }
            else if (e.CommandName == "DeleteItem")
            {
                DataTable dt = DatabaseHelper.ExecuteSelect(
                    @"SELECT ReportType, ReportedPostID, ReportedCommentID
                      FROM Reports
                      WHERE ReportID = @ReportID",
                    new SqlParameter("@ReportID", reportId)
                );

                if (dt.Rows.Count > 0)
                {
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
                    lblMessage.Text = "Reported item deleted successfully.";
                }

                LoadReports();
            }
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
                    "SELECT UserID FROM ForumPosts WHERE PostID=@PostID",
                    new SqlParameter("@PostID", Convert.ToInt32(dt.Rows[0]["ReportedPostID"]))
                );
                return obj == null ? 0 : Convert.ToInt32(obj);
            }

            if (reportType == "Comment" && dt.Rows[0]["ReportedCommentID"] != DBNull.Value)
            {
                object obj = DatabaseHelper.ExecuteScalar(
                    "SELECT UserID FROM ForumComments WHERE CommentID=@CommentID",
                    new SqlParameter("@CommentID", Convert.ToInt32(dt.Rows[0]["ReportedCommentID"]))
                );
                return obj == null ? 0 : Convert.ToInt32(obj);
            }

            return 0;
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