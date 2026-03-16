using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Learn_Sphere.Forms.Profile
{
    public partial class Profile : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("~/Forms/Auth/Login.aspx");

            string role = Session["Role"] != null ? Session["Role"].ToString() : "";
            hfRole.Value = role;
            hfHandlerUrl.Value = ResolveUrl("~/Forms/Messaging/MessagesHandler.ashx");

            if (!IsPostBack)
            {
                LoadProfile();
                LoadStats();
            }
        }

        private void LoadProfile()
        {
            int userID = Convert.ToInt32(Session["UserID"]);
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";

            string query = @"
                SELECT u.Username, u.Email, u.Role, u.DateRegistered,
                       ISNULL(p.FullName,'') AS FullName,
                       ISNULL(p.Bio,'')      AS Bio
                FROM Users u
                LEFT JOIN Profiles p ON p.UserID=u.UserID
                WHERE u.UserID=@UserID";

            DataTable dt = DatabaseHelper.ExecuteSelect(query, new[] { new SqlParameter("@UserID", userID) });
            if (dt.Rows.Count == 0) return;

            DataRow r = dt.Rows[0];
            string username = r["Username"].ToString();
            string fullName = r["FullName"].ToString();
            string bio = r["Bio"].ToString();
            string email = r["Email"].ToString();
            DateTime joined = Convert.ToDateTime(r["DateRegistered"]);

            string disp = string.IsNullOrEmpty(fullName) ? username : fullName;
            lblDisplayName.Text = System.Web.HttpUtility.HtmlEncode(disp);
            lblAvatar.Text = disp.Length > 0 ? disp[0].ToString().ToUpper() : "?";
            lblBioPreview.Text = string.IsNullOrEmpty(bio) ? "No bio yet."
                                  : System.Web.HttpUtility.HtmlEncode(bio);

            lblRoleBadge.CssClass = "role-badge " + role.ToLower();
            lblRoleBadge.Text = role;

            txtFullName.Text = fullName;
            txtUsername.Text = username;
            txtEmail.Text = email;
            txtBio.Text = bio;

            lblMemberSince.Text = joined.ToString("MMMM dd, yyyy");
            lblEmailInfo.Text = System.Web.HttpUtility.HtmlEncode(email);
        }

        private void LoadStats()
        {
            int userID = Convert.ToInt32(Session["UserID"]);
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";

            if (role == "Educator")
            {
                string q = @"
                    WITH QC AS (SELECT QuizID,COUNT(*) AS TotalQ FROM QuizQuestions GROUP BY QuizID)
                    SELECT COUNT(DISTINCT q.QuizID) AS QuizzesCreated,
                           COUNT(qa.AttemptID)       AS TotalAttempts,
                           ISNULL(CAST(ROUND(AVG(CASE WHEN ISNULL(qc.TotalQ,0)>0 THEN 100.0*qa.Score/qc.TotalQ ELSE NULL END),0) AS INT),0) AS AvgScore
                    FROM Quizzes q
                    LEFT JOIN QC qc ON qc.QuizID=q.QuizID
                    LEFT JOIN QuizAttempts qa ON qa.QuizID=q.QuizID
                    WHERE q.EducatorID=@UserID";
                DataTable dt = DatabaseHelper.ExecuteSelect(q, new[] { new SqlParameter("@UserID", userID) });
                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    lblStatAttempts.Text = r["TotalAttempts"].ToString();
                    lblStatQuizzes.Text = r["QuizzesCreated"].ToString();
                    lblStatAvg.Text = r["AvgScore"] + "%";
                    lblStatQuizzesLabel.Text = "Quizzes Created";
                }
                lblStatSaved.Text = GetSavedCount(userID);
                lblStatSavedLabel.Text = "Saved Quizzes";
            }
            else if (role == "Administrator")
            {
                // Platform-wide stats
                string q = @"
                    SELECT COUNT(DISTINCT q.QuizID) AS TotalQuizzes,
                           COUNT(qa.AttemptID)       AS TotalAttempts,
                           ISNULL(CAST(ROUND(AVG(CASE WHEN ISNULL(qc.TotalQ,0)>0 THEN 100.0*qa.Score/qc.TotalQ ELSE NULL END),0) AS INT),0) AS AvgScore
                    FROM Quizzes q
                    LEFT JOIN (SELECT QuizID,COUNT(*) AS TotalQ FROM QuizQuestions GROUP BY QuizID) qc ON qc.QuizID=q.QuizID
                    LEFT JOIN QuizAttempts qa ON qa.QuizID=q.QuizID";
                DataTable dt = DatabaseHelper.ExecuteSelect(q, null);
                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    lblStatAttempts.Text = r["TotalAttempts"].ToString();
                    lblStatQuizzes.Text = r["TotalQuizzes"].ToString();
                    lblStatAvg.Text = r["AvgScore"] + "%";
                    lblStatQuizzesLabel.Text = "Total Quizzes";
                }
                // Admin has no saved quizzes — show total users instead
                string userCount = DatabaseHelper.ExecuteScalar(
                    "SELECT COUNT(*) FROM Users", null)?.ToString() ?? "0";
                lblStatSaved.Text = userCount;
                lblStatSavedLabel.Text = "Total Users";
            }
            else
            {
                // Learner
                string q = @"
                    SELECT COUNT(*)               AS TotalAttempts,
                           COUNT(DISTINCT QuizID)  AS UniqueQuizzes
                    FROM QuizAttempts WHERE LearnerID=@UserID";
                DataTable dt = DatabaseHelper.ExecuteSelect(q, new[] { new SqlParameter("@UserID", userID) });
                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    lblStatAttempts.Text = r["TotalAttempts"].ToString();
                    lblStatQuizzes.Text = r["UniqueQuizzes"].ToString();
                }

                object avgObj = DatabaseHelper.ExecuteScalar(@"
                    SELECT ISNULL(CAST(ROUND(AVG(CASE WHEN ISNULL(qc.TotalQ,0)>0 THEN 100.0*qa.Score/qc.TotalQ ELSE NULL END),0) AS INT),0)
                    FROM QuizAttempts qa
                    LEFT JOIN (SELECT QuizID,COUNT(*) AS TotalQ FROM QuizQuestions GROUP BY QuizID) qc ON qc.QuizID=qa.QuizID
                    WHERE qa.LearnerID=@UserID",
                    new[] { new SqlParameter("@UserID", userID) });
                lblStatAvg.Text = (avgObj ?? "0") + "%";
                lblStatSaved.Text = GetSavedCount(userID);
                lblStatSavedLabel.Text = "Saved Quizzes";
                lblStatQuizzesLabel.Text = "Unique Quizzes";
            }
        }

        private string GetSavedCount(int userID)
        {
            if (!TableExists("SavedQuizzes")) return "0";
            object r = DatabaseHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM SavedQuizzes WHERE UserID=@UserID",
                new[] { new SqlParameter("@UserID", userID) });
            return r != null ? r.ToString() : "0";
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            int userID = Convert.ToInt32(Session["UserID"]);
            string fullName = txtFullName.Text.Trim();
            string bio = txtBio.Text.Trim();

            string upsert = @"
                IF EXISTS (SELECT 1 FROM Profiles WHERE UserID=@UserID)
                    UPDATE Profiles SET FullName=@FullName, Bio=@Bio WHERE UserID=@UserID
                ELSE
                    INSERT INTO Profiles (UserID,FullName,Bio) VALUES (@UserID,@FullName,@Bio)";

            DatabaseHelper.ExecuteNonQuery(upsert, new[]
            {
                new SqlParameter("@UserID",   userID),
                new SqlParameter("@FullName", fullName),
                new SqlParameter("@Bio",      bio)
            });

            lblMsg.CssClass = "msg-success";
            lblMsg.Text = "✓ Profile updated successfully.";

            string disp = string.IsNullOrEmpty(fullName) ? txtUsername.Text : fullName;
            lblDisplayName.Text = System.Web.HttpUtility.HtmlEncode(disp);
            lblAvatar.Text = disp.Length > 0 ? disp[0].ToString().ToUpper() : "?";
            lblBioPreview.Text = string.IsNullOrEmpty(bio) ? "No bio yet."
                                  : System.Web.HttpUtility.HtmlEncode(bio);
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Forms/Auth/Login.aspx");
        }

        private bool TableExists(string tableName)
        {
            string sql = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME=@T AND TABLE_SCHEMA='dbo'";
            return Convert.ToInt32(DatabaseHelper.ExecuteScalar(sql, new[] { new SqlParameter("@T", tableName) })) > 0;
        }
    }
}