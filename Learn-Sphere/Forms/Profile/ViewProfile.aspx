<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewProfile.aspx.cs" Inherits="Learn_Sphere.Forms.Profile.ViewProfile" %>
<%@ Register TagPrefix="uc" TagName="GlobalHeader" Src="~/Shared/GlobalHeader.ascx" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Profile — LearnSphere</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&display=swap" rel="stylesheet" />

    <style>
        :root {
            --ink: #0d0d1a; --surface: #f4f3ff; --card: #ffffff;
            --accent: #5b4fff; --accent2: #ff4f8b; --accent3: #00d4aa;
            --muted: #7b7a99; --border: #e4e2ff; --shadow: 0 4px 24px rgba(91,79,255,0.10);
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Roboto', sans-serif; background: var(--surface); color: var(--ink); min-height: 100vh; }

        .profile-hero {
            background: linear-gradient(135deg, #0d0d1a 0%, #1a1040 60%, #2d1260 100%);
            padding: 60px 0 80px; position: relative; overflow: hidden;
        }
        .profile-hero::before {
            content: ''; position: absolute; inset: 0;
            background: radial-gradient(ellipse at 20% 80%, rgba(91,79,255,0.3) 0%, transparent 60%),
                        radial-gradient(ellipse at 80% 20%, rgba(255,79,139,0.2) 0%, transparent 55%);
        }
        .hero-inner { position: relative; z-index: 1; }
        .avatar-wrap {
            width: 100px; height: 100px; border-radius: 50%;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            display: flex; align-items: center; justify-content: center;
            font-size: 2.4rem; font-weight: 900; color: #fff;
            border: 4px solid rgba(255,255,255,0.15); flex-shrink: 0;
        }
        .hero-user-info h2 { font-family: 'Roboto', sans-serif; font-size: 1.8rem; font-weight: 900; color: #fff; letter-spacing: -0.5px; }
        .role-badge { display: inline-block; font-size: 0.72rem; font-weight: 700; letter-spacing: 1.2px; text-transform: uppercase; padding: 3px 12px; border-radius: 50px; margin-top: 6px; }
        .role-badge.learner      { background: rgba(0,212,170,0.2); color: var(--accent3); border: 1px solid rgba(0,212,170,0.3); }
        .role-badge.educator     { background: rgba(91,79,255,0.2);  color: #a89bff;        border: 1px solid rgba(91,79,255,0.3); }
        .role-badge.administrator{ background: rgba(255,79,139,0.2); color: #ff8ab3;        border: 1px solid rgba(255,79,139,0.3); }
        .hero-user-info p.bio { color: rgba(255,255,255,0.5); font-size: 0.9rem; margin-top: 8px; max-width: 500px; font-weight: 300; }

        .btn-back-msg {
            font-family: 'Roboto', sans-serif; font-size: 0.85rem; font-weight: 700;
            background: rgba(255,255,255,0.08); border: 1.5px solid rgba(255,255,255,0.15);
            color: rgba(255,255,255,0.7); border-radius: 10px; padding: 9px 20px;
            cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; gap: 7px; text-decoration: none;
        }
        .btn-back-msg:hover { background: rgba(91,79,255,0.25); border-color: var(--accent); color: #fff; }

        .btn-message-user {
            font-family: 'Roboto', sans-serif; font-size: 0.85rem; font-weight: 700;
            background: linear-gradient(135deg, var(--accent), #7c6fff); color: #fff;
            border: none; border-radius: 10px; padding: 9px 22px;
            cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; gap: 7px; text-decoration: none;
        }
        .btn-message-user:hover { opacity: 0.88; color: #fff; }

        .profile-main { padding: 40px 0 80px; }
        .p-card { background: var(--card); border-radius: 18px; border: 1px solid var(--border); box-shadow: var(--shadow); overflow: hidden; margin-bottom: 20px; animation: fadeUp 0.35s ease both; }
        .p-card-header { padding: 18px 24px; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 10px; }
        .p-card-header h5 { font-family: 'Roboto', sans-serif; font-size: 0.95rem; font-weight: 700; margin: 0; }
        .p-card-header i { color: var(--accent); }
        .p-card-body { padding: 24px; }

        .info-row { display: flex; gap: 8px; margin-bottom: 14px; align-items: flex-start; }
        .info-row i { color: var(--accent); width: 18px; margin-top: 2px; flex-shrink: 0; }
        .info-row .info-label { font-size: 0.78rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: var(--muted); }
        .info-row .info-value { font-size: 0.9rem; color: var(--ink); margin-top: 2px; }

        .mini-stats { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .mini-stat { background: var(--surface); border-radius: 12px; border: 1px solid var(--border); padding: 14px; text-align: center; }
        .mini-stat .ms-val { font-family: 'Roboto', sans-serif; font-size: 1.6rem; font-weight: 900; color: var(--ink); letter-spacing: -0.5px; }
        .mini-stat .ms-label { font-size: 0.72rem; color: var(--muted); font-weight: 500; margin-top: 2px; }

        @keyframes fadeUp { from { opacity:0; transform:translateY(16px); } to { opacity:1; transform:translateY(0); } }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:GlobalHeader ID="GlobalHeader1" runat="server" />

        <div class="profile-hero">
            <div class="container hero-inner">
                <div class="d-flex align-items-center gap-4 flex-wrap">
                    <div class="avatar-wrap">
                        <asp:Label ID="lblAvatar" runat="server" Text="?"></asp:Label>
                    </div>
                    <div class="hero-user-info flex-grow-1">
                        <h2><asp:Label ID="lblDisplayName" runat="server" Text="User"></asp:Label></h2>
                        <asp:Label ID="lblRoleBadge" runat="server" CssClass="role-badge"></asp:Label>
                        <p class="bio"><asp:Label ID="lblBio" runat="server" Text="No bio yet."></asp:Label></p>
                    </div>
                    <div class="d-flex gap-2 flex-wrap">
                        <a href="/Forms/Messaging/Messages.aspx" class="btn-back-msg">
                            <i class="fa-solid fa-arrow-left"></i> Back to Messages
                        </a>
                        <asp:HyperLink ID="lnkMessage" runat="server" CssClass="btn-message-user">
                            <i class="fa-solid fa-envelope"></i> Send Message
                        </asp:HyperLink>
                    </div>
                </div>
            </div>
        </div>

        <div class="container profile-main">
            <div class="row g-4">
                <div class="col-md-5">
                    <div class="p-card">
                        <div class="p-card-header">
                            <i class="fa-solid fa-circle-info"></i>
                            <h5>About</h5>
                        </div>
                        <div class="p-card-body">
                            <div class="info-row">
                                <i class="fa-regular fa-user"></i>
                                <div>
                                    <div class="info-label">Username</div>
                                    <div class="info-value"><asp:Label ID="lblUsername" runat="server" Text="—"></asp:Label></div>
                                </div>
                            </div>
                            <div class="info-row">
                                <i class="fa-solid fa-graduation-cap"></i>
                                <div>
                                    <div class="info-label">Role</div>
                                    <div class="info-value"><asp:Label ID="lblRole" runat="server" Text="—"></asp:Label></div>
                                </div>
                            </div>
                            <div class="info-row">
                                <i class="fa-regular fa-calendar"></i>
                                <div>
                                    <div class="info-label">Member Since</div>
                                    <div class="info-value"><asp:Label ID="lblMemberSince" runat="server" Text="—"></asp:Label></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-7">
                    <div class="p-card">
                        <div class="p-card-header">
                            <i class="fa-solid fa-chart-simple"></i>
                            <h5>Activity</h5>
                        </div>
                        <div class="p-card-body">
                            <div class="mini-stats">
                                <div class="mini-stat">
                                    <div class="ms-val"><asp:Label ID="lblStat1Val" runat="server" Text="0"></asp:Label></div>
                                    <div class="ms-label"><asp:Label ID="lblStat1Label" runat="server" Text="Quiz Attempts"></asp:Label></div>
                                </div>
                                <div class="mini-stat">
                                    <div class="ms-val"><asp:Label ID="lblStat2Val" runat="server" Text="0"></asp:Label></div>
                                    <div class="ms-label"><asp:Label ID="lblStat2Label" runat="server" Text="Unique Quizzes"></asp:Label></div>
                                </div>
                                <div class="mini-stat">
                                    <div class="ms-val"><asp:Label ID="lblStat3Val" runat="server" Text="—"></asp:Label></div>
                                    <div class="ms-label">Avg. Score</div>
                                </div>
                                <div class="mini-stat">
                                    <div class="ms-val"><asp:Label ID="lblStat4Val" runat="server" Text="—"></asp:Label></div>
                                    <div class="ms-label"><asp:Label ID="lblStat4Label" runat="server" Text="Best Score"></asp:Label></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
