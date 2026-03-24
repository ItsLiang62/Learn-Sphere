using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace Learn_Sphere.Forms.Forums
{
    public partial class CreatePost : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Forms/Auth/Login.aspx");
                return;
            }

            if (Session["Role"] == null)
            {
                Response.Redirect("~/Forms/Auth/Login.aspx");
                return;
            }

            string role = Session["Role"].ToString();
            if (role != "Learner" && role != "Educator")
            {
                Response.Redirect("~/Forms/Forums/Home.aspx");
                return;
            }
        }

        protected void btnPost_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int userId = Convert.ToInt32(Session["UserID"]);

            string query = @"
                INSERT INTO ForumPosts (UserID, Title, Content)
                VALUES (@UserID, @Title, @Content)";

            int rows = DatabaseHelper.ExecuteNonQuery(
                query,
                new SqlParameter("@UserID", userId),
                new SqlParameter("@Title", txtTitle.Text.Trim()),
                new SqlParameter("@Content", txtContent.Text.Trim())
            );

            if (rows > 0)
            {
                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Post created successfully.";
                txtTitle.Text = "";
                txtContent.Text = "";
            }
            else
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Failed to create post.";
            }
        }
    }
}