using System;
using System.Data;
using System.Data.SqlClient;

namespace Learn_Sphere.Forms.Auth
{
    public partial class EducatorApplication : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadApplications();
            }
        }

        private void LoadApplications()
        {
            string email = Session["Email"]?.ToString();
            string username = Session["Username"]?.ToString();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(username))
                return;

            string query = @"SELECT Qualification, VerificationStatus, DateSubmitted 
                             FROM EducatorApplications 
                             WHERE Email=@Email AND Username=@Username
                             ORDER BY DateSubmitted DESC";

            SqlParameter[] parameters =
            {
                new SqlParameter("@Email", email),
                new SqlParameter("@Username", username)
            };

            DataTable dt = DatabaseHelper.ExecuteSelect(query, parameters);

            gvApplications.DataSource = dt;
            gvApplications.DataBind();
            gvApplications.Visible = dt.Rows.Count > 0;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string email = Session["Email"]?.ToString();
            string username = Session["Username"]?.ToString();
            string passwordHash = Session["PasswordHash"]?.ToString();

            if (string.IsNullOrEmpty(email) || 
                string.IsNullOrEmpty(username) || 
                string.IsNullOrEmpty(passwordHash))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Session expired. Please register again.";
                return;
            }

            if (string.IsNullOrWhiteSpace(txtQualification.Text))
            {
                lblMessage.Text = "Please enter your qualification.";
                return;
            }

            if (string.IsNullOrWhiteSpace(txtPortfolio.Text))
            {
                lblMessage.Text = "Please enter your portfolio link.";
                return;
            }

            // 1️⃣ Check Users table
            string usersCheck = @"SELECT COUNT(*) FROM Users 
                                  WHERE Email=@Email OR Username=@Username";

            SqlParameter[] parameters =
            {
                new SqlParameter("@Email", email),
                new SqlParameter("@Username", username)
            };

            int usersMatch = Convert.ToInt32(DatabaseHelper.ExecuteScalar(usersCheck, parameters));

            if (usersMatch > 0)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Email or username already exists as a user.";
                return;
            }

            // Check Pending/Approved applications
            string appCheck = @"SELECT COUNT(*) FROM EducatorApplications
                                WHERE (Email=@Email OR Username=@Username)
                                AND VerificationStatus IN ('Pending','Approved')";

            int appMatch = Convert.ToInt32(DatabaseHelper.ExecuteScalar(appCheck, parameters));

            if (appMatch > 0)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Email or username already have a pending or approved application.";
                return;
            }

            // Insert application
            string query = @"INSERT INTO EducatorApplications
                    (Username, Email, PasswordHash, Qualification, PortfolioLink, VerificationStatus, DateSubmitted)
                    VALUES (@Username,@Email,@PasswordHash,@Qualification,@PortfolioLink,'Pending',GETDATE())";

            SqlParameter[] insertParams =
            {
                new SqlParameter("@Username", username),
                new SqlParameter("@Email", email),
                new SqlParameter("@PasswordHash", passwordHash),
                new SqlParameter("@Qualification", txtQualification.Text),
                new SqlParameter("@PortfolioLink", txtPortfolio.Text)
            };

            DatabaseHelper.ExecuteNonQuery(query, insertParams);

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "Application submitted successfully.";

            LoadApplications();
        }

        protected void lnkBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Forms/Auth/Register.aspx");
        }
    }
}