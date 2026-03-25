using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Learn_Sphere.Forms.Resources
{
    public partial class CreateResource : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"] == null)
            {
                Response.Redirect("~/Forms/Auth/Login.aspx");
                return;
            }

            if (Session["Role"].ToString() != "Educator")
            {
                Response.Redirect("~/Forms/Resources/Home.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCategories();
            }
        }

        private void LoadCategories()
        {
            string query = "SELECT CategoryID, CategoryName FROM ResourceCategories ORDER BY CategoryName";
            DataTable dt = DatabaseHelper.ExecuteSelect(query);

            ddlCategory.Items.Clear();
            ddlCategory.Items.Add(new ListItem("-- Select Category --", "0"));

            foreach (DataRow row in dt.Rows)
            {
                ddlCategory.Items.Add(new ListItem(
                    row["CategoryName"].ToString(),
                    row["CategoryID"].ToString()
                ));
            }
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int userId = Convert.ToInt32(Session["UserID"]);

            string query = @"
                INSERT INTO Resources (UserID, CategoryID, Title, Description, ResourceLink)
                VALUES (@UserID, @CategoryID, @Title, @Description, @ResourceLink)";

            int rows = DatabaseHelper.ExecuteNonQuery(
                query,
                new SqlParameter("@UserID", userId),
                new SqlParameter("@CategoryID", Convert.ToInt32(ddlCategory.SelectedValue)),
                new SqlParameter("@Title", txtTitle.Text.Trim()),
                new SqlParameter("@Description", txtDescription.Text.Trim()),
                new SqlParameter("@ResourceLink", txtResourceLink.Text.Trim())
            );

            if (rows > 0)
            {
                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Resource created successfully.";

                txtTitle.Text = "";
                txtDescription.Text = "";
                txtResourceLink.Text = "";
                ddlCategory.SelectedIndex = 0;
            }
            else
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Failed to create resource.";
            }
        }
    }
}