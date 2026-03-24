<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="Learn_Sphere.Forms.Forums.Home" %>
<%@ Register Src="~/Shared/GlobalHeader.ascx" TagPrefix="uc" TagName="GlobalHeader" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Forums — LearnSphere</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&display=swap" rel="stylesheet" />

    <style>
        :root {
            --ink: #0d0d1a; --surface: #f4f3ff; --card: #ffffff;
            --accent: #5b4fff; --accent2: #ff4f8b; --accent3: #00d4aa;
            --muted: #7b7a99; --border: #e4e2ff;
            --shadow: 0 4px 24px rgba(91,79,255,0.10);
        }
        * { box-sizing: border-box; }
        body {
            font-family: 'Roboto', sans-serif;
            background: var(--surface);
            color: var(--ink);
            margin: 0;
        }

        .forum-hero {
            background: linear-gradient(135deg, #0d0d1a 0%, #1a1040 60%, #2d1260 100%);
            padding: 56px 0 72px;
            position: relative;
            overflow: hidden;
        }

        .forum-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background:
                radial-gradient(ellipse at 20% 80%, rgba(91,79,255,0.30) 0%, transparent 60%),
                radial-gradient(ellipse at 80% 20%, rgba(255,79,139,0.20) 0%, transparent 55%);
        }

        .forum-hero .container {
            position: relative;
            z-index: 1;
        }

        .forum-title {
            font-size: 3rem;
            font-weight: 900;
            color: #fff;
            margin-bottom: 8px;
            letter-spacing: -1px;
        }

        .forum-subtitle {
            color: rgba(255,255,255,0.65);
            font-size: 1rem;
            font-weight: 300;
            margin-bottom: 0;
        }

        .forum-main {
            padding: 36px 0 70px;
        }

        .top-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
            flex-wrap: wrap;
        }

        .action-group {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn-main {
            border: none;
            border-radius: 12px;
            padding: 11px 20px;
            font-weight: 700;
            color: #fff;
            background: linear-gradient(135deg, var(--accent), #7c6fff);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: var(--shadow);
        }

        .btn-main:hover {
            opacity: 0.92;
            color: #fff;
        }

        .btn-alt {
            border: 1.5px solid var(--border);
            border-radius: 12px;
            padding: 11px 18px;
            font-weight: 700;
            color: var(--ink);
            background: #fff;
            text-decoration: none;
        }

        .btn-alt:hover {
            color: var(--accent);
            border-color: var(--accent);
        }

        .msg-label {
            font-weight: 700;
        }

        .forum-card {
            background: var(--card);
            border-radius: 18px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 20px;
        }

        .forum-card-body {
            padding: 24px;
        }

        .forum-card h4 {
            font-size: 1.4rem;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .meta {
            color: var(--muted);
            font-size: 0.92rem;
            margin-bottom: 14px;
        }

        .content-preview {
            font-size: 0.98rem;
            color: #2a2940;
            margin-bottom: 18px;
            line-height: 1.6;
        }

        .post-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-small {
            border-radius: 10px;
            padding: 8px 14px;
            font-size: 0.9rem;
            font-weight: 700;
            text-decoration: none;
            border: 1px solid var(--border);
            background: #fff;
            color: var(--ink);
        }

        .btn-small:hover {
            color: var(--accent);
            border-color: var(--accent);
        }

        .btn-danger-soft:hover {
            color: #dc3545;
            border-color: #dc3545;
        }

        .pin-badge {
            display: inline-block;
            margin-left: 8px;
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.4px;
            text-transform: uppercase;
            padding: 4px 10px;
            border-radius: 999px;
            background: rgba(91,79,255,0.12);
            color: var(--accent);
            border: 1px solid rgba(91,79,255,0.22);
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:GlobalHeader ID="GlobalHeader1" runat="server" />

        <div class="forum-hero">
            <div class="container">
                <h1 class="forum-title">Forums</h1>
                <p class="forum-subtitle">Join discussions, share ideas, and explore community conversations.</p>
            </div>
        </div>

        <div class="container forum-main">
            <div class="top-actions">
                <asp:Label ID="lblMessage" runat="server" CssClass="msg-label"></asp:Label>

                <div class="action-group">
                    <asp:HyperLink ID="hlManageReports" runat="server" NavigateUrl="~/Forms/Admin/ManageReports.aspx" CssClass="btn-alt" Visible="false">
                        <i class="fa-solid fa-shield-halved"></i> Manage Reports
                    </asp:HyperLink>

                    <asp:HyperLink ID="hlCreatePost" runat="server" NavigateUrl="~/Forms/Forums/CreatePost.aspx" CssClass="btn-main">
                        <i class="fa-solid fa-plus"></i> Create Post
                    </asp:HyperLink>
                </div>
            </div>

            <asp:Repeater ID="rptPosts" runat="server" OnItemCommand="rptPosts_ItemCommand">
                <ItemTemplate>
                    <div class="forum-card">
                        <div class="forum-card-body">
                            <h4>
                                <%# Eval("Title") %>
                                <%# Convert.ToBoolean(Eval("IsPinned")) ? "<span class='pin-badge'>Pinned</span>" : "" %>
                            </h4>

                            <div class="meta">
                                By <%# Eval("Username") %> | <%# Eval("DatePosted", "{0:dd/MM/yyyy hh:mm tt}") %>
                            </div>

                            <div class="content-preview">
                                <%# Eval("ShortContent") %>
                            </div>

                            <div class="post-actions">
                                <asp:HyperLink ID="hlView" runat="server"
                                    NavigateUrl='<%# "~/Forms/Forums/PostDetails.aspx?PostID=" + Eval("PostID") %>'
                                    CssClass="btn-small">
                                    View Details
                                </asp:HyperLink>

                                <asp:HyperLink ID="hlReportPost" runat="server"
                                    NavigateUrl='<%# "~/Forms/Forums/ReportItem.aspx?Type=Post&PostID=" + Eval("PostID") %>'
                                    CssClass="btn-small btn-danger-soft"
                                    Visible='<%# Session["Role"] == null || Session["Role"].ToString() != "Administrator" %>'>
                                    Report
                                </asp:HyperLink>

                                <asp:Button ID="btnPin" runat="server"
                                    Text='<%# Convert.ToInt32(Eval("UserID")) == CurrentUserID ? (Convert.ToBoolean(Eval("IsPinned")) ? "Unpin" : "Pin") : "" %>'
                                    CssClass="btn-small"
                                    CommandName="TogglePin"
                                    CommandArgument='<%# Eval("PostID") %>'
                                    Visible='<%# Convert.ToInt32(Eval("UserID")) == CurrentUserID %>' />
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </form>
</body>
</html>