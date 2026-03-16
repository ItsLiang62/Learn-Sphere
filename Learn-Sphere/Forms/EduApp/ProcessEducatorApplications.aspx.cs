using System;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;

namespace Learn_Sphere.Forms.EduApp
{
    public partial class ProcessEducatorApplications : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Role"] == null || Session["Role"].ToString() != "Administrator")
                {
                    Response.Redirect("~/Forms/Auth/Login.aspx");
                    return;
                }

                LoadPendingApplications();
            }
        }

        private void LoadPendingApplications()
        {
            string query = @"
                SELECT ApplicationID, Username, Email, Qualification, PortfolioLink
                FROM EducatorApplications
                WHERE VerificationStatus='Pending'";

            DataTable dt = DatabaseHelper.ExecuteSelect(query, null);
            gvApplications.DataSource = dt;
            gvApplications.DataBind();
        }

        protected void gvApplications_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int applicationId = Convert.ToInt32(e.CommandArgument);

            // Get educator info
            string getAppQuery = "SELECT Username, Email, Qualification FROM EducatorApplications WHERE ApplicationID=@AppID";
            SqlParameter[] param = { new SqlParameter("@AppID", applicationId) };
            DataTable dt = DatabaseHelper.ExecuteSelect(getAppQuery, param);

            if (dt.Rows.Count == 0) return;

            string email = dt.Rows[0]["Email"].ToString();
            string username = dt.Rows[0]["Username"].ToString();

            if (e.CommandName == "Approve")
            {
                // Move educator into Users table
                string insertUser = @"
                    INSERT INTO Users (Username, Email, PasswordHash, Role)
                    SELECT Username, Email, PasswordHash, 'Educator'
                    FROM EducatorApplications
                    WHERE ApplicationID=@AppID";
                DatabaseHelper.ExecuteNonQuery(insertUser, param);

                // Update EducatorApplications table
                string updateApp = "UPDATE EducatorApplications SET VerificationStatus='Approved' WHERE ApplicationID=@AppID";
                DatabaseHelper.ExecuteNonQuery(updateApp, param);

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = $"Application approved for {username}";
            }
            else if (e.CommandName == "Reject")
            {
                string updateApp = "UPDATE EducatorApplications SET VerificationStatus='Rejected' WHERE ApplicationID=@AppID";
                DatabaseHelper.ExecuteNonQuery(updateApp, param);

                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = $"Application rejected for {username}";
            }

            LoadPendingApplications();
        }
    }
}