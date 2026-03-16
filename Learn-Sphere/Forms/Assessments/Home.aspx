<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" 
    Inherits="Learn_Sphere.Forms.Assessment.Home" EnableEventValidation="false" %>
<%@ Register TagPrefix="uc" TagName="GlobalHeader" Src="~/Shared/GlobalHeader.ascx" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Assessments — LearnSphere</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&display=swap" rel="stylesheet" />

    <style>
        :root {
            --ink: #0d0d1a; --surface: #f4f3ff; --card: #ffffff;
            --accent: #5b4fff; --accent2: #ff4f8b; --accent3: #00d4aa;
            --muted: #7b7a99; --border: #e4e2ff; --tag-bg: #ede9ff;
            --shadow: 0 4px 24px rgba(91,79,255,0.10);
            --shadow-hover: 0 12px 40px rgba(91,79,255,0.22);
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Roboto', sans-serif; background: var(--surface); color: var(--ink); min-height: 100vh; }

        .hero {
            background: linear-gradient(135deg, #0d0d1a 0%, #1a1040 60%, #2d1260 100%);
            padding: 72px 0 48px; position: relative; overflow: hidden;
        }
        .hero::before {
            content: ''; position: absolute; inset: 0;
            background: radial-gradient(ellipse at 20% 80%, rgba(91,79,255,0.3) 0%, transparent 60%),
                        radial-gradient(ellipse at 80% 20%, rgba(255,79,139,0.2) 0%, transparent 55%);
        }
        .hero-inner { position: relative; z-index: 1; }
        .hero h1 { font-size: clamp(2rem,5vw,3.5rem); font-weight: 900; color: #fff; letter-spacing: -1px; line-height: 1.1; }
        .hero h1 span { color: var(--accent); }
        .hero p { color: rgba(255,255,255,0.55); font-size: 1.05rem; margin-top: 10px; font-weight: 300; }

        .tab-switcher { display: inline-flex; background: rgba(255,255,255,0.07); border: 1px solid rgba(255,255,255,0.12); border-radius: 50px; padding: 5px; gap: 4px; margin-top: 28px; }
        .tab-switcher button { font-family: 'Roboto', sans-serif; font-size: 0.88rem; font-weight: 700; border: none; border-radius: 50px; padding: 9px 22px; background: transparent; color: rgba(255,255,255,0.5); cursor: pointer; transition: all 0.25s ease; }
        .tab-switcher button.active { background: var(--accent); color: #fff; box-shadow: 0 4px 16px rgba(91,79,255,0.45); }
        .tab-switcher button:hover:not(.active) { color: #fff; }
        .tab-switcher button i { margin-right: 7px; }

        .main-content { padding: 40px 0 80px; }
        .submodule { display: none; }
        .submodule.visible { display: block; }

        .educator-toolbar { display: none; gap: 10px; margin-bottom: 20px; }
        .educator-toolbar.show { display: flex; }
        .btn-create-quiz { font-family: 'Roboto', sans-serif; font-size: 0.88rem; font-weight: 700; background: linear-gradient(135deg,var(--accent),#7c6fff); color: #fff; border: none; border-radius: 10px; padding: 10px 22px; cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; gap: 8px; text-decoration: none; }
        .btn-create-quiz:hover { opacity: 0.88; color: #fff; transform: translateY(-1px); }

        .filter-bar { background: var(--card); border-radius: 16px; padding: 20px 24px; box-shadow: var(--shadow); border: 1px solid var(--border); margin-bottom: 28px; display: flex; flex-wrap: wrap; gap: 14px; align-items: center; }
        .quiz-scope-tabs { display: flex; gap: 6px; flex-shrink: 0; }
        .quiz-scope-tabs button { font-family: 'Roboto', sans-serif; font-size: 0.8rem; font-weight: 700; padding: 7px 16px; border-radius: 50px; border: 1.5px solid var(--border); background: transparent; color: var(--muted); cursor: pointer; transition: all 0.2s; white-space: nowrap; }
        .quiz-scope-tabs button.active { background: var(--accent); border-color: var(--accent); color: #fff; box-shadow: 0 3px 12px rgba(91,79,255,0.3); }
        .quiz-scope-tabs button:hover:not(.active) { border-color: var(--accent); color: var(--accent); }
        .divider-v { width: 1px; height: 36px; background: var(--border); flex-shrink: 0; }
        .filter-group { display: flex; gap: 10px; flex: 1; flex-wrap: wrap; align-items: center; }
        .filter-group .form-control, .filter-group .form-select { font-family: 'Roboto', sans-serif; font-size: 0.875rem; border: 1.5px solid var(--border); border-radius: 10px; padding: 8px 12px; color: var(--ink); background: var(--surface); transition: border-color 0.2s; }
        .filter-group .form-control:focus, .filter-group .form-select:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px rgba(91,79,255,0.10); }
        .search-wrap { position: relative; flex: 1; min-width: 180px; }
        .search-wrap i { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--muted); font-size: 0.85rem; }
        .search-wrap input { padding-left: 34px !important; }

        .quiz-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
        .quiz-card { background: var(--card); border-radius: 18px; border: 1px solid var(--border); padding: 24px; transition: all 0.28s cubic-bezier(0.34,1.56,0.64,1); position: relative; overflow: hidden; animation: fadeUp 0.4s ease both; }
        .quiz-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: linear-gradient(90deg,var(--accent),var(--accent2)); transform: scaleX(0); transform-origin: left; transition: transform 0.3s ease; }
        .quiz-card:hover { transform: translateY(-5px); box-shadow: var(--shadow-hover); border-color: rgba(91,79,255,0.3); }
        .quiz-card:hover::before { transform: scaleX(1); }
        .quiz-card-tag { display: inline-block; font-size: 0.7rem; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; background: var(--tag-bg); color: var(--accent); border-radius: 50px; padding: 3px 10px; margin-bottom: 12px; }
        .quiz-card h4 { font-size: 1.05rem; font-weight: 700; color: var(--ink); margin-bottom: 6px; line-height: 1.3; }
        .quiz-card p { font-size: 0.85rem; color: var(--muted); line-height: 1.5; margin-bottom: 14px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .quiz-card-meta { display: flex; align-items: center; gap: 14px; font-size: 0.8rem; color: var(--muted); flex-wrap: wrap; }
        .quiz-card-meta span { display: flex; align-items: center; gap: 5px; }

        .card-btn-row { display: flex; gap: 8px; margin-top: 16px; }
        .btn-take { font-family: 'Roboto', sans-serif; font-size: 0.8rem; font-weight: 700; background: linear-gradient(135deg,var(--accent),#7c6fff); color: #fff; border: none; border-radius: 8px; padding: 8px 14px; cursor: pointer; transition: 0.2s; flex: 1; }
        .btn-take:hover { opacity: 0.88; transform: scale(0.98); }
        .btn-take.completed { background: linear-gradient(135deg,var(--accent3),#00b894); }
        /* Educator own / Admin view-only */
        .btn-take.disabled-own { background: #e8e7f5; color: var(--muted); cursor: not-allowed; font-style: italic; }
        /* Save button — bookmark style */
        .btn-save { font-family: 'Roboto', sans-serif; font-size: 0.8rem; font-weight: 700; background: var(--surface); color: var(--muted); border: 1.5px solid var(--border); border-radius: 8px; padding: 8px 12px; cursor: pointer; transition: 0.2s; display: flex; align-items: center; gap: 5px; }
        .btn-save:hover { border-color: var(--accent); color: var(--accent); background: #ede9ff; }
        .btn-save.saved { background: #ede9ff; color: var(--accent); border-color: var(--accent); }
        .btn-delete-quiz { font-family: 'Roboto', sans-serif; font-size: 0.78rem; font-weight: 700; background: #fff0f0; color: #c0244a; border: 1.5px solid #ffd6d6; border-radius: 8px; padding: 8px 12px; cursor: pointer; transition: 0.2s; }
        .btn-delete-quiz:hover { background: #c0244a; color: #fff; border-color: #c0244a; }
        .badge-attempts { font-size: 0.68rem; font-weight: 700; background: #fff0f6; color: var(--accent2); border-radius: 50px; padding: 2px 9px; border: 1px solid #ffd6e8; }

        .empty-state { text-align: center; padding: 80px 20px; color: var(--muted); }
        .empty-state i { font-size: 3.5rem; color: var(--border); margin-bottom: 16px; display: block; }
        .empty-state h4 { font-weight: 700; color: var(--ink); margin-bottom: 6px; }
        .results-count { font-size: 0.82rem; color: var(--muted); font-weight: 500; margin-bottom: 16px; }

        /* Analytics */
        .analytics-topbar { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px; margin-bottom: 28px; }
        .analytics-topbar h2 { font-size: 1.6rem; font-weight: 900; letter-spacing: -0.5px; }
        .analytics-topbar h2 span { color: var(--accent); }

        .analytics-filter-pills { display: flex; gap: 8px; }
        .analytics-filter-pills button { font-family: 'Roboto', sans-serif; font-size: 0.8rem; font-weight: 700; padding: 8px 18px; border-radius: 50px; border: 1.5px solid var(--border); background: var(--card); color: var(--muted); cursor: pointer; transition: all 0.2s; }
        .analytics-filter-pills button.active { background: var(--ink); border-color: var(--ink); color: #fff; }
        .analytics-filter-pills button:hover:not(.active) { border-color: var(--ink); color: var(--ink); }

        .stat-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 16px; margin-bottom: 32px; }
        .stat-card { background: var(--card); border-radius: 16px; padding: 22px 20px; border: 1px solid var(--border); box-shadow: var(--shadow); position: relative; overflow: hidden; }
        .stat-card::after { content: ''; position: absolute; bottom: -20px; right: -20px; width: 80px; height: 80px; border-radius: 50%; background: var(--accent-bg, rgba(91,79,255,0.06)); }
        .stat-card .stat-icon { font-size: 1.4rem; margin-bottom: 12px; display: block; }
        .stat-card .stat-value { font-size: 2rem; font-weight: 900; letter-spacing: -1px; color: var(--ink); line-height: 1; }
        .stat-card .stat-label { font-size: 0.78rem; color: var(--muted); margin-top: 4px; font-weight: 500; }
        .stat-card.accent1{--accent-bg:rgba(91,79,255,0.07)}.stat-card.accent2{--accent-bg:rgba(255,79,139,0.07)}.stat-card.accent3{--accent-bg:rgba(0,212,170,0.07)}.stat-card.accent4{--accent-bg:rgba(255,165,0,0.07)}

        .history-section { background: var(--card); border-radius: 18px; border: 1px solid var(--border); box-shadow: var(--shadow); overflow: hidden; margin-bottom: 28px; }
        .history-section-header { padding: 20px 24px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; }
        .history-section-header h5 { font-size: 1rem; font-weight: 700; margin: 0; }
        .history-table { width: 100%; border-collapse: collapse; }
        .history-table th { font-size: 0.72rem; font-weight: 700; letter-spacing: 0.8px; text-transform: uppercase; color: var(--muted); padding: 12px 24px; text-align: left; background: var(--surface); border-bottom: 1px solid var(--border); }
        .history-table td { padding: 14px 24px; font-size: 0.88rem; border-bottom: 1px solid var(--border); color: var(--ink); vertical-align: middle; }
        .history-table tr:last-child td { border-bottom: none; }
        .history-table tr:hover td { background: rgba(91,79,255,0.025); }
        .score-pill { display: inline-flex; align-items: center; font-size: 0.82rem; font-weight: 700; padding: 4px 12px; border-radius: 50px; }
        .score-pill.high { background: #d4f7ee; color: #00856a; }
        .score-pill.mid  { background: #fff3d4; color: #a56200; }
        .score-pill.low  { background: #fde8ee; color: #c0244a; }

        .chart-card { background: var(--card); border-radius: 18px; border: 1px solid var(--border); box-shadow: var(--shadow); padding: 28px 24px; margin-bottom: 28px; }
        .chart-card h5 { font-size: 1rem; font-weight: 700; margin-bottom: 20px; }
        .bar-chart-wrap { display: flex; align-items: flex-end; gap: 10px; height: 160px; padding-top: 10px; }
        .bar-item { flex: 1; display: flex; flex-direction: column; align-items: center; gap: 6px; height: 100%; justify-content: flex-end; }
        .bar-item .bar-fill { width: 100%; border-radius: 6px 6px 0 0; background: linear-gradient(180deg,var(--accent),#a89bff); min-height: 4px; }
        .bar-item .bar-label { font-size: 0.7rem; color: var(--muted); font-weight: 500; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 60px; text-align: center; }
        .bar-item .bar-val { font-size: 0.75rem; font-weight: 700; color: var(--accent); }

        @keyframes fadeUp { from{opacity:0;transform:translateY(18px)}to{opacity:1;transform:translateY(0)} }
        .quiz-card:nth-child(1){animation-delay:.05s}.quiz-card:nth-child(2){animation-delay:.10s}
        .quiz-card:nth-child(3){animation-delay:.15s}.quiz-card:nth-child(4){animation-delay:.20s}
        .quiz-card:nth-child(5){animation-delay:.25s}.quiz-card:nth-child(6){animation-delay:.30s}
        @media(max-width:640px){.filter-bar{flex-direction:column;align-items:stretch}.divider-v{display:none}}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:GlobalHeader ID="GlobalHeader1" runat="server" />

        <div class="hero">
            <div class="container hero-inner">
                <h1>Assessment<br /><span>Hub</span></h1>
                <p>Test your knowledge · Track your progress · Level up your skills</p>
                <div class="tab-switcher">
                    <button type="button" id="tabQuizzes"   class="active" onclick="switchTab('quizzes')"><i class="fa-solid fa-layer-group"></i>Quizzes</button>
                    <button type="button" id="tabAnalytics" onclick="switchTab('analytics')"><i class="fa-solid fa-chart-line"></i>Analytics</button>
                </div>
            </div>
        </div>

        <div class="container main-content">

            <!-- ══ QUIZZES ══ -->
            <div id="subQuizzes" class="submodule visible">
                <div class="educator-toolbar" id="educatorToolbar">
                    <a href="/Forms/Assessments/CreateQuiz.aspx" class="btn-create-quiz">
                        <i class="fa-solid fa-plus"></i> Create New Quiz
                    </a>
                </div>

                <div class="filter-bar">
                    <div class="quiz-scope-tabs">
                        <button type="button" class="active" onclick="setScope(this,'all')"   id="scopeAll"><i class="fa-solid fa-globe me-1"></i>All Quizzes</button>
                        <button type="button"               onclick="setScope(this,'saved')" id="scopeSaved"><i class="fa-solid fa-bookmark me-1"></i>Saved</button>
                        <button type="button"               onclick="setScope(this,'mine')"  id="scopeMine" style="display:none"><i class="fa-solid fa-pen-to-square me-1"></i>My Quizzes</button>
                    </div>
                    <div class="divider-v"></div>
                    <div class="filter-group">
                        <div class="search-wrap">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <input type="text" id="searchInput" class="form-control" placeholder="Search quizzes…" oninput="filterQuizCards()" />
                        </div>
                        <select class="form-select" id="sortSelect" onchange="filterQuizCards()" style="max-width:160px;">
                            <option value="newest">Newest First</option>
                            <option value="oldest">Oldest First</option>
                            <option value="az">A → Z</option>
                            <option value="za">Z → A</option>
                            <option value="questions">Most Questions</option>
                        </select>
                    </div>
                    <asp:HiddenField ID="hfScope" runat="server" Value="all" />
                </div>

                <div class="results-count" id="resultsCount"></div>

                <div class="quiz-grid" id="quizGrid">
                    <asp:Repeater ID="rptQuizzes" runat="server" OnItemDataBound="rptQuizzes_ItemDataBound">
                        <ItemTemplate>
                            <div class="quiz-card"
                                 data-title='<%# Eval("Title") %>'
                                 data-date='<%# Eval("DateCreated","{0:yyyy-MM-dd}") %>'
                                 data-questions='<%# Eval("QuestionCount") %>'
                                 data-scope='<%# Eval("Scope") %>'
                                 data-saved='<%# Eval("IsSaved").ToString()=="1"?"true":"false" %>'>
                                <div class="quiz-card-tag"><i class="fa-solid fa-list-check me-1"></i><%# Eval("QuestionCount") %> Questions</div>
                                <h4><%# Eval("Title") %></h4>
                                <p><%# string.IsNullOrEmpty((Eval("Description")??"").ToString()) ? "No description provided." : Eval("Description") %></p>
                                <div class="quiz-card-meta">
                                    <span><i class="fa-regular fa-user"></i><%# Eval("EducatorName") %></span>
                                    <span><i class="fa-regular fa-calendar"></i><%# Eval("DateCreated","{0:MMM dd, yyyy}") %></span>
                                    <asp:Label ID="lblAttempts" runat="server"></asp:Label>
                                </div>
                                <div class="card-btn-row">
                                    <asp:Button ID="btnTakeQuiz" runat="server"
                                        CommandArgument='<%# Eval("QuizID") %>'
                                        OnClick="btnTakeQuiz_Click"
                                        CssClass="btn-take" Text="Take Quiz →" />
                                    <asp:Button ID="btnSave" runat="server"
                                        CommandArgument='<%# Eval("QuizID") %>'
                                        OnClick="btnSave_Click"
                                        CssClass="btn-save" Text="🔖 Save" Visible="false" />
                                    <asp:Button ID="btnDelete" runat="server"
                                        CommandArgument='<%# Eval("QuizID") %>'
                                        OnClick="btnDelete_Click"
                                        CssClass="btn-delete-quiz" Text="🗑" Visible="false"
                                        OnClientClick="return confirm('Delete this quiz? This cannot be undone.');" />
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                    <div class="empty-state">
                        <i class="fa-solid fa-clipboard-question"></i>
                        <h4>No Quizzes Found</h4>
                        <p>No quizzes available yet. Check back later!</p>
                    </div>
                </asp:Panel>
            </div>

            <!-- ══ ANALYTICS ══ -->
            <div id="subAnalytics" class="submodule">

                <div class="analytics-topbar">
                    <h2>Your <span>Analytics</span></h2>
                    <%-- Learner filter pills only --%>
                    <div class="analytics-filter-pills" id="learnerFilterPills" style="display:none">
                        <button type="button" id="filterOverall" onclick="setAnalyticsFilter(this,'overall')">Overall</button>
                        <button type="button" id="filterRecent"  onclick="setAnalyticsFilter(this,'recent')">Last 5 Attempts</button>
                    </div>
                </div>

                <%-- Shared headline stat cards --%>
                <div class="stat-grid">
                    <div class="stat-card accent1"><span class="stat-icon">🎯</span><div class="stat-value"><asp:Label ID="lblTotalAttempts" runat="server" Text="0"></asp:Label></div><div class="stat-label">Total Attempts</div></div>
                    <div class="stat-card accent2"><span class="stat-icon">⭐</span><div class="stat-value"><asp:Label ID="lblAvgScore"      runat="server" Text="0%"></asp:Label></div><div class="stat-label">Avg. Score</div></div>
                    <div class="stat-card accent3"><span class="stat-icon">🏆</span><div class="stat-value"><asp:Label ID="lblBestScore"     runat="server" Text="0%"></asp:Label></div><div class="stat-label">Best Score</div></div>
                    <div class="stat-card accent4"><span class="stat-icon">📚</span><div class="stat-value"><asp:Label ID="lblUniqueQuizzes" runat="server" Text="0"></asp:Label></div><div class="stat-label"><asp:Label ID="lblUniqueLabel" runat="server" Text="Unique Quizzes"></asp:Label></div></div>
                </div>

                <%-- EDUCATOR analytics --%>
                <asp:Panel ID="pnlEducatorAnalytics" runat="server" Visible="false">
                    <div class="chart-card">
                        <h5><i class="fa-solid fa-chart-bar me-2" style="color:var(--accent)"></i>Avg Score per Quiz (All Learners)</h5>
                        <div class="bar-chart-wrap">
                            <asp:Repeater ID="rptEducatorChart" runat="server">
                                <ItemTemplate>
                                    <div class="bar-item">
                                        <div class="bar-val"><%# Eval("AvgScore") %>%</div>
                                        <div class="bar-fill" style='height:<%# Eval("BarHeight") %>px;' title='<%# Eval("Title") %>: <%# Eval("AvgScore") %>% avg'></div>
                                        <div class="bar-label" title='<%# Eval("Title") %>'><%# Eval("ShortTitle") %></div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                    <div class="history-section">
                        <div class="history-section-header"><h5><i class="fa-solid fa-table-list me-2" style="color:var(--accent)"></i>Quiz Performance Overview</h5></div>
                        <table class="history-table">
                            <thead><tr><th>Quiz Title</th><th>Attempts</th><th>Avg Score</th><th>Highest Score</th><th>Created</th></tr></thead>
                            <tbody>
                                <asp:Repeater ID="rptEducatorStats" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td style="font-weight:600"><%# Eval("Title") %></td>
                                            <td><%# Eval("TotalAttempts") %></td>
                                            <td><span class="score-pill <%# GetScorePillClass(Convert.ToInt32(Eval("AvgScore"))) %>"><%# Eval("AvgScore") %>%</span></td>
                                            <td><span class="score-pill <%# GetScorePillClass(Convert.ToInt32(Eval("MaxScore"))) %>"><%# Eval("MaxScore") %>%</span></td>
                                            <td style="color:var(--muted)"><%# Eval("DateCreated","{0:MMM dd, yyyy}") %></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </asp:Panel>

                <%-- LEARNER analytics --%>
                <asp:Panel ID="pnlLearnerAnalytics" runat="server" Visible="false">
                    <div class="history-section">
                        <div class="history-section-header">
                            <h5><i class="fa-solid fa-clock-rotate-left me-2" style="color:var(--accent)"></i>Attempt History</h5>
                            <span class="badge-attempts"><asp:Label ID="lblAttemptCount" runat="server" Text="0 attempts"></asp:Label></span>
                        </div>
                        <table class="history-table">
                            <thead><tr><th>Quiz Title</th><th>Score</th><th>Questions</th><th>Date</th><th>Result</th></tr></thead>
                            <tbody>
                                <asp:Repeater ID="rptAttempts" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td style="font-weight:600"><%# Eval("Title") %></td>
                                            <td><span class="score-pill <%# GetScorePillClass(Convert.ToInt32(Eval("ScorePct"))) %>"><%# Eval("Score") %> / <%# Eval("TotalQ") %></span></td>
                                            <td style="color:var(--muted)"><%# Eval("TotalQ") %> Qs</td>
                                            <td style="color:var(--muted)"><%# Eval("AttemptDate","{0:MMM dd, yyyy}") %></td>
                                            <td><span class="score-pill <%# GetScorePillClass(Convert.ToInt32(Eval("ScorePct"))) %>"><%# Convert.ToInt32(Eval("ScorePct"))>=70?"Pass":"Needs Work" %></span></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </asp:Panel>

                <%-- ADMIN analytics (platform-wide) --%>
                <asp:Panel ID="pnlAdminAnalytics" runat="server" Visible="false">
                    <div class="chart-card">
                        <h5><i class="fa-solid fa-chart-bar me-2" style="color:var(--accent)"></i>Top Quizzes by Attempts (Platform)</h5>
                        <div class="bar-chart-wrap">
                            <asp:Repeater ID="rptAdminChart" runat="server">
                                <ItemTemplate>
                                    <div class="bar-item">
                                        <div class="bar-val"><%# Eval("AvgScore") %>%</div>
                                        <div class="bar-fill" style='height:<%# Eval("BarHeight") %>px;' title='<%# Eval("Title") %>'></div>
                                        <div class="bar-label" title='<%# Eval("Title") %>'><%# Eval("ShortTitle") %></div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                    <div class="history-section">
                        <div class="history-section-header"><h5><i class="fa-solid fa-globe me-2" style="color:var(--accent)"></i>All Quizzes — Platform Overview</h5></div>
                        <table class="history-table">
                            <thead><tr><th>Quiz Title</th><th>Educator</th><th>Attempts</th><th>Avg Score</th><th>Highest Score</th><th>Created</th></tr></thead>
                            <tbody>
                                <asp:Repeater ID="rptAdminStats" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td style="font-weight:600"><%# Eval("Title") %></td>
                                            <td style="color:var(--muted)"><%# Eval("EducatorName") %></td>
                                            <td><%# Eval("TotalAttempts") %></td>
                                            <td><span class="score-pill <%# GetScorePillClass(Convert.ToInt32(Eval("AvgScore"))) %>"><%# Eval("AvgScore") %>%</span></td>
                                            <td><span class="score-pill <%# GetScorePillClass(Convert.ToInt32(Eval("MaxScore"))) %>"><%# Eval("MaxScore") %>%</span></td>
                                            <td style="color:var(--muted)"><%# Eval("DateCreated","{0:MMM dd, yyyy}") %></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </asp:Panel>

                <asp:HiddenField ID="hfAnalyticsFilter" runat="server" Value="overall" />
            </div>

        </div>

        <asp:HiddenField ID="hfActiveTab"  runat="server" Value="quizzes" />
        <asp:HiddenField ID="hfRole"       runat="server" Value="" />
        <asp:HiddenField ID="hfOpenScope"  runat="server" Value="" />
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var userRole     = document.getElementById('<%= hfRole.ClientID %>').value;
        var currentScope = 'all';

        window.addEventListener('DOMContentLoaded', function () {
            if (document.getElementById('<%= hfActiveTab.ClientID %>').value === 'analytics')
                switchTab('analytics');

            // Role-specific UI
            if (userRole === 'Educator') {
                document.getElementById('scopeMine').style.display    = 'inline-block';
                document.getElementById('educatorToolbar').classList.add('show');
            }
            if (userRole === 'Learner') {
                document.getElementById('learnerFilterPills').style.display = 'flex';
                // Learners don't see saved scope? They do — keep it visible
            }
            if (userRole === 'Administrator') {
                // Admin has no saved quizzes — hide the Saved scope tab
                document.getElementById('scopeSaved').style.display = 'none';
            }

            // Restore analytics filter active state after postback
            var savedFilter = document.getElementById('<%= hfAnalyticsFilter.ClientID %>').value;
            if (savedFilter === 'recent') {
                document.getElementById('filterOverall').classList.remove('active');
                document.getElementById('filterRecent').classList.add('active');
            } else {
                document.getElementById('filterOverall').classList.add('active');
                document.getElementById('filterRecent').classList.remove('active');
            }

            // Open scope from URL / profile link
            var openScope = document.getElementById('<%= hfOpenScope.ClientID %>').value;
            if (openScope === 'saved' && userRole !== 'Administrator') {
                setScope(document.getElementById('scopeSaved'), 'saved');
            } else if (openScope === 'mine') {
                var mb = document.getElementById('scopeMine');
                if (mb && mb.style.display !== 'none') setScope(mb, 'mine');
            }

            updateResultsCount();
        });

        function switchTab(tab) {
            ['subQuizzes','subAnalytics'].forEach(function(id){ document.getElementById(id).classList.remove('visible'); });
            ['tabQuizzes','tabAnalytics'].forEach(function(id){ document.getElementById(id).classList.remove('active'); });
            document.getElementById(tab === 'quizzes' ? 'subQuizzes' : 'subAnalytics').classList.add('visible');
            document.getElementById(tab === 'quizzes' ? 'tabQuizzes' : 'tabAnalytics').classList.add('active');
            document.getElementById('<%= hfActiveTab.ClientID %>').value = tab;
        }

        function setScope(btn, scope) {
            document.querySelectorAll('.quiz-scope-tabs button').forEach(function(b){ b.classList.remove('active'); });
            btn.classList.add('active');
            currentScope = scope;
            filterQuizCards();
        }

        function filterQuizCards() {
            var keyword = document.getElementById('searchInput').value.toLowerCase().trim();
            var sort    = document.getElementById('sortSelect').value;
            var cards   = Array.from(document.querySelectorAll('#quizGrid .quiz-card'));
            cards.forEach(function(card) {
                var title  = (card.getAttribute('data-title')||'').toLowerCase();
                var cScope = card.getAttribute('data-scope');
                var saved  = card.getAttribute('data-saved') === 'true';
                var ok = (currentScope === 'all') ||
                         (currentScope === 'saved' && saved) ||
                         (currentScope === 'mine'  && cScope === 'mine');
                card.style.display = (ok && title.includes(keyword)) ? '' : 'none';
            });
            var vis = cards.filter(function(c){ return c.style.display !== 'none'; });
            vis.sort(function(a,b){
                if (sort==='newest')    return (b.getAttribute('data-date')||'').localeCompare(a.getAttribute('data-date')||'');
                if (sort==='oldest')    return (a.getAttribute('data-date')||'').localeCompare(b.getAttribute('data-date')||'');
                if (sort==='az')        return (a.getAttribute('data-title')||'').localeCompare(b.getAttribute('data-title')||'');
                if (sort==='za')        return (b.getAttribute('data-title')||'').localeCompare(a.getAttribute('data-title')||'');
                if (sort==='questions') return parseInt(b.getAttribute('data-questions')||0)-parseInt(a.getAttribute('data-questions')||0);
                return 0;
            });
            var grid = document.getElementById('quizGrid');
            vis.forEach(function(c){ grid.appendChild(c); });
            updateResultsCount();
        }

        function updateResultsCount() {
            var count = 0;
            document.querySelectorAll('#quizGrid .quiz-card').forEach(function(c){ if(c.style.display!=='none') count++; });
            var el = document.getElementById('resultsCount');
            if (el) el.textContent = count + ' quiz' + (count!==1?'zes':'') + ' found';
        }

        function setAnalyticsFilter(btn, filter) {
            document.querySelectorAll('.analytics-filter-pills button').forEach(function(b){ b.classList.remove('active'); });
            btn.classList.add('active');
            document.getElementById('<%= hfAnalyticsFilter.ClientID %>').value = filter;
            document.getElementById('<%= hfActiveTab.ClientID %>').value = 'analytics';
        document.getElementById('form1').submit();
    }
    </script>
</body>
</html>
