<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="Learn_Sphere.Forms.Resources.Home" %>
<%@ Register Src="~/Shared/GlobalHeader.ascx" TagPrefix="uc" TagName="GlobalHeader" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Resources</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

    <style>
        body {
            margin: 0;
            font-family: 'Inter', sans-serif;
            background: #f7f5fb;
            color: #221b3a;
        }

        .hero-section {
            background: linear-gradient(180deg, #14001f 0%, #320052 45%, #4b007a 100%);
            padding: 72px 0 88px 0;
            color: white;
        }

        .hero-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 32px;
        }

        .hero-title {
            font-size: 4rem;
            font-weight: 800;
            line-height: 1.03;
            margin-bottom: 14px;
            letter-spacing: -1px;
        }

        .hero-title .accent {
            color: #a100ff;
        }

        .hero-subtitle {
            font-size: 1.15rem;
            color: rgba(255,255,255,0.75);
            margin-bottom: 36px;
            max-width: 760px;
        }

        .top-action-btn {
            display: inline-block;
            background: linear-gradient(135deg, #8a00ff, #b14cff);
            color: white !important;
            text-decoration: none;
            border: none;
            border-radius: 18px;
            padding: 14px 24px;
            font-weight: 700;
            box-shadow: 0 10px 24px rgba(138,0,255,0.28);
        }

        .content-wrap {
            max-width: 1200px;
            margin: 0 auto;
            padding: 34px 32px 60px 32px;
        }

        .toolbar-card {
            background: #ffffff;
            border: 1px solid #eadbff;
            border-radius: 26px;
            padding: 22px 24px;
            box-shadow: 0 8px 24px rgba(71, 19, 121, 0.05);
            margin-bottom: 34px;
        }

        .filter-label {
            font-weight: 700;
            color: #5a3e8a;
            margin-bottom: 10px;
            display: block;
        }

        .form-select {
            border-radius: 16px;
            min-height: 52px;
            border: 1px solid #ddccff;
            box-shadow: none !important;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 14px;
            margin-bottom: 18px;
            flex-wrap: wrap;
        }

        .section-title {
            font-size: 2rem;
            font-weight: 800;
            color: #30195c;
            margin: 0;
            letter-spacing: -0.5px;
        }

        .button-row {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .manage-btn {
            background: #f1ebfb;
            color: #5e4f80;
            border: 1px solid #ddccff;
            border-radius: 14px;
            padding: 10px 16px;
            font-weight: 700;
            text-decoration: none;
        }

        .manage-btn-danger {
            background: #fff1f1;
            color: #c62828;
            border: 1px solid #f3c4c4;
            border-radius: 14px;
            padding: 10px 16px;
            font-weight: 700;
            text-decoration: none;
        }

        .recycle-btn {
            background: #fff7e8;
            color: #9c5700 !important;
            border: 1px solid #ffd89a;
            border-radius: 14px;
            padding: 10px 16px;
            font-weight: 700;
            text-decoration: none;
        }

        .empty-box {
            background: #ffffff;
            border: 1px solid #eee6fb;
            border-radius: 24px;
            padding: 26px;
            color: #7c7195;
            box-shadow: 0 6px 18px rgba(56, 22, 87, 0.05);
            margin-bottom: 28px;
        }

        .bookmark-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 18px;
            margin-bottom: 34px;
        }

        .bookmark-mini-card {
            background: linear-gradient(135deg, #f3e8ff, #ffffff);
            border: 1px solid #dcbcff;
            border-top: 5px solid #8a00ff;
            border-radius: 22px;
            padding: 20px;
            box-shadow: 0 8px 22px rgba(138, 0, 255, 0.08);
            min-height: 190px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .bookmark-mini-title {
            font-size: 1.08rem;
            font-weight: 800;
            color: #2b0a5c;
            line-height: 1.4;
            margin-bottom: 12px;
        }

        .bookmark-mini-category {
            display: inline-block;
            background: #f5edff;
            color: #7a26ff;
            border-radius: 999px;
            padding: 6px 12px;
            font-size: 0.85rem;
            font-weight: 700;
            margin-bottom: 16px;
        }

        .bookmark-mini-actions {
            margin-top: auto;
        }

        .resource-card {
            background: #ffffff;
            border: 1px solid #eee6fb;
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 8px 20px rgba(71, 19, 121, 0.06);
            margin-bottom: 22px;
            transition: all 0.22s ease;
        }

        .resource-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 14px 28px rgba(71, 19, 121, 0.10);
        }

        .resource-title {
            font-size: 1.45rem;
            font-weight: 800;
            color: #2f195a;
            margin-bottom: 10px;
            line-height: 1.35;
        }

        .resource-desc {
            color: #695f82;
            margin-bottom: 14px;
            line-height: 1.7;
            font-size: 1rem;
        }

        .resource-meta {
            font-size: 0.95rem;
            color: #8b80a3;
            margin-bottom: 14px;
        }

        .resource-rating {
            font-weight: 700;
            color: #7c27ff;
            margin-bottom: 16px;
            font-size: 1rem;
        }

        .action-btn {
            display: inline-block;
            border-radius: 14px;
            padding: 10px 16px;
            font-weight: 700;
            font-size: 0.95rem;
            text-decoration: none;
            margin-right: 10px;
            margin-bottom: 10px;
            border: none;
        }

        .btn-bookmark {
            background: #f9c900;
            color: #2c2200 !important;
        }

        .btn-details {
            background: linear-gradient(135deg, #8a00ff, #6e57ff);
            color: white !important;
        }

        .btn-report {
            background: #f31200;
            color: white !important;
        }

        .btn-remove-mini {
            background: #fff1f1;
            color: #c62828 !important;
            border: 1px solid #f3c4c4;
        }

        .btn-delete-resource {
            background: #2f2f2f;
            color: white !important;
        }

        .message-label {
            font-weight: 700;
            margin-bottom: 18px;
            display: block;
        }

        @media (max-width: 992px) {
            .bookmark-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.8rem;
            }

            .section-title {
                font-size: 1.7rem;
            }

            .bookmark-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:GlobalHeader ID="GlobalHeader1" runat="server" />

        <section class="hero-section">
            <div class="hero-content">
                <div class="hero-title">
                    <asp:Literal ID="litHeroTitle" runat="server"></asp:Literal>
                </div>
                <div class="hero-subtitle">
                    <asp:Literal ID="litHeroSubtitle" runat="server"></asp:Literal>
                </div>

                <asp:HyperLink ID="hlCreateResource" runat="server"
                    NavigateUrl="~/Forms/Resources/CreateResource.aspx"
                    CssClass="top-action-btn">
                    + Add Resource
                </asp:HyperLink>
            </div>
        </section>

        <div class="content-wrap">
            <asp:Label ID="lblMessage" runat="server" CssClass="message-label"></asp:Label>

            <asp:Panel ID="pnlFilterToolbar" runat="server" CssClass="toolbar-card">
                <label class="filter-label">Category</label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select"
                    AutoPostBack="true" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged">
                </asp:DropDownList>
            </asp:Panel>

            <asp:Panel ID="pnlBookmarks" runat="server">
                <div class="section-header">
                    <div class="section-title">
                        <asp:Literal ID="litBookmarksTitle" runat="server"></asp:Literal>
                    </div>

                    <asp:Button ID="btnToggleManageBookmarks" runat="server"
                        Text="Manage Bookmark"
                        CssClass="manage-btn"
                        OnClick="btnToggleManageBookmarks_Click" />
                </div>

                <asp:Repeater ID="rptBookmarks" runat="server" OnItemCommand="rptResources_ItemCommand">
                    <HeaderTemplate>
                        <div class="bookmark-grid">
                    </HeaderTemplate>

                    <ItemTemplate>
                        <div class="bookmark-mini-card">
                            <div>
                                <div class="bookmark-mini-title"><%# Eval("Title") %></div>
                                <div class="bookmark-mini-category"><%# Eval("CategoryName") %></div>
                            </div>

                            <div class="bookmark-mini-actions">
                                <asp:HyperLink ID="hlDetails2" runat="server"
                                    NavigateUrl='<%# "~/Forms/Resources/ResourceDetails.aspx?ResourceID=" + Eval("ResourceID") %>'
                                    CssClass="action-btn btn-details">
                                    View Details
                                </asp:HyperLink>

                                <asp:Panel ID="pnlManageRemove" runat="server" Visible='<%# ShowManageBookmarks %>' style="display:inline;">
                                    <asp:LinkButton ID="btnUnbookmark" runat="server"
                                        CommandName="Bookmark"
                                        CommandArgument='<%# Eval("ResourceID") %>'
                                        CssClass="action-btn btn-remove-mini">
                                        Remove
                                    </asp:LinkButton>
                                </asp:Panel>
                            </div>
                        </div>
                    </ItemTemplate>

                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlNoBookmarks" runat="server" CssClass="empty-box" Visible="false">
                    No bookmarked resources yet.
                </asp:Panel>
            </asp:Panel>

            <asp:Panel ID="pnlAllResourcesSection" runat="server">
                <div class="section-header mt-4">
                    <div class="section-title">All Resources</div>

                    <asp:Panel ID="pnlAdminTools" runat="server" Visible="false">
                        <div class="button-row">
                            <asp:Button ID="btnToggleManageResources" runat="server"
                                Text="Manage Resources"
                                CssClass="manage-btn"
                                OnClick="btnToggleManageResources_Click" />

                            <asp:HyperLink ID="hlRecycleBin" runat="server"
                                NavigateUrl="~/Forms/Resources/RecycleBin.aspx"
                                CssClass="recycle-btn">
                                Recycle Bin
                            </asp:HyperLink>
                        </div>
                    </asp:Panel>
                </div>

                <asp:Repeater ID="rptResources" runat="server" OnItemCommand="rptResources_ItemCommand">
                    <ItemTemplate>
                        <div class="resource-card">
                            <div class="resource-title"><%# Eval("Title") %></div>

                            <div class="resource-desc">
                                <%# Eval("ShortDescription") %>
                            </div>

                            <div class="resource-meta">
                                By <%# Eval("Username") %> |
                                <%# Eval("DatePosted", "{0:dd MMM yyyy}") %> |
                                Category: <%# Eval("CategoryName") %>
                            </div>

                            <div class="resource-rating">
                                ⭐ <%# Eval("AverageRating") %> (<%# Eval("RatingCount") %> ratings)
                            </div>

                            <asp:Panel ID="pnlBookmarkButton" runat="server" Visible='<%# !IsAdmin %>' style="display:inline;">
                                <asp:LinkButton ID="btnBookmark" runat="server"
                                    CommandName="Bookmark"
                                    CommandArgument='<%# Eval("ResourceID") %>'
                                    CssClass="action-btn btn-bookmark">
                                    🔖 Bookmark
                                </asp:LinkButton>
                            </asp:Panel>

                            <asp:HyperLink ID="hlDetails" runat="server"
                                NavigateUrl='<%# "~/Forms/Resources/ResourceDetails.aspx?ResourceID=" + Eval("ResourceID") %>'
                                CssClass="action-btn btn-details">
                                View Details
                            </asp:HyperLink>

                            <asp:Panel ID="pnlReportButton" runat="server" Visible='<%# !IsAdmin %>' style="display:inline;">
                                <asp:HyperLink ID="hlReport" runat="server"
                                    NavigateUrl='<%# "~/Forms/Resources/ReportResource.aspx?ResourceID=" + Eval("ResourceID") %>'
                                    CssClass="action-btn btn-report">
                                    Report
                                </asp:HyperLink>
                            </asp:Panel>

                            <asp:Panel ID="pnlDeleteResource" runat="server" Visible='<%# IsAdmin && ShowManageResources %>' style="display:inline;">
                                <asp:LinkButton ID="btnDeleteResource" runat="server"
                                    CommandName="DeleteResource"
                                    CommandArgument='<%# Eval("ResourceID") %>'
                                    CssClass="action-btn btn-delete-resource"
                                    OnClientClick="return confirm('Move this resource to recycle bin?');">
                                    Delete
                                </asp:LinkButton>
                            </asp:Panel>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlNoResources" runat="server" CssClass="empty-box" Visible="false">
                    No resources found.
                </asp:Panel>
            </asp:Panel>
        </div>
    </form>
</body>
</html>