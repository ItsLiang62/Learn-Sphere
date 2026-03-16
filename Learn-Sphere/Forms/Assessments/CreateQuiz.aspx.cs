using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Learn_Sphere.Forms.Assessment
{
    [Serializable]
    public class QuizQuestionData
    {
        public string QuestionText { get; set; } = "";
        public string OptionA { get; set; } = "";
        public string OptionB { get; set; } = "";
        public string OptionC { get; set; } = "";
        public string OptionD { get; set; } = "";
        public string CorrectOption { get; set; } = "";
    }

    public partial class CreateQuiz : Page
    {
        private const int MIN_QUESTIONS = 3;
        private const int MAX_QUESTIONS = 10;

        private List<QuizQuestionData> Questions
        {
            get
            {
                if (ViewState["QuestionsData"] == null)
                {
                    ViewState["QuestionsData"] = new List<QuizQuestionData>
                    {
                        new QuizQuestionData(),
                        new QuizQuestionData(),
                        new QuizQuestionData()
                    };
                }
                return (List<QuizQuestionData>)ViewState["QuestionsData"];
            }
            set
            {
                ViewState["QuestionsData"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"]?.ToString() != "Educator")
                Response.Redirect("~/Forms/Auth/Login.aspx");

            if (!IsPostBack)
            {
                BindQuestionsRepeater();
            }
        }

        private void BindQuestionsRepeater()
        {
            rptQuestions.DataSource = Questions;
            rptQuestions.DataBind();
        }

        private void SaveRepeaterData()
        {
            for (int i = 0; i < rptQuestions.Items.Count; i++)
            {
                var item = rptQuestions.Items[i];
                var data = Questions[i];

                TextBox txtQ = (TextBox)item.FindControl("txtQuestion");
                TextBox txtA = (TextBox)item.FindControl("txtOptionA");
                TextBox txtB = (TextBox)item.FindControl("txtOptionB");
                TextBox txtC = (TextBox)item.FindControl("txtOptionC");
                TextBox txtD = (TextBox)item.FindControl("txtOptionD");

                data.QuestionText = txtQ.Text.Trim();
                data.OptionA = txtA.Text.Trim();
                data.OptionB = txtB.Text.Trim();
                data.OptionC = txtC.Text.Trim();
                data.OptionD = txtD.Text.Trim();

                string radioName = $"q{i}_correct";
                string selected = Request.Form[radioName];
                data.CorrectOption = selected ?? "";
            }
            ViewState["QuestionsData"] = Questions;
        }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            SaveRepeaterData();

            if (Questions.Count >= MAX_QUESTIONS)
            {
                lblMessage.Text = $"Maximum {MAX_QUESTIONS} questions allowed.";
                return;
            }

            Questions.Add(new QuizQuestionData());
            BindQuestionsRepeater();
        }

        protected void RemoveQuestion_Click(object sender, EventArgs e)
        {
            SaveRepeaterData();

            int index = Convert.ToInt32(((Button)sender).CommandArgument);
            if (Questions.Count <= MIN_QUESTIONS)
            {
                lblMessage.Text = $"Quiz must have at least {MIN_QUESTIONS} questions.";
                return;
            }

            Questions.RemoveAt(index);
            BindQuestionsRepeater();
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Forms/Assessments/Home.aspx");
        }

        protected void btnCreateQuiz_Click(object sender, EventArgs e)
        {
            SaveRepeaterData();

            // Validate title
            if (string.IsNullOrWhiteSpace(txtTitle.Text))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Quiz title is required.";
                return;
            }

            // Validate questions and options
            for (int i = 0; i < Questions.Count; i++)
            {
                var q = Questions[i];
                if (string.IsNullOrWhiteSpace(q.QuestionText) ||
                    string.IsNullOrWhiteSpace(q.OptionA) ||
                    string.IsNullOrWhiteSpace(q.OptionB) ||
                    string.IsNullOrWhiteSpace(q.OptionC) ||
                    string.IsNullOrWhiteSpace(q.OptionD) ||
                    string.IsNullOrWhiteSpace(q.CorrectOption))
                {
                    lblMessage.Text = $"Please complete all fields and select correct option for Question {i + 1}.";
                    return;
                }
            }

            int educatorId = Convert.ToInt32(Session["UserID"]);

            // Insert Quiz
            string insertQuiz = @"INSERT INTO Quizzes (Title, Description, EducatorID)
                                  OUTPUT INSERTED.QuizID
                                  VALUES (@Title, @Desc, @EducatorID)";
            SqlParameter[] quizParams =
            {
                new SqlParameter("@Title", txtTitle.Text.Trim()),
                new SqlParameter("@Desc", txtDescription.Text.Trim()),
                new SqlParameter("@EducatorID", educatorId)
            };
            int quizID = Convert.ToInt32(DatabaseHelper.ExecuteScalar(insertQuiz, quizParams));

            // Insert Questions
            foreach (var q in Questions)
            {
                string insertQ = @"INSERT INTO QuizQuestions 
                                   (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption)
                                   VALUES (@QuizID, @Q, @A, @B, @C, @D, @Correct)";
                SqlParameter[] qParams =
                {
                    new SqlParameter("@QuizID", quizID),
                    new SqlParameter("@Q", q.QuestionText),
                    new SqlParameter("@A", q.OptionA),
                    new SqlParameter("@B", q.OptionB),
                    new SqlParameter("@C", q.OptionC),
                    new SqlParameter("@D", q.OptionD),
                    new SqlParameter("@Correct", q.CorrectOption)
                };
                DatabaseHelper.ExecuteNonQuery(insertQ, qParams);
            }

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "Quiz successfully created.";

            // Reset
            Questions = new List<QuizQuestionData>
            {
                new QuizQuestionData(),
                new QuizQuestionData(),
                new QuizQuestionData()
            };
            BindQuestionsRepeater();
            txtTitle.Text = "";
            txtDescription.Text = "";
        }
    }
}