using System;
using System.Data.SqlClient;

namespace Learn_Sphere.Forms.Resources
{
    public partial class ReportResource : System.Web.UI.Page
    {
        protected int ResourceID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Forms/Auth/Login.aspx");
                return;
            }

            if (Session["Role"] != null && Session["Role"].ToString() == "Administrator")
            {
                Response.Redirect("~/Forms/Resources/Home.aspx");
                return;
            }

            if (Request.QueryString["ResourceID"] == null)
            {
                Response.Redirect("~/Forms/Resources/Home.aspx");
                return;
            }

            ResourceID = Convert.ToInt32(Request.QueryString["ResourceID"]);
        }

        protected void btnSubmitReport_Click(object sender, EventArgs e)
        {
            int reporterUserId = Convert.ToInt32(Session["UserID"]);

            string query = @"
                INSERT INTO ResourceReports (ReporterUserID, ResourceID, Reason, Explanation)
                VALUES (@ReporterUserID, @ResourceID, @Reason, @Explanation)";

            int rows = DatabaseHelper.ExecuteNonQuery(
                query,
                new SqlParameter("@ReporterUserID", reporterUserId),
                new SqlParameter("@ResourceID", ResourceID),
                new SqlParameter("@Reason", ddlReason.SelectedValue),
                new SqlParameter("@Explanation", txtExplanation.Text.Trim())
            );

            if (rows > 0)
            {
                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Report submitted successfully.";
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