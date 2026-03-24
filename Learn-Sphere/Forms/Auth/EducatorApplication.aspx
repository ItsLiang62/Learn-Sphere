<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EducatorApplication.aspx.cs" Inherits="Learn_Sphere.Forms.Auth.EducatorApplication" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Educator Application - LearnSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding-top: 50px;
        }

        .application-card {
            background-color: #fff;
            border-radius: 1rem;
            padding: 40px 30px;
            width: 100%;
            max-width: 600px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
            text-align: center;
            min-height: 400px; /* default for small forms */
            height: auto;      /* expand with content */
        }

        .application-card img.logo { max-width: 150px; margin-bottom: 20px; }
        .application-card h2 { margin-bottom: 25px; color: #0dcaf0; font-weight: 600; }

        /* Input styles */
        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label {
            font-size: 0.85rem;
            transform: translateY(-1.5rem) scale(0.9);
            opacity: 1;
        }

        /* Button with new gradient */
        .btn-submit {
            background: linear-gradient(to right, #ff7e5f, #feb47b);
            border: none;
            font-weight: 600;
        }
        .btn-submit:hover {
            background: linear-gradient(to right, #feb47b, #ff7e5f);
        }

        /* Back to registration link same style as login */
        .back-link {
            display: inline-block;
            margin-top: 15px;
            color: #764ba2;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
        }
        .back-link:hover { text-decoration: underline; }

        .status-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .status-table th {
            background-color: #4b4bff;
            color: white;
            padding: 10px;
        }
        .status-table td {
            border-bottom: 1px solid #e6e6e6;
            padding: 8px;
            text-align: center;
        }
        .status-pending { color: #ffc107; font-weight: 600; }
        .status-approved { color: #28a745; font-weight: 600; }
        .status-rejected { color: #dc3545; font-weight: 600; }

        .alert-msg { margin-top: 15px; font-weight: 500; }
    </style>
</head>
<body>
    <form runat="server">
        <div class="application-card">

            <asp:Image ID="imgLogo" runat="server" CssClass="logo" ImageUrl="~/Images/logo.png" AlternateText="LearnSphere Logo" />

            <h2>Educator Verification</h2>

            <div class="form-floating mb-3">
                <asp:TextBox ID="txtQualification" runat="server" CssClass="form-control" placeholder="Qualification"></asp:TextBox>
                <label for="txtQualification">Qualification</label>
            </div>

            <div class="form-floating mb-3">
                <asp:TextBox ID="txtPortfolio" runat="server" CssClass="form-control" placeholder="Portfolio Link"></asp:TextBox>
                <label for="txtPortfolio">Portfolio Link</label>
            </div>

            <asp:Button ID="btnSubmit" runat="server" Text="Submit Application" CssClass="btn btn-submit w-100 btn-lg" OnClick="btnSubmit_Click" />

            <asp:LinkButton ID="lnkBack" runat="server" CssClass="back-link" OnClick="lnkBack_Click">
                Back to Registration
            </asp:LinkButton>

            <h5 style="margin-top: 25px;">My Previous Applications</h5>

            <asp:GridView 
                ID="gvApplications" 
                runat="server" 
                AutoGenerateColumns="False" 
                CssClass="status-table" 
                Visible="false">
                <Columns>
                    <asp:BoundField DataField="Qualification" HeaderText="Qualification" />
                    <asp:BoundField DataField="VerificationStatus" HeaderText="Status" />
                    <asp:BoundField 
                        DataField="DateSubmitted" 
                        HeaderText="Submitted On" 
                        DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                </Columns>
            </asp:GridView>

            <asp:Label ID="lblMessage" runat="server" CssClass="alert-msg d-block"></asp:Label>

        </div>
    </form>
</body>
</html>