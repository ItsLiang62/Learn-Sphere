using System;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

namespace Learn_Sphere.Forms.Auth
{
    public partial class Register : System.Web.UI.Page
    {
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string role = ddlRole.SelectedValue;

            lblMessage.ForeColor = System.Drawing.Color.Red;

            if (string.IsNullOrEmpty(email) || 
                string.IsNullOrEmpty(username) || 
                string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please fill all fields";
                return;
            }

            if (!Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            {
                lblMessage.Text = "Invalid email format";
                return;
            }

            if (!Regex.IsMatch(username, @"^[A-Za-z]+$"))
            {
                lblMessage.Text = "Username can contain only letters";
                return;
            }

            if (password.Length < 4)
            {
                lblMessage.Text = "Password must be at least 4 characters";
                return;
            }

            string passwordHash = BCrypt.Net.BCrypt.HashPassword(password);

            SqlParameter[] parameters =
            {
                new SqlParameter("@Email", email),
                new SqlParameter("@Username", username)
            };

            string usersQuery = @"SELECT COUNT(*) FROM Users 
                                  WHERE Email=@Email OR Username=@Username";
            int usersMatch = Convert.ToInt32(DatabaseHelper.ExecuteScalar(usersQuery, parameters));

            string appQuery = @"SELECT COUNT(*) FROM EducatorApplications
                                WHERE (Email=@Email OR Username=@Username)
                                AND VerificationStatus IN ('Pending','Approved')";
            int appMatch = Convert.ToInt32(DatabaseHelper.ExecuteScalar(appQuery, parameters));

            // =========================
            // LEARNER LOGIC
            // =========================
            if (role == "Learner")
            {
                if (usersMatch > 0)
                {
                    lblMessage.Text = "Username or email already exists as a user.";
                    return;
                }

                if (appMatch > 0)
                {
                    lblMessage.Text = "Username or email already have a pending or approved educator application.";
                    return;
                }

                string insertQuery = @"INSERT INTO Users (Username, Email, PasswordHash, Role)
                                       VALUES (@Username,@Email,@PasswordHash,@Role)";

                SqlParameter[] insertParams =
                {
                    new SqlParameter("@Username", username),
                    new SqlParameter("@Email", email),
                    new SqlParameter("@PasswordHash", passwordHash),
                    new SqlParameter("@Role", role)
                };

                DatabaseHelper.ExecuteNonQuery(insertQuery, insertParams);

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Registration successful! You can login now.";
                return;
            }

            // =========================
            // EDUCATOR LOGIC
            // =========================

            Session["Username"] = username;
            Session["Email"] = email;
            Session["PasswordHash"] = passwordHash;

            Response.Redirect("~/Forms/Auth/EducatorApplication.aspx");
        }
    }
}