using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Learn_Sphere.Forms.Resources
{
    public partial class Home : System.Web.UI.Page
    {
        protected int CurrentUserID = 0;
        protected string CurrentRole = "";
        protected bool ShowManageBookmarks = false;
        protected bool ShowManageResources = false;
        protected bool IsAdmin = false;
        protected bool ShowSavedOnly = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
                CurrentUserID = Convert.ToInt32(Session["UserID"]);

            if (Session["Role"] != null)
                CurrentRole = Session["Role"].ToString();

            IsAdmin = (CurrentRole == "Administrator");
            ShowSavedOnly = (Request.QueryString["scope"] != null &&
                             Request.QueryString["scope"].ToString().Equals("saved", StringComparison.OrdinalIgnoreCase));

            if (Session["ShowManageBookmarks"] != null)
                ShowManageBookmarks = Convert.ToBoolean(Session["ShowManageBookmarks"]);

            if (Session["ShowManageResources"] != null)
                ShowManageResources = Convert.ToBoolean(Session["ShowManageResources"]);

            if (!IsPostBack)
            {
                hlCreateResource.Visible = (CurrentRole == "Educator");

                pnlAdminTools.Visible = IsAdmin && !ShowSavedOnly;
                pnlAllResourcesSection.Visible = !ShowSavedOnly;
                pnlFilterToolbar.Visible = !ShowSavedOnly;

                // Admin should not see bookmark section at all
                pnlBookmarks.Visible = !IsAdmin;

                if (ShowSavedOnly)
                {
                    litHeroTitle.Text = "Saved<br /><span class='accent'>Resources</span>";
                    litHeroSubtitle.Text = "View only the resources you bookmarked.";
                    litBookmarksTitle.Text = "Saved Resources";
                }
                else
                {
                    litHeroTitle.Text = "Resource<br /><span class='accent'>Hub</span>";
                    litHeroSubtitle.Text = "Explore quality learning materials, bookmark your favourites, rate useful content, and report inappropriate resources.";
                    litBookmarksTitle.Text = "Bookmarked Resources";
                }

                UpdateManageBookmarkButtonText();
                UpdateManageResourcesButtonText();

                LoadCategories();
                LoadResources();

                if (!IsAdmin)
                    LoadBookmarks();
            }
        }

        private void UpdateManageBookmarkButtonText()
        {
            btnToggleManageBookmarks.Text = ShowManageBookmarks ? "Done Managing" : "Manage Bookmark";
            btnToggleManageBookmarks.CssClass = ShowManageBookmarks ? "manage-btn-danger" : "manage-btn";
        }

        private void UpdateManageResourcesButtonText()
        {
            btnToggleManageResources.Text = ShowManageResources ? "Done Managing Resources" : "Manage Resources";
            btnToggleManageResources.CssClass = ShowManageResources ? "manage-btn-danger" : "manage-btn";
        }

        private void LoadCategories()
        {
            string query = "SELECT CategoryID, CategoryName FROM ResourceCategories ORDER BY CategoryName";
            DataTable dt = DatabaseHelper.ExecuteSelect(query);

            ddlCategory.Items.Clear();
            ddlCategory.Items.Add(new ListItem("All Categories", "0"));

            foreach (DataRow row in dt.Rows)
            {
                ddlCategory.Items.Add(new ListItem(
                    row["CategoryName"].ToString(),
                    row["CategoryID"].ToString()
                ));
            }
        }

        private void LoadResources()
        {
            if (ShowSavedOnly)
            {
                rptResources.DataSource = null;
                rptResources.DataBind();
                pnlNoResources.Visible = false;
                return;
            }

            int categoryId = Convert.ToInt32(ddlCategory.SelectedValue);

            string query = @"
                SELECT 
                    r.ResourceID,
                    r.Title,
                    CASE 
                        WHEN LEN(r.Description) > 220 THEN LEFT(r.Description, 220) + '...'
                        ELSE r.Description
                    END AS ShortDescription,
                    r.DatePosted,
                    u.Username,
                    rc.CategoryName,
                    ISNULL(CAST(ROUND(AVG(CAST(rr.RatingValue AS FLOAT)), 1) AS DECIMAL(10,1)), 0) AS AverageRating,
                    COUNT(rr.RatingID) AS RatingCount
                FROM Resources r
                INNER JOIN Users u ON r.UserID = u.UserID
                INNER JOIN ResourceCategories rc ON r.CategoryID = rc.CategoryID
                LEFT JOIN ResourceRatings rr ON r.ResourceID = rr.ResourceID
                WHERE r.IsDeleted = 0
                  AND (@CategoryID = 0 OR r.CategoryID = @CategoryID)
                GROUP BY r.ResourceID, r.Title, r.Description, r.DatePosted, u.Username, rc.CategoryName
                ORDER BY r.DatePosted DESC";

            DataTable dt = DatabaseHelper.ExecuteSelect(
                query,
                new SqlParameter("@CategoryID", categoryId)
            );

            rptResources.DataSource = dt;
            rptResources.DataBind();
            pnlNoResources.Visible = (dt.Rows.Count == 0);
        }

        private void LoadBookmarks()
        {
            if (CurrentUserID == 0 || IsAdmin)
            {
                pnlBookmarks.Visible = false;
                return;
            }

            pnlBookmarks.Visible = true;

            string query = @"
                SELECT 
                    r.ResourceID,
                    r.Title,
                    r.DatePosted,
                    u.Username,
                    rc.CategoryName,
                    ISNULL(CAST(ROUND(AVG(CAST(rr.RatingValue AS FLOAT)), 1) AS DECIMAL(10,1)), 0) AS AverageRating,
                    COUNT(rr.RatingID) AS RatingCount
                FROM ResourceBookmarks rb
                INNER JOIN Resources r ON rb.ResourceID = r.ResourceID
                INNER JOIN Users u ON r.UserID = u.UserID
                INNER JOIN ResourceCategories rc ON r.CategoryID = rc.CategoryID
                LEFT JOIN ResourceRatings rr ON r.ResourceID = rr.ResourceID
                WHERE rb.UserID = @UserID AND r.IsDeleted = 0
                GROUP BY r.ResourceID, r.Title, r.DatePosted, u.Username, rc.CategoryName, rb.DateBookmarked
                ORDER BY rb.DateBookmarked DESC";

            DataTable dt = DatabaseHelper.ExecuteSelect(
                query,
                new SqlParameter("@UserID", CurrentUserID)
            );

            rptBookmarks.DataSource = dt;
            rptBookmarks.DataBind();
            pnlNoBookmarks.Visible = (dt.Rows.Count == 0);
        }

        protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadResources();
        }

        protected void btnToggleManageBookmarks_Click(object sender, EventArgs e)
        {
            if (IsAdmin) return;

            ShowManageBookmarks = !ShowManageBookmarks;
            Session["ShowManageBookmarks"] = ShowManageBookmarks;

            UpdateManageBookmarkButtonText();
            LoadBookmarks();
        }

        protected void btnToggleManageResources_Click(object sender, EventArgs e)
        {
            if (!IsAdmin) return;

            ShowManageResources = !ShowManageResources;
            Session["ShowManageResources"] = ShowManageResources;

            UpdateManageResourcesButtonText();
            LoadResources();
        }

        protected void rptResources_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Bookmark")
            {
                if (CurrentUserID == 0 || IsAdmin)
                {
                    Response.Redirect("~/Forms/Auth/Login.aspx");
                    return;
                }

                int resourceId = Convert.ToInt32(e.CommandArgument);

                string checkQuery = @"
                    SELECT COUNT(*)
                    FROM ResourceBookmarks
                    WHERE UserID = @UserID AND ResourceID = @ResourceID";

                int count = Convert.ToInt32(DatabaseHelper.ExecuteScalar(
                    checkQuery,
                    new SqlParameter("@UserID", CurrentUserID),
                    new SqlParameter("@ResourceID", resourceId)
                ));

                if (count > 0)
                {
                    string deleteQuery = @"
                        DELETE FROM ResourceBookmarks
                        WHERE UserID = @UserID AND ResourceID = @ResourceID";

                    DatabaseHelper.ExecuteNonQuery(
                        deleteQuery,
                        new SqlParameter("@UserID", CurrentUserID),
                        new SqlParameter("@ResourceID", resourceId)
                    );

                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Text = "Bookmark removed.";
                }
                else
                {
                    string insertQuery = @"
                        INSERT INTO ResourceBookmarks (UserID, ResourceID)
                        VALUES (@UserID, @ResourceID)";

                    DatabaseHelper.ExecuteNonQuery(
                        insertQuery,
                        new SqlParameter("@UserID", CurrentUserID),
                        new SqlParameter("@ResourceID", resourceId)
                    );

                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Text = "Resource bookmarked successfully.";
                }

                LoadResources();
                if (!IsAdmin) LoadBookmarks();
            }
            else if (e.CommandName == "DeleteResource")
            {
                if (!IsAdmin) return;

                int resourceId = Convert.ToInt32(e.CommandArgument);

                string deleteQuery = @"
                    UPDATE Resources
                    SET IsDeleted = 1,
                        DeletedByAdminID = @DeletedByAdminID,
                        DeletedDate = GETDATE()
                    WHERE ResourceID = @ResourceID";

                DatabaseHelper.ExecuteNonQuery(
                    deleteQuery,
                    new SqlParameter("@DeletedByAdminID", CurrentUserID),
                    new SqlParameter("@ResourceID", resourceId)
                );

                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Resource moved to recycle bin.";

                LoadResources();
            }
        }
    }
}