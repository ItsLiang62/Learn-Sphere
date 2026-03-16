using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Learn_Sphere.Shared
{
    public partial class GlobalHeader : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Show Educator Applications link only for admin
            if (Session["Role"] != null && Session["Role"].ToString() == "Administrator")
            {
                hlEducatorApps.Visible = true;
            }

            // Highlight the active module
            string currentPage = Request.Url.AbsolutePath.ToLower();
            if (currentPage.Contains("/resources"))
                hlResources.CssClass += " active";
            else if (currentPage.Contains("/forums"))
                hlForums.CssClass += " active";
            else if (currentPage.Contains("/assessment"))
                hlAssessments.CssClass += " active";
            else if (currentPage.Contains("/eduapp"))
                hlEducatorApps.CssClass += " active";
        }

        protected void btnProfile_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Forms/Profile/Profile.aspx");
        }

        protected void btnMessages_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Forms/Messaging/Messages.aspx");
        }
    }
}