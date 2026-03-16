<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Learn_Sphere.Forms.Auth.Register" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Register - LearnSphere</title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .register-card {
            background-color: #fff;
            border-radius: 1rem;
            padding: 40px 30px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
            transition: transform 0.3s ease;
            text-align: center;
        }

        .register-card:hover {
            transform: translateY(-5px);
        }

        .register-card img.logo {
            max-width: 150px;
            margin-bottom: 20px;
        }

        .register-card h2 {
            margin-bottom: 30px;
            color: #198754;
            font-weight: 600;
        }

        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label,
        .form-floating > .form-select:focus ~ label,
        .form-floating > .form-select:not(:placeholder-shown) ~ label {
            font-size: 0.85rem;
            transform: translateY(-1.5rem) scale(0.9);
            opacity: 1;
        }

        .btn-success {
            background: linear-gradient(to right, #28a745, #198754);
            border: none;
        }

        .btn-success:hover {
            background: linear-gradient(to right, #218838, #157347);
        }

        .register-footer {
            margin-top: 20px;
        }

        .register-footer a {
            text-decoration: none;
            color: #764ba2;
            font-weight: 500;
        }

        .register-footer a:hover {
            text-decoration: underline;
        }

        .alert-msg {
            margin-top: 15px;
            font-weight: 500;
        }
    </style>
</head>
<body>
<form runat="server">
    <div class="register-card">

        <!-- Logo Integration -->
        <asp:Image ID="imgLogo" runat="server" CssClass="logo" ImageUrl="~/Images/logo.png" AlternateText="LearnSphere Logo" />

        <h2>Register</h2>

        <div class="form-floating mb-3">
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email"></asp:TextBox>
            <label for="txtEmail">Email</label>
        </div>

        <div class="form-floating mb-3">
            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Username"></asp:TextBox>
            <label for="txtUsername">Username</label>
        </div>

        <div class="form-floating mb-3">
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Password"></asp:TextBox>
            <label for="txtPassword">Password</label>
        </div>

        <div class="form-floating mb-3">
            <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select">
                <asp:ListItem Text="Learner" Value="Learner" />
                <asp:ListItem Text="Educator" Value="Educator" />
            </asp:DropDownList>
            <label for="ddlRole">Role</label>
        </div>

        <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-success w-100 btn-lg" OnClick="btnRegister_Click" />

        <asp:Label ID="lblMessage" runat="server" ForeColor="red" CssClass="alert-msg d-block"></asp:Label>

        <div class="register-footer mt-3">
            <span>Already have an account? </span><a href="Login.aspx">Login</a>
        </div>
    </div>
</form>
</body>
</html>