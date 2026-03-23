<<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="Learn_Sphere.Forms.Profile.Notifications" %>
<%@ Register Src="~/Shared/GlobalHeader.ascx" TagPrefix="uc" TagName="GlobalHeader" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Notifications — LearnSphere</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&display=swap" rel="stylesheet" />

    <style>
        :root {
            --ink: #0d0d1a; --surface: #f4f3ff; --card: #ffffff;
            --accent: #5b4fff; --accent2: #ff4f8b; --muted: #7b7a99;
            --border: #e4e2ff; --shadow: 0 4px 24px rgba(91,79,255,0.10);
        }
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
        .page-hero .container { position: relative; z-index: 1; }
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
        .page-main { padding: 36px 0 70px; }
        .notify-card {
            background: #fff;
            border-radius: 18px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            padding: 22px 24px;
            margin-bottom: 18px;
        }
        .badge-read {
            background: rgba(91,79,255,0.12);
            color: var(--accent);
            border: 1px solid rgba(91,79,255,0.22);
        }
        .badge-unread {
            background: rgba(255,79,139,0.12);
            color: var(--accent2);
            border: 1px solid rgba(255,79,139,0.22);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:GlobalHeader ID="GlobalHeader1" runat="server" />

        <div class="page-hero">
            <div class="container">
                <h1 class="page-title">Notifications</h1>
                <p class="page-subtitle">Stay updated with forum activity, messages, and admin actions.</p>
            </div>
        </div>

        <div class="container page-main">
            <asp:Repeater ID="rptNotifications" runat="server">
                <ItemTemplate>
                    <div class="notify-card">
                        <div class="fw-bold mb-2"><%# Eval("NotificationContent") %></div>
                        <div class="text-muted mb-2"><%# Eval("DateCreated", "{0:dd/MM/yyyy hh:mm tt}") %></div>
                        <span class='badge <%# Convert.ToBoolean(Eval("IsRead")) ? "badge-read" : "badge-unread" %>'>
                            <%# Convert.ToBoolean(Eval("IsRead")) ? "Read" : "Unread" %>
                        </span>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold"></asp:Label>
        </div>
    </form>
</body>
</html>