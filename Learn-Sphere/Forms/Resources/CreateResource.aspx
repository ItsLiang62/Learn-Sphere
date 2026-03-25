<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateResource.aspx.cs" Inherits="Learn_Sphere.Forms.Resources.CreateResource" UnobtrusiveValidationMode="None" %>
<%@ Register Src="~/Shared/GlobalHeader.ascx" TagPrefix="uc" TagName="GlobalHeader" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create Resource - LearnSphere</title>
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
            line-height: 1.03;
            margin-bottom: 12px;
            letter-spacing: -1px;
        }

        .hero-title .accent {
            color: #a100ff;
        }

        .hero-subtitle {
            color: rgba(255,255,255,0.78);
            font-size: 1.1rem;
        }

        .page-wrap {
            max-width: 1100px;
            margin: 0 auto;
            padding: 36px 32px 60px 32px;
        }

        .form-card {
            background: #ffffff;
            border: 1px solid #eadbff;
            border-radius: 28px;
            padding: 32px;
            box-shadow: 0 10px 30px rgba(71, 19, 121, 0.06);
        }

        .section-title {
            font-size: 1.95rem;
            font-weight: 800;
            color: #30195c;
            margin-bottom: 24px;
        }

        .form-label-custom {
            font-weight: 700;
            color: #5a3e8a;
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border-radius: 16px;
            border: 1px solid #ddccff;
            min-height: 52px;
            padding: 12px 16px;
            box-shadow: none !important;
        }

        textarea.form-control {
            min-height: 170px;
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

        .submit-btn:hover {
            opacity: 0.95;
        }

        .back-btn {
            display: inline-block;
            background: #f1ebfb;
            color: #5e4f80 !important;
            text-decoration: none;
            border-radius: 16px;
            padding: 14px 24px;
            font-weight: 700;
            margin-left: 12px;
        }

        .message-label {
            font-weight: 700;
            margin-bottom: 16px;
            display: block;
        }

        .validator {
            color: #d93025;
            font-size: 0.92rem;
            display: block;
            margin-top: 6px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:GlobalHeader ID="GlobalHeader1" runat="server" />

        <section class="hero-section">
            <div class="hero-content">
                <div class="hero-title">
                    Create<br /><span class="accent">Resource</span>
                </div>
                <div class="hero-subtitle">
                    Share useful learning materials with learners and educators.
                </div>
            </div>
        </section>

        <div class="page-wrap">
            <div class="form-card">
                <div class="section-title">New Learning Resource</div>

                <asp:Label ID="lblMessage" runat="server" CssClass="message-label"></asp:Label>

                <div class="mb-4">
                    <label class="form-label-custom">Title</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server"
                        ControlToValidate="txtTitle"
                        ErrorMessage="Title is required."
                        CssClass="validator"
                        Display="Dynamic" />
                </div>

                <div class="mb-4">
                    <label class="form-label-custom">Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDescription" runat="server"
                        ControlToValidate="txtDescription"
                        ErrorMessage="Description is required."
                        CssClass="validator"
                        Display="Dynamic" />
                </div>

                <div class="mb-4">
                    <label class="form-label-custom">Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvCategory" runat="server"
                        ControlToValidate="ddlCategory"
                        InitialValue="0"
                        ErrorMessage="Please select a category."
                        CssClass="validator"
                        Display="Dynamic" />
                </div>

                <div class="mb-4">
                    <label class="form-label-custom">Resource Link</label>
                    <asp:TextBox ID="txtResourceLink" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvLink" runat="server"
                        ControlToValidate="txtResourceLink"
                        ErrorMessage="Resource link is required."
                        CssClass="validator"
                        Display="Dynamic" />
                </div>

                <asp:Button ID="btnCreate" runat="server" Text="Create Resource"
                    CssClass="submit-btn" OnClick="btnCreate_Click" />

                <asp:HyperLink ID="hlBack" runat="server"
                    NavigateUrl="~/Forms/Resources/Home.aspx"
                    CssClass="back-btn">
                    Back
                </asp:HyperLink>
            </div>
        </div>
    </form>
</body>
</html>