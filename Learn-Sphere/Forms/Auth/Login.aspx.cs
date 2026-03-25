using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;

namespace Learn_Sphere.Forms.Auth
{
    public partial class Login : System.Web.UI.Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string input = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            lblMessage.ForeColor = System.Drawing.Color.Red;

            if (string.IsNullOrEmpty(input) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please enter both email/username and password";
                return;
            }

            string query = @"SELECT UserID, Username, Email, PasswordHash, Role 
                             FROM Users 
                             WHERE (Email=@Input OR Username=@Input)";

            SqlParameter[] parameters = { new SqlParameter("@Input", input) };
            DataTable dt = DatabaseHelper.ExecuteSelect(query, parameters);

            if (dt.Rows.Count == 0)
            {
                lblMessage.Text = "Invalid credentials or not approved yet";
                return;
            }

            DataRow row = dt.Rows[0];
            if (!BCrypt.Net.BCrypt.Verify(password, row["PasswordHash"].ToString()))
            {
                lblMessage.Text = "Invalid credentials";
                return;
            }

            Session["UserID"] = Convert.ToInt32(row["UserID"]);
            Session["Username"] = row["Username"].ToString();
            Session["Role"] = row["Role"].ToString();

            Response.Redirect("~/Forms/Resources/Home.aspx");
        }
    }
}