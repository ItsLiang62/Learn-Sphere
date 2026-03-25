<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RecycleBin.aspx.cs" Inherits="Learn_Sphere.Forms.Resources.RecycleBin" %>
<%@ Register TagPrefix="uc" TagName="GlobalHeader" Src="~/Shared/GlobalHeader.ascx" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Recycle Bin - LearnSphere</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
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
            font-size: 3.8rem;
            font-weight: 800;
            line-height: 1.03;
            margin-bottom: 14px;
            letter-spacing: -1px;
        }

        .hero-title .accent {
            color: #ffb347;
        }

        .hero-subtitle {
            color: rgba(255,255,255,0.75);
            font-size: 1.08rem;
            max-width: 760px;
        }

        .content-wrap {
            max-width: 1200px;
            margin: 0 auto;
            padding: 34px 32px 60px 32px;
        }

        .message-label {
            font-weight: 700;
            margin-bottom: 18px;
            display: block;
        }

        .bin-card {
            background: #ffffff;
            border: 1px solid #eee6fb;
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 8px 20px rgba(71, 19, 121, 0.06);
            margin-bottom: 22px;
            transition: all 0.22s ease;
        }

        .bin-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 14px 28px rgba(71, 19, 121, 0.10);
        }

        .resource-title {
            font-size: 1.4rem;
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

        .btn-restore {
            background: #e9fff0;
            color: #1b7f3c !important;
            border: 1px solid #bfe9cc;
        }

        .btn-back {
            background: #f1ebfb;
            color: #5e4f80 !important;
            border: 1px solid #ddccff;
        }

        .empty-box {
            background: #ffffff;
            border: 1px solid #eee6fb;
            border-radius: 24px;
            padding: 26px;
            color: #7c7195;
            box-shadow: 0 6px 18px rgba(56, 22, 87, 0.05);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:GlobalHeader ID="GlobalHeader1" runat="server" />

        <section class="hero-section">
            <div class="hero-content">
                <div class="hero-title">
                    Recycle<br /><span class="accent">Bin</span>
                </div>
                <div class="hero-subtitle">
                    Restore deleted learning resources in case an admin removed the wrong item by mistake.
                </div>
            </div>
        </section>

        <div class="content-wrap">
            <asp:Label ID="lblMessage" runat="server" CssClass="message-label"></asp:Label>

            <asp:HyperLink ID="hlBackToResources" runat="server"
                NavigateUrl="~/Forms/Resources/Home.aspx"
                CssClass="action-btn btn-back">
                Back to Resources
            </asp:HyperLink>

            <asp:Repeater ID="rptDeletedResources" runat="server" OnItemCommand="rptDeletedResources_ItemCommand">
                <ItemTemplate>
                    <div class="bin-card">
                        <div class="resource-title"><%# Eval("Title") %></div>

                        <div class="resource-desc">
                            <%# Eval("Description") %>
                        </div>

                        <div class="resource-meta">
                            By <%# Eval("Username") %> |
                            Category: <%# Eval("CategoryName") %> |
                            Deleted: <%# Eval("DeletedDate", "{0:dd MMM yyyy hh:mm tt}") %>
                        </div>

                        <asp:LinkButton ID="btnRestore" runat="server"
                            CommandName="Restore"
                            CommandArgument='<%# Eval("ResourceID") %>'
                            CssClass="action-btn btn-restore">
                            Restore
                        </asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoDeletedResources" runat="server" CssClass="empty-box" Visible="false">
                Recycle bin is empty.
            </asp:Panel>
        </div>
    </form>
</body>
</html>