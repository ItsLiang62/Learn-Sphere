<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="GlobalHeader.ascx.cs" Inherits="Learn_Sphere.Shared.GlobalHeader" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<style>
    /* Darker header with more vertical space */
    .global-header {
        background: linear-gradient(135deg, #3b3f7c 0%, #2b2e5c 100%);
        padding: 1rem 2rem; /* Increased vertical padding */
        display: flex;
        align-items: center;
        justify-content: space-between;
        box-shadow: 0 4px 12px rgba(0,0,0,0.25);
    }

    .global-header .logo img {
        height: 40px;
    }

    /* Navigation links */
    .global-header nav a {
        color: white;
        font-weight: 500;
        margin-right: 1.5rem;
        text-decoration: none;
        transition: all 0.2s ease;
        font-size: 1.1rem;
    }

    .global-header nav a:hover {
        color: #ffe600;
        text-decoration: underline;
    }

    /* Active module styling */
    .global-header nav a.active {
        color: #ffe600;
        font-weight: 600;
        border-bottom: 2px solid #ffe600;
        padding-bottom: 4px;
    }

    .icon-buttons {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .icon-btn {
        color: white;
        font-size: 1.5rem;
        position: relative;
        border: none;
        background: none;
        cursor: pointer;
    }

    .icon-btn:hover {
        color: #ffe600;
    }

    /* Red dot for unread messages */
    .icon-btn .unread-dot {
        position: absolute;
        top: 0px;
        right: 0px;
        width: 10px;
        height: 10px;
        background: red;
        border-radius: 50%;
        border: 2px solid white;
    }

    @media(max-width:768px){
        .global-header nav a {
            margin-right: 0.8rem;
            font-size: 0.95rem;
        }
        .icon-btn {
            font-size: 1.25rem;
        }
    }
</style>

<div class="global-header">
    <!-- Logo -->
    <div class="logo">
        <asp:HyperLink ID="hlHome" runat="server" NavigateUrl="~/Forms/Home.aspx">
            <asp:Image ID="imgLogo" runat="server" ImageUrl="~/Images/logo-dark-mode.png" AlternateText="LearnSphere Logo" CssClass="logo-img" />
        </asp:HyperLink>
    </div>

    <!-- Navigation links -->
    <nav>
        <asp:HyperLink ID="hlResources" runat="server" NavigateUrl="~/Forms/Resources/Home.aspx">Resources</asp:HyperLink>
        <asp:HyperLink ID="hlForums" runat="server" NavigateUrl="~/Forms/Forums/Home.aspx">Forums</asp:HyperLink>
        <asp:HyperLink ID="hlAssessments" runat="server" NavigateUrl="~/Forms/Assessments/Home.aspx">Assessments</asp:HyperLink>
        <asp:HyperLink ID="hlEducatorApps" runat="server" NavigateUrl="~/Forms/EduApp/ProcessEducatorApplications.aspx" Visible="false">Educator Applications</asp:HyperLink>
        <asp:HyperLink ID="hlManageReports" runat="server" NavigateUrl="~/Forms/Admin/ManageReports.aspx" Visible="false">Manage Reports</asp:HyperLink>
    </nav>

    <!-- Profile & Message icons -->
    <div class="icon-buttons">
        <!-- Using LinkButton instead of Button to render HTML for icons -->
        <asp:LinkButton ID="btnMessages" runat="server" CssClass="icon-btn" OnClick="btnMessages_Click" ToolTip="Messages" >
            <i class="fa-solid fa-envelope"></i>
        </asp:LinkButton>

            <asp:LinkButton ID="btnNotifications" runat="server" CssClass="icon-btn" OnClick="btnNotifications_Click" ToolTip="Notifications">
        <i class="fa-solid fa-bell"></i>
    </asp:LinkButton>

        <asp:LinkButton ID="btnProfile" runat="server" CssClass="icon-btn" OnClick="btnProfile_Click" ToolTip="Profile">
            <i class="fa-solid fa-user"></i>
        </asp:LinkButton>
    </div>
</div>