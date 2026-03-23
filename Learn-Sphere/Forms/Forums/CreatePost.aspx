<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreatePost.aspx.cs" Inherits="Learn_Sphere.Forms.Forums.CreatePost" UnobtrusiveValidationMode="None" %>
<%@ Register Src="~/Shared/GlobalHeader.ascx" TagPrefix="uc" TagName="GlobalHeader" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create Post — LearnSphere</title>
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
        .form-card {
            background: var(--card);
            border-radius: 18px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            padding: 28px;
            max-width: 900px;
            margin: 0 auto;
        }
        .form-label {
            font-weight: 700;
            margin-bottom: 8px;
        }
        .form-control {
            border-radius: 12px;
            border: 1px solid var(--border);
            padding: 12px 14px;
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
        .btn-main:hover { opacity: 0.92; color: #fff; }
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:GlobalHeader ID="GlobalHeader1" runat="server" />

        <div class="page-hero">
            <div class="container">
                <h1 class="page-title">Create Post</h1>
                <p class="page-subtitle">Start a new discussion and share your thoughts with the community.</p>
            </div>
        </div>

        <div class="container page-main">
            <div class="form-card">
                <div class="mb-3">
                    <label class="form-label">Title</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server"
                        ControlToValidate="txtTitle"
                        ErrorMessage="Title is required."
                        ForeColor="Red"
                        Display="Dynamic" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Content</label>
                    <asp:TextBox ID="txtContent" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="8"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvContent" runat="server"
                        ControlToValidate="txtContent"
                        ErrorMessage="Content is required."
                        ForeColor="Red"
                        Display="Dynamic" />
                </div>

                <asp:Button ID="btnPost" runat="server" Text="Post" CssClass="btn-main" OnClick="btnPost_Click" />
                <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="~/Forms/Forums/Home.aspx" CssClass="btn-alt ms-2">Back</asp:HyperLink>

                <div class="mt-3">
                    <asp:Label ID="lblMessage" runat="server" Font-Bold="true"></asp:Label>
                </div>
            </div>
        </div>
    </form>
</body>
</html>