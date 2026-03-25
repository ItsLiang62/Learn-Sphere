using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Learn_Sphere.Forms.Resources
{
    public partial class RecycleBin : System.Web.UI.Page
    {
        protected int CurrentUserID = 0;
        protected string CurrentRole = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
                CurrentUserID = Convert.ToInt32(Session["UserID"]);

            if (Session["Role"] != null)
                CurrentRole = Session["Role"].ToString();

            if (CurrentRole != "Administrator")
            {
                Response.Redirect("~/Forms/Resources/Home.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadDeletedResources();
            }
        }

        private void LoadDeletedResources()
        {
            string query = @"
                SELECT
                    r.ResourceID,
                    r.Title,
                    r.Description,
                    r.DeletedDate,
                    u.Username,
                    rc.CategoryName
                FROM Resources r
                INNER JOIN Users u ON r.UserID = u.UserID
                INNER JOIN ResourceCategories rc ON r.CategoryID = rc.CategoryID
                WHERE r.IsDeleted = 1
                ORDER BY r.DeletedDate DESC";

            DataTable dt = DatabaseHelper.ExecuteSelect(query);

            rptDeletedResources.DataSource = dt;
            rptDeletedResources.DataBind();
            pnlNoDeletedResources.Visible = (dt.Rows.Count == 0);
        }

        protected void rptDeletedResources_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Restore")
            {
                int resourceId = Convert.ToInt32(e.CommandArgument);

                string query = @"
                    UPDATE Resources
                    SET IsDeleted = 0,
                        DeletedByAdminID = NULL,
                        DeletedDate = NULL
                    WHERE ResourceID = @ResourceID";

                DatabaseHelper.ExecuteNonQuery(
                    query,
                    new SqlParameter("@ResourceID", resourceId)
                );

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Resource restored successfully.";

                LoadDeletedResources();
            }
        }
    }
}