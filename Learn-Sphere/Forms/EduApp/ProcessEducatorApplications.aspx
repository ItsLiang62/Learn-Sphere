<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProcessEducatorApplications.aspx.cs" Inherits="Learn_Sphere.Forms.EduApp.ProcessEducatorApplications" %>
<%@ Register TagPrefix="uc" TagName="GlobalHeader" Src="~/Shared/GlobalHeader.ascx" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Educator Applications - LearnSphere</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea, #764ba2);
            min-height: 100vh;
        }

        .page-container {
            padding-top: 40px;
            padding-bottom: 60px;
        }

        .content-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            padding: 25px;
        }

        .title {
            font-size: 1.4rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead th {
            background-color: #4b4bff;
            color: white;
            font-weight: 600;
            padding: 12px;
            text-align: center;
        }

        tbody td {
            padding: 10px;
            border-bottom: 1px solid #e6e6e6;
            text-align: center;
        }

        tbody tr:hover {
            background-color: #f2f5ff;
            transition: 0.2s;
        }

        .btn-approve {
            background-color: #28a745 !important;
            color: white !important;
            border: none !important;
            font-weight: 600;
        }

        .btn-approve:hover {
            background-color: #218838 !important;
        }

        .btn-reject {
            background-color: #dc3545 !important;
            color: white !important;
            border: none !important;
            font-weight: 600;
        }

        .btn-reject:hover {
            background-color: #c82333 !important;
        }

        .message-label {
            font-weight: 500;
            margin-bottom: 15px;
            display: block;
        }
    </style>

</head>

<body>

<form id="form1" runat="server">

    <uc:GlobalHeader ID="GlobalHeader1" runat="server" />

    <div class="container page-container">

        <div class="content-card">

            <div class="title">
                Pending Educator Applications
            </div>

            <asp:Label ID="lblMessage" runat="server" CssClass="message-label"></asp:Label>

            <asp:GridView 
                ID="gvApplications" 
                runat="server" 
                AutoGenerateColumns="False"
                CssClass="table"
                OnRowCommand="gvApplications_RowCommand">

                <Columns>
                    <asp:BoundField DataField="Username" HeaderText="Username" />
                    <asp:BoundField DataField="Email" HeaderText="Email" />
                    <asp:BoundField DataField="Qualification" HeaderText="Qualification" />
                    <asp:HyperLinkField 
                        DataNavigateUrlFields="PortfolioLink"
                        DataTextField="PortfolioLink"
                        HeaderText="Portfolio"
                        Target="_blank" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button 
                                ID="btnApprove"
                                runat="server"
                                Text="Approve"
                                CommandName="Approve"
                                CommandArgument='<%# Eval("ApplicationID") %>'
                                CssClass="btn btn-approve btn-sm" />
                            <asp:Button 
                                ID="btnReject"
                                runat="server"
                                Text="Reject"
                                CommandName="Reject"
                                CommandArgument='<%# Eval("ApplicationID") %>'
                                CssClass="btn btn-reject btn-sm" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

        </div>

    </div>

</form>

</body>
</html>