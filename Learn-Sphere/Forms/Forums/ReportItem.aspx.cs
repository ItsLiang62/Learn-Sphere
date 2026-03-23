using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace Learn_Sphere.Forms.Forums
{
    public partial class ReportItem : System.Web.UI.Page
    {
        protected string ReportType = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Forms/Auth/Login.aspx");
                return;
            }

            if (Session["Role"] != null && Session["Role"].ToString() == "Administrator")
            {
                Response.Redirect("~/Forms/Forums/Home.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["Type"] == null)
                {
                    Response.Redirect("~/Forms/Forums/Home.aspx");
                    return;
                }

                ReportType = Request.QueryString["Type"];
                txtReportType.Text = ReportType;
            }
        }

        protected void btnSubmitReport_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int reporterUserId = Convert.ToInt32(Session["UserID"]);
            string reportType = txtReportType.Text.Trim();

            SqlParameter postParam = new SqlParameter("@ReportedPostID", DBNull.Value);
            SqlParameter commentParam = new SqlParameter("@ReportedCommentID", DBNull.Value);

            if (reportType == "Post")
            {
                if (Request.QueryString["PostID"] == null)
                {
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Text = "Invalid post report.";
                    return;
                }

                postParam.Value = Convert.ToInt32(Request.QueryString["PostID"]);
            }
            else if (reportType == "Comment")
            {
                if (Request.QueryString["CommentID"] == null)
                {
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Text = "Invalid comment report.";
                    return;
                }

                commentParam.Value = Convert.ToInt32(Request.QueryString["CommentID"]);
            }
            else
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Invalid report type.";
                return;
            }

            string query = @"
                INSERT INTO Reports
                (ReporterUserID, ReportedPostID, ReportedCommentID, ReportType, Reason, Explanation)
                VALUES
                (@ReporterUserID, @ReportedPostID, @ReportedCommentID, @ReportType, @Reason, @Explanation)";

            int rows = DatabaseHelper.ExecuteNonQuery(
                query,
                new SqlParameter("@ReporterUserID", reporterUserId),
                postParam,
                commentParam,
                new SqlParameter("@ReportType", reportType),
                new SqlParameter("@Reason", ddlReason.SelectedValue),
                new SqlParameter("@Explanation", txtExplanation.Text.Trim())
            );

            if (rows > 0)
            {
                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Report submitted successfully.";
                ddlReason.SelectedIndex = 0;
                txtExplanation.Text = "";
            }
            else
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Failed to submit report.";
            }
        }
    }
}