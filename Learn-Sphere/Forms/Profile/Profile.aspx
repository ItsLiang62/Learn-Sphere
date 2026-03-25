<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Learn_Sphere.Forms.Profile.Profile" %>
<%@ Register TagPrefix="uc" TagName="GlobalHeader" Src="~/Shared/GlobalHeader.ascx" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Profile — LearnSphere</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&display=swap" rel="stylesheet" />

    <style>
        :root {
            --ink: #0d0d1a; --surface: #f4f3ff; --card: #ffffff;
            --accent: #7b10ff; --accent2: #ff4f8b; --accent3: #00d4aa;
            --muted: #7b7a99; --border: #e4e2ff;
            --shadow: 0 4px 24px rgba(91,79,255,0.10);
        }

        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background: var(--surface);
            color: var(--ink);
            min-height: 100vh;
        }

        .profile-hero {
            background: linear-gradient(135deg, #0d0018 0%, #2a0148 58%, #520078 100%);
            padding: 60px 0 80px;
            position: relative;
            overflow: hidden;
        }

        .profile-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background:
                radial-gradient(ellipse at 20% 80%, rgba(123,16,255,0.24) 0%, transparent 60%),
                radial-gradient(ellipse at 80% 20%, rgba(255,79,139,0.18) 0%, transparent 55%);
        }

        .hero-inner {
            position: relative;
            z-index: 1;
        }

        .avatar-wrap {
            width: 104px;
            height: 104px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            font-weight: 900;
            color: #fff;
            border: 4px solid rgba(255,255,255,0.18);
            flex-shrink: 0;
        }

        .hero-user-info h2 {
            font-size: 1.95rem;
            font-weight: 900;
            color: #fff;
            letter-spacing: -0.5px;
            margin-bottom: 4px;
        }

        .role-badge {
            display: inline-block;
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 1.2px;
            text-transform: uppercase;
            padding: 4px 12px;
            border-radius: 50px;
            margin-top: 4px;
        }

        .role-badge.learner {
            background: rgba(0,212,170,0.2);
            color: var(--accent3);
            border: 1px solid rgba(0,212,170,0.3);
        }

        .role-badge.educator {
            background: rgba(91,79,255,0.2);
            color: #b9a8ff;
            border: 1px solid rgba(91,79,255,0.3);
        }

        .role-badge.administrator {
            background: rgba(255,79,139,0.2);
            color: #ff9ec0;
            border: 1px solid rgba(255,79,139,0.3);
        }

        .hero-user-info p.bio {
            color: rgba(255,255,255,0.58);
            font-size: 0.95rem;
            margin-top: 10px;
            max-width: 520px;
            font-weight: 300;
        }

        .btn-logout {
            font-family: 'Roboto', sans-serif;
            font-size: 0.85rem;
            font-weight: 700;
            background: rgba(255,255,255,0.08);
            border: 1.5px solid rgba(255,255,255,0.15);
            color: rgba(255,255,255,0.78);
            border-radius: 10px;
            padding: 9px 20px;
            cursor: pointer;
            transition: 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 7px;
        }

        .btn-logout:hover {
            background: rgba(255,79,139,0.2);
            border-color: var(--accent2);
            color: #fff;
        }

        .profile-main {
            padding: 34px 0 80px;
        }

        .profile-layout {
            display: grid;
            grid-template-columns: 340px 1fr;
            gap: 20px;
            align-items: start;
        }

        @media (max-width:900px) {
            .profile-layout {
                grid-template-columns: 1fr;
            }
        }

        .p-card {
            background: var(--card);
            border-radius: 18px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 18px;
            animation: fadeUp 0.35s ease both;
        }

        .p-card:nth-child(2){animation-delay:0.08s}
        .p-card:nth-child(3){animation-delay:0.14s}

        .p-card-header {
            padding: 18px 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .p-card-header h5 {
            font-size: 0.95rem;
            font-weight: 700;
            margin: 0;
        }

        .p-card-header i {
            color: var(--accent);
        }

        .p-card-body {
            padding: 24px;
        }

        .form-label {
            font-size: 0.78rem;
            font-weight: 700;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 6px;
            display: block;
        }

        .form-field {
            font-family: 'Roboto', sans-serif;
            font-size: 0.9rem;
            border: 1.5px solid var(--border);
            border-radius: 10px;
            padding: 10px 14px;
            width: 100%;
            color: var(--ink);
            background: var(--surface);
            transition: border-color 0.2s;
            margin-bottom: 16px;
        }

        .form-field:focus {
            outline: none;
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(91,79,255,0.1);
        }

        textarea.form-field {
            resize: vertical;
            min-height: 90px;
        }

        .form-field[readonly] {
            background: #eeedf8;
            color: var(--muted);
            cursor: not-allowed;
        }

        .btn-save-profile {
            font-family: 'Roboto', sans-serif;
            font-size: 0.88rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--accent), #a23fff);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 11px 28px;
            cursor: pointer;
            transition: 0.2s;
            width: 100%;
        }

        .btn-save-profile:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }

        .quick-link {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 0;
            border-bottom: 1px solid var(--border);
            text-decoration: none;
            color: var(--ink);
            cursor: pointer;
            transition: 0.18s;
            background: none;
            border-left: none;
            border-right: none;
            border-top: none;
            width: 100%;
            text-align: left;
            font-family: 'Roboto', sans-serif;
        }

        .quick-link:last-child {
            border-bottom: none;
        }

        .quick-link:hover {
            color: var(--accent);
        }

        .quick-link:hover .ql-icon {
            background: var(--accent);
            color: #fff;
        }

        .ql-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: var(--surface);
            border: 1.5px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            flex-shrink: 0;
            transition: 0.18s;
            color: var(--accent);
            position: relative;
        }

        .ql-text strong {
            font-weight: 700;
            font-size: 0.9rem;
            display: block;
        }

        .ql-text span {
            font-size: 0.78rem;
            color: var(--muted);
        }

        .ql-arrow {
            margin-left: auto;
            color: var(--muted);
            font-size: 0.75rem;
        }

        .unread-dot {
            position: absolute;
            top: -3px;
            right: -3px;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: var(--accent2);
            border: 2px solid var(--card);
            display: none;
        }

        .mini-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .mini-stat {
            background: var(--surface);
            border-radius: 12px;
            border: 1px solid var(--border);
            padding: 14px;
            text-align: center;
        }

        .mini-stat .ms-val {
            font-size: 1.6rem;
            font-weight: 900;
            color: var(--ink);
            letter-spacing: -0.5px;
        }

        .mini-stat .ms-label {
            font-size: 0.72rem;
            color: var(--muted);
            font-weight: 500;
            margin-top: 2px;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(8px) }
            to { opacity: 1; transform: none }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:GlobalHeader ID="GlobalHeader1" runat="server" />

        <asp:HiddenField ID="hfRole" runat="server" />
        <asp:HiddenField ID="hfHandlerUrl" runat="server" />

        <section class="profile-hero">
            <div class="container hero-inner">
                <div class="d-flex justify-content-between align-items-start flex-wrap gap-4">
                    <div class="d-flex align-items-center gap-4">
                        <div class="avatar-wrap">
                            <asp:Label ID="lblAvatar" runat="server" Text="U" />
                        </div>
                        <div class="hero-user-info">
                            <h2><asp:Label ID="lblDisplayName" runat="server" Text="User Name" /></h2>
                            <asp:Label ID="lblRoleBadge" runat="server" CssClass="role-badge learner" Text="Learner" />
                            <p class="bio"><asp:Label ID="lblBioPreview" runat="server" Text="No bio yet." /></p>
                        </div>
                    </div>

                    <asp:Button ID="btnLogout" runat="server" Text="Sign Out" CssClass="btn-logout" OnClick="btnLogout_Click" />
                </div>
            </div>
        </section>

        <main class="profile-main">
            <div class="container">
                <div class="profile-layout">

                    <!-- LEFT COLUMN -->
                    <div>
                        <div class="p-card">
                            <div class="p-card-header"><i class="fa-solid fa-user-pen"></i><h5>Edit Profile</h5></div>
                            <div class="p-card-body">
                                <label class="form-label">Full Name</label>
                                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-field" placeholder="Your full name" />

                                <label class="form-label">Username</label>
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-field" ReadOnly="true" />

                                <label class="form-label">Email</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-field" ReadOnly="true" />

                                <label class="form-label">Bio</label>
                                <asp:TextBox ID="txtBio" runat="server" CssClass="form-field" TextMode="MultiLine" placeholder="Tell others about yourself…"></asp:TextBox>

                                <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes" CssClass="btn-save-profile" OnClick="btnSaveProfile_Click" />
                                <asp:Label ID="lblMsg" runat="server" Text=""></asp:Label>
                            </div>
                        </div>

                        <div class="p-card">
                            <div class="p-card-header"><i class="fa-solid fa-chart-simple"></i><h5>Quick Stats</h5></div>
                            <div class="p-card-body">
                                <div class="mini-stats">
                                    <div class="mini-stat">
                                        <div class="ms-val"><asp:Label ID="lblStatAttempts" runat="server" Text="0" /></div>
                                        <div class="ms-label">Quiz Attempts</div>
                                    </div>
                                    <div class="mini-stat">
                                        <div class="ms-val"><asp:Label ID="lblStatSaved" runat="server" Text="0" /></div>
                                        <div class="ms-label"><asp:Label ID="lblStatSavedLabel" runat="server" Text="Saved Quizzes" /></div>
                                    </div>
                                    <div class="mini-stat">
                                        <div class="ms-val"><asp:Label ID="lblStatQuizzes" runat="server" Text="0" /></div>
                                        <div class="ms-label"><asp:Label ID="lblStatQuizzesLabel" runat="server" Text="Quizzes Created" /></div>
                                    </div>
                                    <div class="mini-stat">
                                        <div class="ms-val"><asp:Label ID="lblStatAvg" runat="server" Text="0%" /></div>
                                        <div class="ms-label">Avg. Score</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- RIGHT COLUMN -->
                    <div>
                        <div class="p-card">
                            <div class="p-card-header"><i class="fa-solid fa-bolt"></i><h5>Quick Access</h5></div>
                            <div class="p-card-body" style="padding:8px 24px;">

                                <button type="button" class="quick-link" id="qlSaved" onclick="goTo('/Forms/Assessments/Home.aspx?scope=saved')">
                                    <div class="ql-icon"><i class="fa-solid fa-bookmark"></i></div>
                                    <div class="ql-text">
                                        <strong>Saved Quizzes</strong>
                                        <span>View your bookmarked quizzes</span>
                                    </div>
                                    <i class="fa-solid fa-chevron-right ql-arrow"></i>
                                </button>

                                <button type="button" class="quick-link" id="qlSavedResources" onclick="goTo('/Forms/Resources/Home.aspx?scope=saved')">
                                    <div class="ql-icon"><i class="fa-solid fa-book-open-reader"></i></div>
                                    <div class="ql-text">
                                        <strong>Saved Resources</strong>
                                        <span>View your bookmarked resources</span>
                                    </div>
                                    <i class="fa-solid fa-chevron-right ql-arrow"></i>
                                </button>

                                <button type="button" class="quick-link" id="qlMyQuizzes" style="display:none" onclick="goTo('/Forms/Assessments/Home.aspx?scope=mine')">
                                    <div class="ql-icon"><i class="fa-solid fa-pen-to-square"></i></div>
                                    <div class="ql-text">
                                        <strong>My Quizzes</strong>
                                        <span>View and manage quizzes you created</span>
                                    </div>
                                    <i class="fa-solid fa-chevron-right ql-arrow"></i>
                                </button>

                                <button type="button" class="quick-link" onclick="goTo('/Forms/Assessments/Home.aspx?tab=analytics')">
                                    <div class="ql-icon"><i class="fa-solid fa-chart-line"></i></div>
                                    <div class="ql-text">
                                        <strong>Quiz Analytics</strong>
                                        <span id="analyticsDesc">View your performance stats</span>
                                    </div>
                                    <i class="fa-solid fa-chevron-right ql-arrow"></i>
                                </button>

                                <button type="button" class="quick-link" onclick="goTo('/Forms/Messaging/Messages.aspx')">
                                    <div class="ql-icon">
                                        <i class="fa-solid fa-envelope"></i>
                                        <span class="unread-dot" id="profileMsgDot"></span>
                                    </div>
                                    <div class="ql-text">
                                        <strong>Messages</strong>
                                        <span>Chat with other users</span>
                                    </div>
                                    <i class="fa-solid fa-chevron-right ql-arrow"></i>
                                </button>

                            </div>
                        </div>

                        <div class="p-card">
                            <div class="p-card-header"><i class="fa-solid fa-circle-info"></i><h5>Account Info</h5></div>
                            <div class="p-card-body">
                                <p style="font-size:0.85rem;color:var(--muted);margin-bottom:8px;">
                                    <i class="fa-regular fa-calendar me-2"></i>
                                    Member since <strong style="color:var(--ink)"><asp:Label ID="lblMemberSince" runat="server" Text="—" /></strong>
                                </p>
                                <p style="font-size:0.85rem;color:var(--muted);">
                                    <i class="fa-regular fa-envelope me-2"></i>
                                    <asp:Label ID="lblEmailInfo" runat="server" Text="" />
                                </p>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </main>
    </form>

    <script>
        function goTo(url) {
            window.location.href = url;
        }

        window.addEventListener('DOMContentLoaded', function () {
            var role = document.getElementById('<%= hfRole.ClientID %>').value || '';

            if (role === 'Educator') {
                var myQ = document.getElementById('qlMyQuizzes');
                if (myQ) myQ.style.display = 'flex';

                var desc = document.getElementById('analyticsDesc');
                if (desc) desc.textContent = 'See how learners perform on your quizzes';
            }

            if (role === 'Administrator') {
                var qlSaved = document.getElementById('qlSaved');
                if (qlSaved) qlSaved.style.display = 'none';

                var qlSavedResources = document.getElementById('qlSavedResources');
                if (qlSavedResources) qlSavedResources.style.display = 'none';

                var desc = document.getElementById('analyticsDesc');
                if (desc) desc.textContent = 'View platform-wide quiz and attempt stats';
            }

            var handlerUrl = document.getElementById('<%= hfHandlerUrl.ClientID %>').value;
            if (handlerUrl) {
                fetch(handlerUrl + '?action=unread', { credentials: 'same-origin' })
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        if (data && data.total > 0) {
                            var dot = document.getElementById('profileMsgDot');
                            if (dot) dot.style.display = 'block';

                            var gDot = document.getElementById('globalMsgDot');
                            if (gDot) gDot.style.display = 'block';
                        }
                    })
                    .catch(function () { });
            }
        });
    </script>
</body>
</html>