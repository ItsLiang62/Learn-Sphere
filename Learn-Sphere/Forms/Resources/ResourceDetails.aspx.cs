using System;
using System.Data;
using System.Data.SqlClient;

namespace Learn_Sphere.Forms.Resources
{
    public partial class ResourceDetails : System.Web.UI.Page
    {
        protected int ResourceID = 0;
        protected int CurrentUserID = 0;
        protected string CurrentRole = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["ResourceID"] == null)
            {
                Response.Redirect("~/Forms/Resources/Home.aspx");
                return;
            }

            ResourceID = Convert.ToInt32(Request.QueryString["ResourceID"]);

            if (Session["UserID"] != null)
                CurrentUserID = Convert.ToInt32(Session["UserID"]);

            if (Session["Role"] != null)
                CurrentRole = Session["Role"].ToString();

            if (!IsPostBack)
            {
                hlReport.NavigateUrl = "~/Forms/Resources/ReportResource.aspx?ResourceID=" + ResourceID;
                btnDelete.Visible = (CurrentRole == "Administrator");
                LoadResourceDetails();
                LoadUserRating();
            }
        }

        private void LoadResourceDetails()
        {
            string query = @"
                SELECT 
                    r.ResourceID,
                    r.Title,
                    r.Description,
                    r.ResourceLink,
                    r.DatePosted,
                    u.Username,
                    rc.CategoryName,
                    ISNULL(CAST(ROUND(AVG(CAST(rr.RatingValue AS FLOAT)), 1) AS DECIMAL(10,1)), 0) AS AverageRating,
                    COUNT(rr.RatingID) AS RatingCount
                FROM Resources r
                INNER JOIN Users u ON r.UserID = u.UserID
                INNER JOIN ResourceCategories rc ON r.CategoryID = rc.CategoryID
                LEFT JOIN ResourceRatings rr ON r.ResourceID = rr.ResourceID
                WHERE r.ResourceID = @ResourceID AND r.IsDeleted = 0
                GROUP BY r.ResourceID, r.Title, r.Description, r.ResourceLink, r.DatePosted, u.Username, rc.CategoryName";

            DataTable dt = DatabaseHelper.ExecuteSelect(
                query,
                new SqlParameter("@ResourceID", ResourceID)
            );

            if (dt.Rows.Count == 0)
            {
                Response.Redirect("~/Forms/Resources/Home.aspx");
                return;
            }

            DataRow row = dt.Rows[0];

            lblTitle.Text = row["Title"].ToString();
            lblDescription.Text = row["Description"].ToString();
            lblUsername.Text = row["Username"].ToString();
            lblDatePosted.Text = Convert.ToDateTime(row["DatePosted"]).ToString("dd MMM yyyy");
            lblCategory.Text = row["CategoryName"].ToString();
            lblAverageRating.Text = row["AverageRating"].ToString();
            lblRatingCount.Text = row["RatingCount"].ToString();

            hlResourceLink.Text = row["ResourceLink"].ToString();
            hlResourceLink.NavigateUrl = row["ResourceLink"].ToString();
        }

        private void LoadUserRating()
        {
            if (CurrentUserID == 0) return;

            string query = @"
                SELECT RatingValue
                FROM ResourceRatings
                WHERE UserID = @UserID AND ResourceID = @ResourceID";

            object result = DatabaseHelper.ExecuteScalar(
                query,
                new SqlParameter("@UserID", CurrentUserID),
                new SqlParameter("@ResourceID", ResourceID)
            );

            if (result != null)
                ddlRating.SelectedValue = result.ToString();
        }

        protected void btnBookmark_Click(object sender, EventArgs e)
        {
            if (CurrentUserID == 0)
            {
                Response.Redirect("~/Forms/Auth/Login.aspx");
                return;
            }

            string checkQuery = @"
                SELECT COUNT(*)
                FROM ResourceBookmarks
                WHERE UserID = @UserID AND ResourceID = @ResourceID";

            int count = Convert.ToInt32(DatabaseHelper.ExecuteScalar(
                checkQuery,
                new SqlParameter("@UserID", CurrentUserID),
                new SqlParameter("@ResourceID", ResourceID)
            ));

            if (count > 0)
            {
                string deleteQuery = @"
                    DELETE FROM ResourceBookmarks
                    WHERE UserID = @UserID AND ResourceID = @ResourceID";

                DatabaseHelper.ExecuteNonQuery(
                    deleteQuery,
                    new SqlParameter("@UserID", CurrentUserID),
                    new SqlParameter("@ResourceID", ResourceID)
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
                    new SqlParameter("@ResourceID", ResourceID)
                );

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Resource bookmarked successfully.";
            }
        }

        protected void btnSubmitRating_Click(object sender, EventArgs e)
        {
            if (CurrentUserID == 0)
            {
                Response.Redirect("~/Forms/Auth/Login.aspx");
                return;
            }

            int ratingValue = Convert.ToInt32(ddlRating.SelectedValue);

            string checkQuery = @"
                SELECT COUNT(*)
                FROM ResourceRatings
                WHERE UserID = @UserID AND ResourceID = @ResourceID";

            int count = Convert.ToInt32(DatabaseHelper.ExecuteScalar(
                checkQuery,
                new SqlParameter("@UserID", CurrentUserID),
                new SqlParameter("@ResourceID", ResourceID)
            ));

            if (count > 0)
            {
                string updateQuery = @"
                    UPDATE ResourceRatings
                    SET RatingValue = @RatingValue, DateRated = GETDATE()
                    WHERE UserID = @UserID AND ResourceID = @ResourceID";

                DatabaseHelper.ExecuteNonQuery(
                    updateQuery,
                    new SqlParameter("@RatingValue", ratingValue),
                    new SqlParameter("@UserID", CurrentUserID),
                    new SqlParameter("@ResourceID", ResourceID)
                );

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Rating updated successfully.";
            }
            else
            {
                string insertQuery = @"
                    INSERT INTO ResourceRatings (UserID, ResourceID, RatingValue)
                    VALUES (@UserID, @ResourceID, @RatingValue)";

                DatabaseHelper.ExecuteNonQuery(
                    insertQuery,
                    new SqlParameter("@UserID", CurrentUserID),
                    new SqlParameter("@ResourceID", ResourceID),
                    new SqlParameter("@RatingValue", ratingValue)
                );

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Rating submitted successfully.";
            }

            LoadResourceDetails();
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (CurrentRole != "Administrator")
            {
                Response.Redirect("~/Forms/Resources/Home.aspx");
                return;
            }

            int deletedByAdminID = Convert.ToInt32(Session["UserID"]);

            string query = @"
                UPDATE Resources
                SET IsDeleted = 1,
                    DeletedByAdminID = @DeletedByAdminID,
                    DeletedDate = GETDATE()
                WHERE ResourceID = @ResourceID";

            DatabaseHelper.ExecuteNonQuery(
                query,
                new SqlParameter("@DeletedByAdminID", deletedByAdminID),
                new SqlParameter("@ResourceID", ResourceID)
            );

            Response.Redirect("~/Forms/Resources/Home.aspx");
        }
    }
}