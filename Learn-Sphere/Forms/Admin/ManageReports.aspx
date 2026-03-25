<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageReports.aspx.cs" Inherits="Learn_Sphere.Forms.Admin.ManageReports" %>
<%@ Register Src="~/Shared/GlobalHeader.ascx" TagPrefix="uc" TagName="GlobalHeader" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Reports — LearnSphere</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&display=swap" rel="stylesheet" />

    <style>
        :root {
            --ink: #0d0d1a; --surface: #f4f3ff; --card: #ffffff;
            --accent: #5b4fff; --muted: #7b7a99;
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
        .table-card {
            background: #fff;
            border-radius: 18px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            padding: 24px;
        }
        .action-btn {
            border-radius: 10px;
            padding: 6px 12px;
            font-size: 0.85rem;
            font-weight: 700;
            border: 1px solid #ddd;
            background: #fff;
        }
        .badge-type {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 700;
        }
        .type-post {
            background: #eef2ff;
            color: #4f46e5;
        }
        .type-comment {
            background: #fff7ed;
            color: #c2410c;
        }
        .type-resource {
            background: #f3e8ff;
            color: #7e22ce;
        }
        .small-text {
            font-size: 0.85rem;
            color: var(--muted);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:GlobalHeader ID="GlobalHeader1" runat="server" />

        <div class="page-hero">
            <div class="container">
                <h1 class="page-title">Manage Reports</h1>
                <p class="page-subtitle">Review and remove reported forum content and learning resources.</p>
            </div>
        </div>

        <div class="container page-main">
            <div class="table-card">
                <asp:Label ID="lblMessage" runat="server" Font-Bold="true"></asp:Label>

                <asp:GridView ID="gvReports" runat="server"
                    CssClass="table table-bordered table-striped mt-3"
                    AutoGenerateColumns="false"
                    OnRowCommand="gvReports_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="UnifiedReportID" HeaderText="Report ID" />
                        <asp:BoundField DataField="ReporterName" HeaderText="Reporter" />

                        <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <span class='badge-type <%# GetTypeCss(Eval("ReportType").ToString()) %>'>
                                    <%# Eval("ReportType") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Reason" HeaderText="Reason" />
                        <asp:BoundField DataField="Explanation" HeaderText="Explanation" />

                        <asp:TemplateField HeaderText="Reported Item">
                            <ItemTemplate>
                                <span><%# Eval("ReportedItemTitle") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="DateCreated" HeaderText="Date" DataFormatString="{0:dd/MM/yyyy hh:mm tt}" />
                        <asp:BoundField DataField="ReportStatus" HeaderText="Status" />

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:Button ID="btnReviewed" runat="server"
                                    Text="Reviewed"
                                    CommandName="MarkReviewed"
                                    CommandArgument='<%# Eval("CommandArgumentValue") %>'
                                    CssClass="action-btn me-1" />

                                <asp:Button ID="btnDelete" runat="server"
                                    Text="Delete Item"
                                    CommandName="DeleteItem"
                                    CommandArgument='<%# Eval("CommandArgumentValue") %>'
                                    CssClass="action-btn" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>