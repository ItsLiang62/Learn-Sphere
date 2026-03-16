using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Learn_Sphere.Forms.Assessment
{
    public partial class TakeQuiz : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("~/Forms/Auth/Login.aspx");

            if (!IsPostBack)
            {
                string quizIDStr = Request.QueryString["quizID"];
                if (string.IsNullOrEmpty(quizIDStr))
                    Response.Redirect("~/Forms/Assessments/Home.aspx");

                hfQuizID.Value = quizIDStr;
                hfPhase.Value = "quiz";

                // Store view-only mode
                bool viewOnly = Request.QueryString["view"] == "1";
                Session["QuizViewOnly_" + quizIDStr] = viewOnly;

                LoadQuiz(Convert.ToInt32(quizIDStr), viewOnly);
            }
        }

        private void LoadQuiz(int quizID, bool viewOnly = false)
        {
            string metaQ = "SELECT Title, Description FROM Quizzes WHERE QuizID = @QID";
            DataTable meta = DatabaseHelper.ExecuteSelect(metaQ, new[] { new SqlParameter("@QID", quizID) });
            if (meta.Rows.Count == 0) { Response.Redirect("~/Forms/Assessments/Home.aspx"); return; }

            lblQuizTitle.Text = meta.Rows[0]["Title"].ToString();
            lblQuizDesc.Text = meta.Rows[0]["Description"].ToString();

            // Add view-only banner if needed
            if (viewOnly)
            {
                lblQuizDesc.Text += " — ⚠️ View Only Mode: You cannot submit this quiz.";
            }

            string qQ = @"SELECT QuestionID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption 
                   FROM QuizQuestions WHERE QuizID = @QID ORDER BY QuestionID";
            DataTable questions = DatabaseHelper.ExecuteSelect(qQ, new[] { new SqlParameter("@QID", quizID) });

            int total = questions.Rows.Count;
            questions.Columns.Add("Total", typeof(int));
            questions.Columns.Add("LastIndex", typeof(int));
            questions.Columns.Add("ViewOnly", typeof(bool));
            foreach (DataRow r in questions.Rows)
            {
                r["Total"] = total;
                r["LastIndex"] = total - 1;
                r["ViewOnly"] = viewOnly;
            }

            rptQuestions.DataSource = questions;
            rptQuestions.DataBind();

            rptDots.DataSource = questions;
            rptDots.DataBind();

            litTotalQ.Text = total.ToString();
            Session["QuizQuestions_" + quizID] = questions;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            bool viewOnly = Session["QuizViewOnly_" + hfQuizID.Value] as bool? ?? false;
            if (viewOnly)
            {
                Response.Redirect("~/Forms/Assessments/Home.aspx");
                return;
            }

            int quizID = Convert.ToInt32(hfQuizID.Value);
            int learnerID = Convert.ToInt32(Session["UserID"]);
            string role = Session["Role"]?.ToString();

            // Parse answers JSON
            string answersJson = hfAnswers.Value;
            var answers = new Dictionary<int, string>();
            if (!string.IsNullOrEmpty(answersJson))
            {
                answersJson = answersJson.Trim('{', '}');
                foreach (var pair in answersJson.Split(','))
                {
                    var kv = pair.Split(':');
                    if (kv.Length == 2)
                    {
                        string key = kv[0].Trim().Trim('"');
                        string val = kv[1].Trim().Trim('"');
                        if (int.TryParse(key, out int k)) answers[k] = val;
                    }
                }
            }

            // Load questions
            string qQ = @"SELECT QuestionID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption 
                           FROM QuizQuestions WHERE QuizID = @QID ORDER BY QuestionID";
            DataTable questions = DatabaseHelper.ExecuteSelect(qQ, new[] { new SqlParameter("@QID", quizID) });

            int score = 0;
            int total = questions.Rows.Count;
            var reviewData = new DataTable();
            reviewData.Columns.Add("QuestionText");
            reviewData.Columns.Add("SelectedOption");
            reviewData.Columns.Add("SelectedText");
            reviewData.Columns.Add("CorrectOption");
            reviewData.Columns.Add("CorrectText");
            reviewData.Columns.Add("IsCorrect", typeof(bool));
            reviewData.Columns.Add("QuestionID", typeof(int));

            for (int i = 0; i < questions.Rows.Count; i++)
            {
                DataRow r = questions.Rows[i];
                int qid = Convert.ToInt32(r["QuestionID"]);
                string correct = r["CorrectOption"].ToString().Trim().ToUpper();
                string selected = answers.ContainsKey(i) ? answers[i].Trim().ToUpper() : "";
                bool isCorrect = (selected == correct);
                if (isCorrect) score++;

                string selectedText = GetOptionText(r, selected);
                string correctText = GetOptionText(r, correct);

                DataRow rev = reviewData.NewRow();
                rev["QuestionText"] = r["QuestionText"];
                rev["SelectedOption"] = string.IsNullOrEmpty(selected) ? "—" : selected;
                rev["SelectedText"] = string.IsNullOrEmpty(selected) ? "Not answered" : selectedText;
                rev["CorrectOption"] = correct;
                rev["CorrectText"] = correctText;
                rev["IsCorrect"] = isCorrect;
                rev["QuestionID"] = qid;
                reviewData.Rows.Add(rev);
            }

            // Save attempt (only for learners)
            int attemptID = 0;
            if (role == "Learner")
            {
                string insertAttempt = @"INSERT INTO QuizAttempts (QuizID, LearnerID, Score)
                                         OUTPUT INSERTED.AttemptID VALUES (@QID, @LID, @Score)";
                attemptID = Convert.ToInt32(DatabaseHelper.ExecuteScalar(insertAttempt, new[] {
                    new SqlParameter("@QID", quizID),
                    new SqlParameter("@LID", learnerID),
                    new SqlParameter("@Score", score)
                }));

                // Save individual answers
                for (int i = 0; i < reviewData.Rows.Count; i++)
                {
                    DataRow rev = reviewData.Rows[i];
                    string sel = rev["SelectedOption"].ToString();
                    if (sel == "—") sel = "";
                    string insertAns = @"INSERT INTO QuizAnswers (AttemptID, QuestionID, SelectedOption, IsCorrect)
                                         VALUES (@AID, @QID, @Sel, @Corr)";
                    DatabaseHelper.ExecuteNonQuery(insertAns, new[] {
                        new SqlParameter("@AID", attemptID),
                        new SqlParameter("@QID", Convert.ToInt32(rev["QuestionID"])),
                        new SqlParameter("@Sel", string.IsNullOrEmpty(sel) ? (object)DBNull.Value : sel),
                        new SqlParameter("@Corr", (bool)rev["IsCorrect"])
                    });
                }
            }

            // Show result screen
            int pct = total > 0 ? (int)Math.Round(100.0 * score / total) : 0;

            pnlQuiz.Visible = false;
            pnlResult.Visible = true;
            hfPhase.Value = "result";

            lblScorePct.Text = pct.ToString();
            lblFinalScore.Text = $"{score} / {total}";
            lblCorrectCount.Text = score.ToString();
            lblWrongCount.Text = (total - score).ToString();

            if (pct >= 80) { lblResultHeading.Text = "Excellent! 🏆"; lblResultMsg.Text = "Outstanding performance! You've mastered this topic."; }
            else if (pct >= 60) { lblResultHeading.Text = "Good Job! ✅"; lblResultMsg.Text = "Solid performance. A little more practice and you'll ace it!"; }
            else if (pct >= 40) { lblResultHeading.Text = "Keep Going 💪"; lblResultMsg.Text = "You're making progress. Review the material and try again!"; }
            else { lblResultHeading.Text = "Needs More Study 📚"; lblResultMsg.Text = "Don't be discouraged—review the questions below and try again."; }

            rptReview.DataSource = reviewData;
            rptReview.DataBind();

            // Set ring via inline style (JS picks it up)
            Page.ClientScript.RegisterStartupScript(GetType(), "ring",
                $"document.getElementById('resultRing').style.setProperty('--pct','{pct}%');", true);
        }

        private string GetOptionText(DataRow row, string letter)
        {
            switch (letter)
            {
                case "A": return row["OptionA"].ToString();
                case "B": return row["OptionB"].ToString();
                case "C": return row["OptionC"].ToString();
                case "D": return row["OptionD"].ToString();
                default: return "";
            }
        }

        protected void btnBackHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Forms/Assessments/Home.aspx");
        }

        protected void btnRetry_Click(object sender, EventArgs e)
        {
            Response.Redirect($"~/Forms/Assessments/TakeQuiz.aspx?quizID={hfQuizID.Value}");
        }
    }
}
