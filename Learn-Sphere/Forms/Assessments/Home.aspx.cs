using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Learn_Sphere.Forms.Assessment
{
    public partial class Home : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("~/Forms/Auth/Login.aspx");

            string role = Session["Role"] != null ? Session["Role"].ToString() : "";
            hfRole.Value = role;

            string qs = Request.QueryString["scope"] ?? "";
            if (!string.IsNullOrEmpty(qs)) hfOpenScope.Value = qs;

            string tab = Request.QueryString["tab"] ?? "";
            if (!IsPostBack && tab == "analytics") hfActiveTab.Value = "analytics";

            LoadQuizzes();
            LoadAnalytics(hfAnalyticsFilter.Value);
        }

        // ─── LOAD QUIZZES ─────────────────────────────────────────────────────────────
        private void LoadQuizzes()
        {
            int userID = Convert.ToInt32(Session["UserID"]);
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";
            bool hasSaved = TableExists("SavedQuizzes");

            string query;
            if (role == "Learner")
            {
                query = hasSaved ? @"
                    SELECT q.QuizID, q.Title, q.Description, q.EducatorID, q.DateCreated,
                           ISNULL(u.Username,'') AS EducatorName,
                           ISNULL(qc.QuestionCount,0) AS QuestionCount,
                           ISNULL(my.MyAttemptCount,0) AS MyAttemptCount,
                           'all' AS Scope,
                           CASE WHEN s.QuizID IS NOT NULL THEN 1 ELSE 0 END AS IsSaved
                    FROM Quizzes q
                    INNER JOIN Users u ON u.UserID=q.EducatorID
                    LEFT JOIN (SELECT QuizID,COUNT(*) AS QuestionCount FROM QuizQuestions
                    GROUP BY QuizID) qc ON qc.QuizID=q.QuizID
                    LEFT JOIN (SELECT QuizID,COUNT(*) AS MyAttemptCount FROM QuizAttempts 
                    WHERE LearnerID=@UserID GROUP BY QuizID) my ON my.QuizID=q.QuizID
                    LEFT JOIN SavedQuizzes s ON s.QuizID=q.QuizID AND s.UserID=@UserID
                    ORDER BY q.DateCreated DESC"
                : @"
                    SELECT q.QuizID, q.Title, q.Description, q.EducatorID, q.DateCreated,
                           ISNULL(u.Username,'') AS EducatorName,
                           ISNULL(qc.QuestionCount,0) AS QuestionCount,
                           ISNULL(my.MyAttemptCount,0) AS MyAttemptCount,
                           'all' AS Scope, 0 AS IsSaved
                    FROM Quizzes q
                    INNER JOIN Users u ON u.UserID=q.EducatorID
                    LEFT JOIN (SELECT QuizID,COUNT(*) AS QuestionCount FROM QuizQuestions 
q                   GROUP BY QuizID) qc ON qc.QuizID=q.QuizID
                    LEFT JOIN (SELECT QuizID,COUNT(*) AS MyAttemptCount FROM QuizAttempts 
                    WHERE LearnerID=@UserID GROUP BY QuizID) my ON my.QuizID=q.QuizID
                    ORDER BY q.DateCreated DESC";
            }
            else
            {
                // Educator and Admin — no saved join, educator scope tagged
                query = @"
                    SELECT q.QuizID, q.Title, q.Description, q.EducatorID, q.DateCreated,
                           ISNULL(u.Username,'') AS EducatorName,
                           ISNULL(qc.QuestionCount,0) AS QuestionCount,
                           0 AS MyAttemptCount,
                           CASE WHEN q.EducatorID=@UserID THEN 'mine' ELSE 'all' END AS Scope,
                           0 AS IsSaved
                    FROM Quizzes q
                    INNER JOIN Users u ON u.UserID=q.EducatorID
                    LEFT JOIN (SELECT QuizID,COUNT(*) AS QuestionCount FROM QuizQuestions GROUP BY QuizID) qc ON qc.QuizID=q.QuizID
                    ORDER BY q.DateCreated DESC";
            }

            DataTable dt = DatabaseHelper.ExecuteSelect(query, new[] { new SqlParameter("@UserID", userID) });
            rptQuizzes.DataSource = dt;
            rptQuizzes.DataBind();
            pnlEmpty.Visible = (dt.Rows.Count == 0);
        }

        protected void rptQuizzes_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;

            DataRowView row = (DataRowView)e.Item.DataItem;
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";
            int userID = Convert.ToInt32(Session["UserID"]);
            int attempts = Convert.ToInt32(row["MyAttemptCount"]);
            int isSaved = Convert.ToInt32(row["IsSaved"]);
            int educID = Convert.ToInt32(row["EducatorID"]);
            bool isOwn = (role == "Educator" && educID == userID);

            // Attempts badge (learner)
            var lbl = e.Item.FindControl("lblAttempts") as Label;
            if (lbl != null && attempts > 0)
            {
                lbl.CssClass = "badge-attempts ms-auto";
                lbl.Text = string.Format("<i class='fa-solid fa-rotate me-1'></i>{0}x", attempts);
            }

            // Take / View button
            var btnTake = e.Item.FindControl("btnTakeQuiz") as Button;
            if (btnTake != null)
            {
                if (role == "Administrator")
                {
                    // Admin can click to view any quiz but not take it
                    btnTake.CssClass = "btn-take disabled-own";
                    btnTake.Text = "View Quiz";
                    btnTake.Enabled = true;   // still navigates via btnTakeQuiz_Click
                    btnTake.ToolTip = "Administrators can view but not submit quizzes";
                }
                else if (isOwn)
                {
                    // Educator can click to view their own quiz but not take it
                    btnTake.CssClass = "btn-take disabled-own";
                    btnTake.Text = "View Quiz";
                    btnTake.Enabled = true;   // still navigates via btnTakeQuiz_Click
                    btnTake.ToolTip = "View your own quiz";
                }
                else if (attempts > 0)
                {
                    btnTake.CssClass = "btn-take completed";
                }
            }

            // Save button — hidden for admin and educator's own quiz
            var btnSave = e.Item.FindControl("btnSave") as Button;
            if (btnSave != null)
            {
                if (role == "Administrator")
                {
                    btnTake.CssClass = "btn-take";
                    btnTake.Text = "View Quiz →";
                    btnTake.Enabled = true;
                    btnTake.ToolTip = "";
                }
                else if (isOwn)
                {
                    btnTake.CssClass = "btn-take";
                    btnTake.Text = "View Quiz →";
                    btnTake.Enabled = true;
                    btnTake.ToolTip = "";
                }
                else if (attempts > 0)
                {
                    btnTake.CssClass = "btn-take completed";
                    btnTake.Text = "Take Quiz →";
                }
            }

            // Delete — educator own or admin any
            var btnDelete = e.Item.FindControl("btnDelete") as Button;
            if (btnDelete != null)
                btnDelete.Visible = (role == "Administrator" || isOwn);
        }

        protected void btnTakeQuiz_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            string quizID = btn.CommandArgument;
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";
            int userID = Convert.ToInt32(Session["UserID"]);

            // Check if this is a view-only scenario
            object ownerObj = DatabaseHelper.ExecuteScalar(
                "SELECT EducatorID FROM Quizzes WHERE QuizID=@Q",
                new[] { new SqlParameter("@Q", Convert.ToInt32(quizID)) });

            bool isOwn = (role == "Educator" && ownerObj != null && Convert.ToInt32(ownerObj) == userID);
            bool viewOnly = (role == "Administrator" || isOwn);

            if (viewOnly)
                Response.Redirect("~/Forms/Assessments/TakeQuiz.aspx?quizID=" + quizID + "&view=1");
            else
                Response.Redirect("~/Forms/Assessments/TakeQuiz.aspx?quizID=" + quizID);
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!TableExists("SavedQuizzes")) { LoadQuizzes(); return; }

            int userID = Convert.ToInt32(Session["UserID"]);
            int quizID = Convert.ToInt32(((Button)sender).CommandArgument);
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";

            if (role == "Administrator") { LoadQuizzes(); return; }

            object ownerObj = DatabaseHelper.ExecuteScalar(
                "SELECT EducatorID FROM Quizzes WHERE QuizID=@Q",
                new[] { new SqlParameter("@Q", quizID) });
            if (role == "Educator" && ownerObj != null && Convert.ToInt32(ownerObj) == userID)
            { LoadQuizzes(); return; }

            int exists = Convert.ToInt32(DatabaseHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM SavedQuizzes WHERE UserID=@U AND QuizID=@Q",
                new[] { new SqlParameter("@U", userID), new SqlParameter("@Q", quizID) }));

            if (exists > 0)
                DatabaseHelper.ExecuteNonQuery("DELETE FROM SavedQuizzes WHERE UserID=@U AND QuizID=@Q",
                    new[] { new SqlParameter("@U", userID), new SqlParameter("@Q", quizID) });
            else
                DatabaseHelper.ExecuteNonQuery("INSERT INTO SavedQuizzes (UserID,QuizID) VALUES (@U,@Q)",
                    new[] { new SqlParameter("@U", userID), new SqlParameter("@Q", quizID) });

            hfActiveTab.Value = "quizzes";
            LoadQuizzes();
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            int userID = Convert.ToInt32(Session["UserID"]);
            int quizID = Convert.ToInt32(((Button)sender).CommandArgument);
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";

            object ownerObj = DatabaseHelper.ExecuteScalar(
                "SELECT EducatorID FROM Quizzes WHERE QuizID=@Q",
                new[] { new SqlParameter("@Q", quizID) });
            if (ownerObj == null) { LoadQuizzes(); return; }

            int ownerID = Convert.ToInt32(ownerObj);
            if (role != "Administrator" && ownerID != userID) { LoadQuizzes(); return; }

            SqlParameter[] p = { new SqlParameter("@Q", quizID) };
            DatabaseHelper.ExecuteNonQuery(
                "DELETE FROM QuizAnswers WHERE AttemptID IN (SELECT AttemptID FROM QuizAttempts WHERE QuizID=@Q)",
                p
            );
            DatabaseHelper.ExecuteNonQuery("DELETE FROM QuizAttempts WHERE QuizID=@Q", p);
            if (TableExists("SavedQuizzes"))
                DatabaseHelper.ExecuteNonQuery("DELETE FROM SavedQuizzes WHERE QuizID=@Q", p);
            DatabaseHelper.ExecuteNonQuery("DELETE FROM Quizzes WHERE QuizID=@Q", p);

            hfActiveTab.Value = "quizzes";
            LoadQuizzes();
        }

        // ─── ANALYTICS ────────────────────────────────────────────────────────────────
        private void LoadAnalytics(string filter)
        {
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";
            int userID = Convert.ToInt32(Session["UserID"]);

            switch (role)
            {
                case "Educator":
                    pnlEducatorAnalytics.Visible = true;
                    pnlLearnerAnalytics.Visible = false;
                    pnlAdminAnalytics.Visible = false;
                    lblUniqueLabel.Text = "Quizzes Created";
                    LoadEducatorAnalytics(userID);
                    break;

                case "Administrator":
                    pnlEducatorAnalytics.Visible = false;
                    pnlLearnerAnalytics.Visible = false;
                    pnlAdminAnalytics.Visible = true;
                    lblUniqueLabel.Text = "Total Quizzes";
                    LoadAdminAnalytics();
                    break;

                default: // Learner
                    pnlEducatorAnalytics.Visible = false;
                    pnlLearnerAnalytics.Visible = true;
                    pnlAdminAnalytics.Visible = false;
                    lblUniqueLabel.Text = "Unique Quizzes Taken";
                    LoadLearnerAnalytics(userID, filter ?? "overall");
                    break;
            }
        }

        private void LoadLearnerAnalytics(int learnerID, string filter)
        {
            string baseQ = @"
                SELECT qa.AttemptID, q.Title, qa.Score, qa.AttemptDate,
                       ISNULL(qc.TotalQ,0) AS TotalQ,
                       CASE WHEN ISNULL(qc.TotalQ,0)=0 THEN 0
                            ELSE CAST(ROUND(100.0*qa.Score/qc.TotalQ,0) AS INT) END AS ScorePct
                FROM QuizAttempts qa
                INNER JOIN Quizzes q ON q.QuizID=qa.QuizID
                LEFT JOIN (SELECT QuizID,COUNT(*) AS TotalQ FROM QuizQuestions GROUP BY QuizID) qc ON qc.QuizID=q.QuizID
                WHERE qa.LearnerID=@LearnerID ORDER BY qa.AttemptDate DESC";

            string recentQ = @"
                SELECT TOP 5 qa.AttemptID, q.Title, qa.Score, qa.AttemptDate,
                       ISNULL(qc.TotalQ,0) AS TotalQ,
                       CASE WHEN ISNULL(qc.TotalQ,0)=0 THEN 0
                            ELSE CAST(ROUND(100.0*qa.Score/qc.TotalQ,0) AS INT) END AS ScorePct
                FROM QuizAttempts qa
                INNER JOIN Quizzes q ON q.QuizID=qa.QuizID
                LEFT JOIN (SELECT QuizID,COUNT(*) AS TotalQ FROM QuizQuestions GROUP BY QuizID) qc ON qc.QuizID=q.QuizID
                WHERE qa.LearnerID=@LearnerID ORDER BY qa.AttemptDate DESC";

            SqlParameter[] p = { new SqlParameter("@LearnerID", learnerID) };
            DataTable dt = DatabaseHelper.ExecuteSelect(filter == "recent" ? recentQ : baseQ, p);
            rptAttempts.DataSource = dt;
            rptAttempts.DataBind();

            int rows = dt.Rows.Count; double sumPct = 0, best = 0;
            var seen = new HashSet<string>();
            foreach (DataRow r in dt.Rows)
            {
                double pct = Convert.ToDouble(r["ScorePct"]);
                sumPct += pct;
                if (pct > best) best = pct;
                seen.Add(r["Title"].ToString());
            }
            double avg = rows > 0 ? Math.Round(sumPct / rows) : 0;

            if (filter == "recent")
            {
                int full = Convert.ToInt32(DatabaseHelper.ExecuteScalar(
                    "SELECT COUNT(*) FROM QuizAttempts WHERE LearnerID=@LearnerID", p));
                lblTotalAttempts.Text = full.ToString();
                lblAttemptCount.Text = "Last 5 of " + full + " attempt" + (full != 1 ? "s" : "");
            }
            else
            {
                lblTotalAttempts.Text = rows.ToString();
                lblAttemptCount.Text = rows + " attempt" + (rows != 1 ? "s" : "");
            }
            lblAvgScore.Text = avg + "%";
            lblBestScore.Text = best + "%";
            lblUniqueQuizzes.Text = seen.Count.ToString();
        }

        private void LoadEducatorAnalytics(int educatorID)
        {
            string query = @"
                WITH QC AS (SELECT QuizID,COUNT(*) AS TotalQ FROM QuizQuestions GROUP BY QuizID)
                SELECT q.QuizID, q.Title, q.DateCreated,
                       ISNULL(qc.TotalQ,0) AS TotalQuestions,
                       COUNT(qa.AttemptID) AS TotalAttempts,
                       ISNULL(CAST(ROUND(AVG(CASE WHEN ISNULL(qc.TotalQ,0)>0 THEN 100.0*qa.Score/qc.TotalQ ELSE NULL END),0) AS INT),0) AS AvgScore,
                       ISNULL(CAST(ROUND(MAX(CASE WHEN ISNULL(qc.TotalQ,0)>0 THEN 100.0*qa.Score/qc.TotalQ ELSE NULL END),0) AS INT),0) AS MaxScore
                FROM Quizzes q
                LEFT JOIN QC qc ON qc.QuizID=q.QuizID
                LEFT JOIN QuizAttempts qa ON qa.QuizID=q.QuizID
                WHERE q.EducatorID=@ID
                GROUP BY q.QuizID,q.Title,q.DateCreated,qc.TotalQ
                ORDER BY q.DateCreated DESC";

            DataTable dt = DatabaseHelper.ExecuteSelect(query, new[] { new SqlParameter("@ID", educatorID) });

            int total = 0; double sumAvg = 0, bestMax = 0;
            foreach (DataRow row in dt.Rows)
            {
                total += Convert.ToInt32(row["TotalAttempts"]);
                sumAvg += Convert.ToDouble(row["AvgScore"]);
                double mx = Convert.ToDouble(row["MaxScore"]);
                if (mx > bestMax) bestMax = mx;
            }
            double overallAvg = dt.Rows.Count > 0 ? Math.Round(sumAvg / dt.Rows.Count) : 0;

            lblTotalAttempts.Text = total.ToString();
            lblAvgScore.Text = overallAvg + "%";
            lblBestScore.Text = bestMax + "%";
            lblUniqueQuizzes.Text = dt.Rows.Count.ToString();
            lblAttemptCount.Text = total + " attempt" + (total != 1 ? "s" : "");

            int maxAvg = 1;
            foreach (DataRow row in dt.Rows) { int a = Convert.ToInt32(row["AvgScore"]); if (a > maxAvg) maxAvg = a; }

            DataTable chart = new DataTable();
            chart.Columns.Add("Title"); chart.Columns.Add("ShortTitle");
            chart.Columns.Add("AvgScore", typeof(int)); chart.Columns.Add("BarHeight", typeof(int));
            foreach (DataRow row in dt.Rows)
            {
                string t = row["Title"].ToString(); int avg = Convert.ToInt32(row["AvgScore"]);
                DataRow cr = chart.NewRow();
                cr["Title"] = t;
                cr["ShortTitle"] = t.Length > 10 ? t.Substring(0, 10) + "…" : t;
                cr["AvgScore"] = avg;
                cr["BarHeight"] = Math.Max(maxAvg > 0 ? (int)(140.0 * avg / maxAvg) : 4, 4);
                chart.Rows.Add(cr);
            }
            rptEducatorChart.DataSource = chart;
            rptEducatorChart.DataBind();
            rptEducatorStats.DataSource = dt;
            rptEducatorStats.DataBind();
        }

        private void LoadAdminAnalytics()
        {
            // Platform-wide headline stats
            string statsQ = @"
                SELECT
                    COUNT(DISTINCT q.QuizID) AS TotalQuizzes,
                    COUNT(qa.AttemptID)       AS TotalAttempts,
                    ISNULL(CAST(ROUND(AVG(CASE WHEN ISNULL(qc.TotalQ,0)>0 THEN 100.0*qa.Score/qc.TotalQ ELSE NULL END),0) AS INT),0) AS AvgScore,
                    ISNULL(CAST(ROUND(MAX(CASE WHEN ISNULL(qc.TotalQ,0)>0 THEN 100.0*qa.Score/qc.TotalQ ELSE NULL END),0) AS INT),0) AS BestScore
                FROM Quizzes q
                LEFT JOIN (SELECT QuizID,COUNT(*) AS TotalQ FROM QuizQuestions GROUP BY QuizID) qc ON qc.QuizID=q.QuizID
                LEFT JOIN QuizAttempts qa ON qa.QuizID=q.QuizID";

            DataTable stats = DatabaseHelper.ExecuteSelect(statsQ, null);
            if (stats.Rows.Count > 0)
            {
                DataRow r = stats.Rows[0];
                lblTotalAttempts.Text = r["TotalAttempts"].ToString();
                lblAvgScore.Text = r["AvgScore"] + "%";
                lblBestScore.Text = r["BestScore"] + "%";
                lblUniqueQuizzes.Text = r["TotalQuizzes"].ToString();
            }

            // Per-quiz breakdown table + bar chart (top 10 by attempts)
            string quizQ = @"
                WITH QC AS (SELECT QuizID,COUNT(*) AS TotalQ FROM QuizQuestions GROUP BY QuizID)
                SELECT q.QuizID, q.Title, q.DateCreated,
                       ISNULL(u.Username,'') AS EducatorName,
                       ISNULL(qc.TotalQ,0)  AS TotalQuestions,
                       COUNT(qa.AttemptID)   AS TotalAttempts,
                       ISNULL(CAST(ROUND(AVG(CASE WHEN ISNULL(qc.TotalQ,0)>0 THEN 100.0*qa.Score/qc.TotalQ ELSE NULL END),0) AS INT),0) AS AvgScore,
                       ISNULL(CAST(ROUND(MAX(CASE WHEN ISNULL(qc.TotalQ,0)>0 THEN 100.0*qa.Score/qc.TotalQ ELSE NULL END),0) AS INT),0) AS MaxScore
                FROM Quizzes q
                INNER JOIN Users u ON u.UserID=q.EducatorID
                LEFT JOIN QC qc ON qc.QuizID=q.QuizID
                LEFT JOIN QuizAttempts qa ON qa.QuizID=q.QuizID
                GROUP BY q.QuizID,q.Title,q.DateCreated,u.Username,qc.TotalQ
                ORDER BY TotalAttempts DESC";

            DataTable quizDt = DatabaseHelper.ExecuteSelect(quizQ, null);

            int maxAttempts = 1;
            foreach (DataRow row in quizDt.Rows) { int a = Convert.ToInt32(row["TotalAttempts"]); if (a > maxAttempts) maxAttempts = a; }

            DataTable chart = new DataTable();
            chart.Columns.Add("Title"); chart.Columns.Add("ShortTitle");
            chart.Columns.Add("AvgScore", typeof(int)); chart.Columns.Add("BarHeight", typeof(int));
            int count = 0;
            foreach (DataRow row in quizDt.Rows)
            {
                if (count++ >= 10) break;
                string t = row["Title"].ToString(); int atts = Convert.ToInt32(row["TotalAttempts"]);
                DataRow cr = chart.NewRow();
                cr["Title"] = t;
                cr["ShortTitle"] = t.Length > 10 ? t.Substring(0, 10) + "…" : t;
                cr["AvgScore"] = Convert.ToInt32(row["AvgScore"]);
                cr["BarHeight"] = Math.Max(maxAttempts > 0 ? (int)(140.0 * atts / maxAttempts) : 4, 4);
                chart.Rows.Add(cr);
            }
            rptAdminChart.DataSource = chart;
            rptAdminChart.DataBind();
            rptAdminStats.DataSource = quizDt;
            rptAdminStats.DataBind();
        }

        private bool TableExists(string tableName)
        {
            string sql = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME=@T AND TABLE_SCHEMA='dbo'";
            return Convert.ToInt32(DatabaseHelper.ExecuteScalar(sql, new[] { new SqlParameter("@T", tableName) })) > 0;
        }

        protected string GetScorePillClass(int pct)
        {
            if (pct >= 70) return "high";
            if (pct >= 40) return "mid";
            return "low";
        }
    }
}