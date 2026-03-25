<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ResourceDetails.aspx.cs" Inherits="Learn_Sphere.Forms.Resources.ResourceDetails" UnobtrusiveValidationMode="None" %>
<%@ Register Src="~/Shared/GlobalHeader.ascx" TagPrefix="uc" TagName="GlobalHeader" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Resource Details - LearnSphere</title>
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
            max-width: 1100px;
            margin: 0 auto;
            padding: 0 32px;
        }

        .hero-title {
            font-size: 3.7rem;
            font-weight: 800;
            line-height: 1.05;
            margin-bottom: 12px;
            letter-spacing: -1px;
        }

        .hero-title .accent {
            color: #a100ff;
        }

        .hero-subtitle {
            color: rgba(255,255,255,0.76);
            font-size: 1.08rem;
            max-width: 780px;
        }

        .page-wrap {
            max-width: 1100px;
            margin: 0 auto;
            padding: 36px 32px 60px 32px;
        }

        .detail-card {
            background: #ffffff;
            border: 1px solid #eadbff;
            border-radius: 28px;
            padding: 32px;
            box-shadow: 0 10px 30px rgba(71, 19, 121, 0.06);
            margin-bottom: 24px;
        }

        .resource-main-title {
            font-size: 2rem;
            font-weight: 800;
            color: #30195c;
            margin-bottom: 14px;
            line-height: 1.3;
        }

        .meta {
            color: #8b80a3;
            font-size: 0.98rem;
            margin-bottom: 20px;
        }

        .description-box {
            color: #5f5677;
            line-height: 1.8;
            font-size: 1rem;
            margin-bottom: 20px;
        }

        .link-box {
            background: #f7f1ff;
            border: 1px solid #e6d4ff;
            border-radius: 18px;
            padding: 18px;
            margin-bottom: 20px;
        }

        .link-box a {
            color: #7c27ff;
            font-weight: 700;
            text-decoration: none;
            word-break: break-all;
        }

        .stats-box {
            background: linear-gradient(135deg, #f3e8ff, #ffffff);
            border: 1px solid #dfc2ff;
            border-radius: 18px;
            padding: 18px;
            margin-bottom: 24px;
            font-weight: 700;
            color: #4b2a7d;
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

        .btn-report {
            background: #f31200;
            color: white !important;
        }

        .btn-delete {
            background: #2f2f2f;
            color: white !important;
        }

        .btn-back {
            background: #f1ebfb;
            color: #5e4f80 !important;
        }

        .rating-card {
            background: #ffffff;
            border: 1px solid #eadbff;
            border-radius: 28px;
            padding: 28px 32px;
            box-shadow: 0 10px 30px rgba(71, 19, 121, 0.06);
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 800;
            color: #30195c;
            margin-bottom: 18px;
        }

        .form-label-custom {
            font-weight: 700;
            color: #5a3e8a;
            margin-bottom: 8px;
        }

        .form-select {
            border-radius: 16px;
            min-height: 52px;
            border: 1px solid #ddccff;
            box-shadow: none !important;
        }

        .submit-btn {
            background: linear-gradient(135deg, #8a00ff, #b14cff);
            color: white;
            border: none;
            border-radius: 16px;
            padding: 14px 24px;
            font-weight: 700;
            box-shadow: 0 8px 20px rgba(138,0,255,0.28);
        }

        .message-label {
            font-weight: 700;
            margin-bottom: 16px;
            display: block;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:GlobalHeader ID="GlobalHeader1" runat="server" />

        <section class="hero-section">
            <div class="hero-content">
                <div class="hero-title">
                    Resource<br /><span class="accent">Details</span>
                </div>
                <div class="hero-subtitle">
                    View the full learning resource, manage bookmarks, submit ratings, and report content when necessary.
                </div>
            </div>
        </section>

        <div class="page-wrap">
            <asp:Label ID="lblMessage" runat="server" CssClass="message-label"></asp:Label>

            <div class="detail-card">
                <div class="resource-main-title">
                    <asp:Label ID="lblTitle" runat="server"></asp:Label>
                </div>

                <div class="meta">
                    By <asp:Label ID="lblUsername" runat="server"></asp:Label> |
                    <asp:Label ID="lblDatePosted" runat="server"></asp:Label> |
                    Category: <asp:Label ID="lblCategory" runat="server"></asp:Label>
                </div>

                <div class="description-box">
                    <asp:Label ID="lblDescription" runat="server"></asp:Label>
                </div>

                <div class="link-box">
                    <strong>Resource Link:</strong><br />
                    <asp:HyperLink ID="hlResourceLink" runat="server" Target="_blank"></asp:HyperLink>
                </div>

                <div class="stats-box">
                    ⭐ Average Rating:
                    <asp:Label ID="lblAverageRating" runat="server"></asp:Label>
                    &nbsp;&nbsp;|&nbsp;&nbsp;
                    Total Ratings:
                    <asp:Label ID="lblRatingCount" runat="server"></asp:Label>
                </div>

                <asp:Button ID="btnBookmark" runat="server" Text="Bookmark"
                    CssClass="action-btn btn-bookmark" OnClick="btnBookmark_Click" />

                <asp:HyperLink ID="hlReport" runat="server"
                    CssClass="action-btn btn-report">
                    Report
                </asp:HyperLink>

                <asp:Button ID="btnDelete" runat="server" Text="Delete Resource"
                    CssClass="action-btn btn-delete" Visible="false"
                    OnClick="btnDelete_Click"
                    OnClientClick="return confirm('Are you sure you want to delete this resource?');" />

                <asp:HyperLink ID="hlBack" runat="server"
                    NavigateUrl="~/Forms/Resources/Home.aspx"
                    CssClass="action-btn btn-back">
                    Back
                </asp:HyperLink>
            </div>

            <div class="rating-card">
                <div class="section-title">Rate This Resource</div>

                <div class="row align-items-end">
                    <div class="col-md-5 mb-3">
                        <label class="form-label-custom">Your Rating</label>
                        <asp:DropDownList ID="ddlRating" runat="server" CssClass="form-select">
                            <asp:ListItem Text="1 Star" Value="1"></asp:ListItem>
                            <asp:ListItem Text="2 Stars" Value="2"></asp:ListItem>
                            <asp:ListItem Text="3 Stars" Value="3"></asp:ListItem>
                            <asp:ListItem Text="4 Stars" Value="4"></asp:ListItem>
                            <asp:ListItem Text="5 Stars" Value="5"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4 mb-3">
                        <asp:Button ID="btnSubmitRating" runat="server" Text="Submit Rating"
                            CssClass="submit-btn" OnClick="btnSubmitRating_Click" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>