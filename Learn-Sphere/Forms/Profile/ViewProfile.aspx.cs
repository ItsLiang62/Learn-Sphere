using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Learn_Sphere.Forms.Profile
{
    public partial class ViewProfile : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("~/Forms/Auth/Login.aspx");

            if (!IsPostBack)
            {
                int targetID = 0;
                if (!int.TryParse(Request.QueryString["userID"], out targetID) || targetID == 0)
                {
                    Response.Redirect("~/Forms/Messaging/Messages.aspx");
                    return;
                }

                // Don't view your own profile here — redirect to own profile
                if (targetID == Convert.ToInt32(Session["UserID"]))
                {
                    Response.Redirect("~/Forms/Profile/Profile.aspx");
                    return;
                }

                LoadProfile(targetID);
                LoadStats(targetID);

                // Message link goes back to messages page
                lnkMessage.NavigateUrl = "/Forms/Messaging/Messages.aspx";
            }
        }

        private void LoadProfile(int targetID)
        {
            string query = @"
                SELECT u.UserID, u.Username, u.Role, u.DateRegistered,
                       ISNULL(p.FullName,'') AS FullName,
                       ISNULL(p.Bio,'')      AS Bio
                FROM Users u
                LEFT JOIN Profiles p ON p.UserID=u.UserID
                WHERE u.UserID=@TargetID";

            DataTable dt = DatabaseHelper.ExecuteSelect(query,
                new[] { new SqlParameter("@TargetID", targetID) });

            if (dt.Rows.Count == 0)
            {
                Response.Redirect("~/Forms/Messaging/Messages.aspx");
                return;
            }

            DataRow r = dt.Rows[0];
            string username = r["Username"].ToString();
            string fullName = r["FullName"].ToString();
            string bio = r["Bio"].ToString();
            string role = r["Role"].ToString();
            DateTime joined = Convert.ToDateTime(r["DateRegistered"]);

            string displayName = string.IsNullOrEmpty(fullName) ? username : fullName;

            lblAvatar.Text = displayName.Length > 0 ? displayName[0].ToString().ToUpper() : "?";
            lblDisplayName.Text = System.Web.HttpUtility.HtmlEncode(displayName);
            lblBio.Text = string.IsNullOrEmpty(bio) ? "No bio yet."
                                  : System.Web.HttpUtility.HtmlEncode(bio);

            lblRoleBadge.CssClass = "role-badge " + role.ToLower();
            lblRoleBadge.Text = role;

            lblUsername.Text = username;
            lblRole.Text = role;
            lblMemberSince.Text = joined.ToString("MMMM dd, yyyy");
        }

        private void LoadStats(int targetID)
        {
            string roleQuery = "SELECT Role FROM Users WHERE UserID=@T";
            object roleObj = DatabaseHelper.ExecuteScalar(roleQuery, new[] { new SqlParameter("@T", targetID) });
            string role = roleObj != null ? roleObj.ToString() : "Learner";

            if (role == "Educator")
            {
                string q = @"
                    WITH QC AS (SELECT QuizID, COUNT(*) AS TotalQ FROM QuizQuestions GROUP BY QuizID)
                    SELECT
                        COUNT(DISTINCT q.QuizID) AS QuizzesCreated,
                        COUNT(qa.AttemptID)       AS TotalAttempts,
                        ISNULL(CAST(ROUND(AVG(CASE WHEN ISNULL(qc.TotalQ,0)>0 THEN 100.0*qa.Score/qc.TotalQ ELSE NULL END),0) AS INT),0) AS AvgScore,
                        ISNULL(CAST(ROUND(MAX(CASE WHEN ISNULL(qc.TotalQ,0)>0 THEN 100.0*qa.Score/qc.TotalQ ELSE NULL END),0) AS INT),0) AS MaxScore
                    FROM Quizzes q
                    LEFT JOIN QC qc ON qc.QuizID=q.QuizID
                    LEFT JOIN QuizAttempts qa ON qa.QuizID=q.QuizID
                    WHERE q.EducatorID=@T";

                DataTable dt = DatabaseHelper.ExecuteSelect(q, new[] { new SqlParameter("@T", targetID) });
                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    lblStat1Val.Text = r["TotalAttempts"].ToString();
                    lblStat1Label.Text = "Attempts Received";
                    lblStat2Val.Text = r["QuizzesCreated"].ToString();
                    lblStat2Label.Text = "Quizzes Created";
                    lblStat3Val.Text = r["AvgScore"] + "%";
                    lblStat4Val.Text = r["MaxScore"] + "%";
                    lblStat4Label.Text = "Highest Score Given";
                }
            }
            else
            {
                string q = @"
                    SELECT COUNT(*) AS TotalAttempts, COUNT(DISTINCT QuizID) AS UniqueQuizzes
                    FROM QuizAttempts WHERE LearnerID=@T";
                DataTable dt = DatabaseHelper.ExecuteSelect(q, new[] { new SqlParameter("@T", targetID) });
                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    lblStat1Val.Text = r["TotalAttempts"].ToString();
                    lblStat2Val.Text = r["UniqueQuizzes"].ToString();
                }

                string avgQ = @"
                    SELECT ISNULL(CAST(ROUND(AVG(CASE WHEN ISNULL(qc.TotalQ,0)>0 THEN 100.0*qa.Score/qc.TotalQ ELSE NULL END),0) AS INT),0) AS AvgScore,
                           ISNULL(CAST(ROUND(MAX(CASE WHEN ISNULL(qc.TotalQ,0)>0 THEN 100.0*qa.Score/qc.TotalQ ELSE NULL END),0) AS INT),0) AS BestScore
                    FROM QuizAttempts qa
                    LEFT JOIN (SELECT QuizID, COUNT(*) AS TotalQ FROM QuizQuestions GROUP BY QuizID) qc ON qc.QuizID=qa.QuizID
                    WHERE qa.LearnerID=@T";
                DataTable dt2 = DatabaseHelper.ExecuteSelect(avgQ, new[] { new SqlParameter("@T", targetID) });
                if (dt2.Rows.Count > 0)
                {
                    lblStat3Val.Text = dt2.Rows[0]["AvgScore"] + "%";
                    lblStat4Val.Text = dt2.Rows[0]["BestScore"] + "%";
                    lblStat4Label.Text = "Best Score";
                }
            }
        }
    }
}
