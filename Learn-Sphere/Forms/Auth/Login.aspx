<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Learn_Sphere.Forms.Auth.Login" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Login - LearnSphere</title>
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

        .login-card {
            background-color: #fff;
            border-radius: 1rem;
            padding: 40px 30px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
            transition: transform 0.3s ease;
            text-align: center;
        }

        .login-card:hover {
            transform: translateY(-5px);
        }

        .login-card img.logo {
            max-width: 150px;
            margin-bottom: 20px;
        }

        .login-card h2 {
            margin-bottom: 30px;
            color: #4b4bff;
            font-weight: 600;
        }

        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label {
            font-size: 0.85rem;
            transform: translateY(-1.5rem) scale(0.9);
            opacity: 1;
        }

        .btn-primary {
            background: linear-gradient(to right, #667eea, #764ba2);
            border: none;
        }

        .btn-primary:hover {
            background: linear-gradient(to right, #5566e0, #603c97);
        }

        .login-footer {
            margin-top: 20px;
        }

        .login-footer a {
            text-decoration: none;
            color: #764ba2;
            font-weight: 500;
        }

        .login-footer a:hover {
            text-decoration: underline;
        }

        .alert-msg {
            margin-top: 15px;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-card">

            <!-- Logo Integration -->
            <asp:Image ID="imgLogo" runat="server" CssClass="logo" ImageUrl="~/Images/logo.png" AlternateText="LearnSphere Logo" />

            <h2>Login</h2>

            <div class="form-floating mb-3">
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email"></asp:TextBox>
                <label for="txtEmail">Email</label>
            </div>

            <div class="form-floating mb-3">
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Password"></asp:TextBox>
                <label for="txtPassword">Password</label>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary w-100 btn-lg" OnClick="btnLogin_Click" />

            <asp:Label ID="lblMessage" runat="server" ForeColor="red" CssClass="alert-msg d-block"></asp:Label>

            <div class="login-footer mt-3">
                <span>Don't have an account? </span><a href="Register.aspx">Register</a>
            </div>
        </div>
    </form>
</body>
</html>