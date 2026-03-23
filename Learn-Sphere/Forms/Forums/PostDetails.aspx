<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PostDetails.aspx.cs" Inherits="Learn_Sphere.Forms.Forums.PostDetails" UnobtrusiveValidationMode="None" %>
<%@ Register Src="~/Shared/GlobalHeader.ascx" TagPrefix="uc" TagName="GlobalHeader" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Post Details — LearnSphere</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&display=swap" rel="stylesheet" />

    <style>
        :root {
            --ink: #0d0d1a;
            --surface: #f4f3ff;
            --card: #ffffff;
            --accent: #5b4fff;
            --accent2: #ff4f8b;
            --muted: #7b7a99;
            --border: #e4e2ff;
            --shadow: 0 4px 24px rgba(91,79,255,0.10);
        }

        * { box-sizing: border-box; }

        body {
            font-family: 'Roboto', sans-serif;
            background: var(--surface);
            color: var(--ink);
            margin: 0;
        }

        .page-hero {
            background: linear-gradient(135deg, #0d0d1a 0%, #1a1040 60%, #2d1260 100%);
            padding: 56px 0 72px;
            position: relative;
            overflow: hidden;
        }

        .page-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background:
                radial-gradient(ellipse at 20% 80%, rgba(91,79,255,0.30) 0%, transparent 60%),
                radial-gradient(ellipse at 80% 20%, rgba(255,79,139,0.20) 0%, transparent 55%);
        }

        .page-hero .container {
            position: relative;
            z-index: 1;
        }

        .page-title {
            font-size: 3rem;
            font-weight: 900;
            color: #fff;
            margin-bottom: 8px;
            letter-spacing: -1px;
        }

        .page-subtitle {
            color: rgba(255,255,255,0.65);
            font-size: 1rem;
            font-weight: 300;
            margin-bottom: 0;
        }

        .page-main {
            padding: 36px 0 70px;
        }

        .section-card {
            background: #fff;
            border-radius: 18px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            padding: 24px;
            margin-bottom: 22px;
        }

        .post-title {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 10px;
        }

        .meta {
            color: var(--muted);
            font-size: 0.95rem;
            margin-bottom: 16px;
        }

        .post-content {
            line-height: 1.7;
            font-size: 1rem;
            margin-bottom: 18px;
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

        .btn-danger-soft:hover {
            color: #dc3545;
            border-color: #dc3545;
        }

        .comment-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 18px 18px 16px;
            margin-bottom: 16px;
        }

        .comment-user {
            font-size: 1.15rem;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .comment-text {
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 16px;
        }

        .comment-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .comment-date {
            color: var(--muted);
            font-size: 0.92rem;
        }

        .form-control {
            border-radius: 12px;
            border: 1px solid var(--border);
            padding: 12px 14px;
        }

        .empty-text {
            color: var(--muted);
            margin-bottom: 0;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:GlobalHeader ID="GlobalHeader1" runat="server" />

        <div class="page-hero">
            <div class="container">
                <h1 class="page-title">Post Details</h1>
                <p class="page-subtitle">Read the full discussion and join the conversation.</p>
            </div>
        </div>

        <div class="container page-main">
            <div class="section-card">
                <div class="post-title">
                    <asp:Label ID="lblTitle" runat="server"></asp:Label>
                </div>

                <div class="meta">
                    By <asp:Label ID="lblAuthor" runat="server"></asp:Label> |
                    <asp:Label ID="lblDate" runat="server"></asp:Label>
                </div>

                <div class="post-content">
                    <asp:Literal ID="litContent" runat="server"></asp:Literal>
                </div>

                <asp:HyperLink ID="hlReportPost" runat="server" CssClass="btn-alt btn-danger-soft">
                    Report This Post
                </asp:HyperLink>

                <asp:Button ID="btnDeletePost" runat="server" Text="Delete Post" CssClass="btn-alt ms-2"
                    Visible="false" OnClick="btnDeletePost_Click" />

                <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="~/Forms/Forums/Home.aspx" CssClass="btn-alt ms-2">
                    Back
                </asp:HyperLink>
            </div>

            <div class="section-card">
                <h4 class="mb-3">Comments</h4>

                <asp:Panel ID="pnlNoComments" runat="server" Visible="false">
                    <p class="empty-text">No comments yet.</p>
                </asp:Panel>

                <asp:Repeater ID="rptComments" runat="server" OnItemCommand="rptComments_ItemCommand">
                    <ItemTemplate>
                        <div class="comment-card">
                            <div class="comment-user"><%# Eval("Username") %></div>

                            <div class="comment-text"><%# Eval("CommentText") %></div>

                            <div class="comment-footer">
                                <div class="comment-date">
                                    <%# Eval("DateCommented", "{0:dd/MM/yyyy hh:mm tt}") %>
                                </div>

                                <div class="d-flex gap-2">
                                    <asp:HyperLink ID="hlReportComment" runat="server"
                                        NavigateUrl='<%# "~/Forms/Forums/ReportItem.aspx?Type=Comment&CommentID=" + Eval("CommentID") %>'
                                        CssClass="btn-alt btn-danger-soft"
                                        Visible='<%# Session["Role"] == null || Session["Role"].ToString() != "Administrator" %>'>
                                        Report Comment
                                    </asp:HyperLink>

                                    <asp:Button ID="btnDeleteComment" runat="server"
                                        Text="Delete Comment"
                                        CssClass="btn-alt"
                                        CommandName="DeleteComment"
                                        CommandArgument='<%# Eval("CommentID") %>'
                                        Visible='<%# Session["Role"] != null && Session["Role"].ToString() == "Administrator" %>' />
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div class="section-card">
                <h5 class="mb-3">Add Comment</h5>

                <asp:TextBox ID="txtComment" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvComment" runat="server"
                    ControlToValidate="txtComment"
                    ErrorMessage="Comment is required."
                    ForeColor="Red"
                    Display="Dynamic" />

                <asp:Button ID="btnComment" runat="server" Text="Submit Comment" CssClass="btn-main mt-3" OnClick="btnComment_Click" />

                <div class="mt-2">
                    <asp:Label ID="lblMessage" runat="server" Font-Bold="true"></asp:Label>
                </div>
            </div>
        </div>
    </form>
</body>
</html>