<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TakeQuiz.aspx.cs" Inherits="Learn_Sphere.Forms.Assessment.TakeQuiz" %>
<%@ Register TagPrefix="uc" TagName="GlobalHeader" Src="~/Shared/GlobalHeader.ascx" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Take Quiz — LearnSphere</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>

    <style>
        :root {
            --ink: #0d0d1a;
            --surface: #f4f3ff;
            --card: #ffffff;
            --accent: #5b4fff;
            --accent2: #ff4f8b;
            --accent3: #00d4aa;
            --muted: #7b7a99;
            --border: #e4e2ff;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--surface);
            color: var(--ink);
            min-height: 100vh;
        }

        /* ─── HERO ─── */
        .quiz-hero {
            background: linear-gradient(135deg, #0d0d1a 0%, #1a1040 60%, #2d1260 100%);
            padding: 60px 0 36px;
            position: relative;
            overflow: hidden;
        }
        .quiz-hero::before {
            content: '';
            position: absolute; inset: 0;
            background: radial-gradient(ellipse at 30% 80%, rgba(91,79,255,0.28) 0%, transparent 55%);
        }
        .quiz-hero-inner { position: relative; z-index: 1; }
        .quiz-hero h1 {
            font-family: 'Syne', sans-serif;
            font-size: clamp(1.6rem, 4vw, 2.6rem);
            font-weight: 800;
            color: #fff;
            letter-spacing: -0.5px;
        }
        .quiz-hero p { color: rgba(255,255,255,0.5); font-size: 0.95rem; margin-top: 6px; }

        .quiz-progress-bar {
            height: 4px;
            background: rgba(255,255,255,0.12);
            border-radius: 4px;
            margin-top: 20px;
            overflow: hidden;
        }
        .quiz-progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            border-radius: 4px;
            transition: width 0.5s ease;
        }

        /* ─── BACK BUTTON ─── */
        .btn-back-quiz {
            font-family: 'Syne', sans-serif;
            font-size: 0.8rem;
            font-weight: 700;
            background: rgba(255,255,255,0.08);
            border: 1.5px solid rgba(255,255,255,0.2);
            color: rgba(255,255,255,0.7);
            border-radius: 10px;
            padding: 8px 18px;
            cursor: pointer;
            transition: 0.2s;
            margin-bottom: 20px;
            display: inline-block;
        }
        .btn-back-quiz:hover {
            background: rgba(255,255,255,0.15);
            color: #fff;
        }

        /* ─── MAIN ─── */
        .quiz-main { padding: 40px 0 80px; }

        /* ─── QUESTION CARD ─── */
        .question-wrapper {
            max-width: 740px;
            margin: 0 auto;
        }

        .q-counter {
            font-family: 'Syne', sans-serif;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 8px;
        }

        .q-card {
            background: var(--card);
            border-radius: 20px;
            padding: 36px 36px 28px;
            box-shadow: 0 6px 30px rgba(91,79,255,0.10);
            border: 1px solid var(--border);
            margin-bottom: 24px;
            animation: slideIn 0.35s cubic-bezier(0.34,1.56,0.64,1) both;
        }
        @keyframes slideIn {
            from { opacity: 0; transform: translateX(30px); }
            to   { opacity: 1; transform: translateX(0); }
        }

        .q-text {
            font-family: 'Syne', sans-serif;
            font-size: 1.25rem;
            font-weight: 700;
            line-height: 1.45;
            color: var(--ink);
            margin-bottom: 28px;
        }

        /* ─── OPTIONS ─── */
        .options-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }
        @media (max-width: 540px) { .options-grid { grid-template-columns: 1fr; } }

        .option-btn {
            font-family: 'DM Sans', sans-serif;
            font-size: 0.92rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 18px;
            border-radius: 14px;
            border: 2px solid var(--border);
            background: var(--surface);
            color: var(--ink);
            cursor: pointer;
            transition: all 0.2s;
            text-align: left;
            width: 100%;
        }
        .option-btn:hover:not(:disabled) { border-color: var(--accent); background: #f0eeff; }
        .option-btn.selected { border-color: var(--accent); background: #ede9ff; color: var(--accent); font-weight: 600; }
        .option-btn.correct  { border-color: var(--accent3); background: #e8faf7; color: #008c6e; }
        .option-btn.wrong    { border-color: var(--accent2); background: #fff0f5; color: #c0244a; }
        .option-btn:disabled { cursor: default; }

        .option-letter {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 0.8rem;
            width: 28px; height: 28px;
            border-radius: 50%;
            background: var(--border);
            color: var(--muted);
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
            transition: all 0.2s;
        }
        .option-btn.selected .option-letter { background: var(--accent); color: #fff; }
        .option-btn.correct .option-letter  { background: var(--accent3); color: #fff; }
        .option-btn.wrong   .option-letter  { background: var(--accent2); color: #fff; }

        /* ─── NAV BUTTONS ─── */
        .quiz-nav {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 8px;
        }
        .btn-nav {
            font-family: 'Syne', sans-serif;
            font-size: 0.88rem;
            font-weight: 700;
            padding: 12px 28px;
            border-radius: 12px;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-prev { background: var(--border); color: var(--muted); }
        .btn-prev:hover { background: #dad8f7; color: var(--ink); }
        .btn-next { background: linear-gradient(135deg, var(--accent), #7c6fff); color: #fff; box-shadow: 0 4px 16px rgba(91,79,255,0.35); }
        .btn-next:hover { opacity: 0.88; transform: translateY(-1px); }
        .btn-submit { background: linear-gradient(135deg, var(--accent2), #ff7eb3); color: #fff; box-shadow: 0 4px 16px rgba(255,79,139,0.35); }
        .btn-submit:hover { opacity: 0.88; transform: translateY(-1px); }

        /* ─── QUESTION DOTS ─── */
        .q-dots {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
            max-width: 740px;
            margin: 0 auto 24px;
        }
        .q-dot {
            width: 32px; height: 32px;
            border-radius: 50%;
            border: 2px solid var(--border);
            background: var(--card);
            font-family: 'Syne', sans-serif;
            font-size: 0.72rem;
            font-weight: 700;
            color: var(--muted);
            cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            transition: all 0.2s;
        }
        .q-dot.answered { background: var(--accent); border-color: var(--accent); color: #fff; }
        .q-dot.current  { border-color: var(--accent); color: var(--accent); transform: scale(1.1); }

        /* ─── RESULT SCREEN ─── */
        .result-screen {
            max-width: 640px;
            margin: 0 auto;
            text-align: center;
            padding: 20px;
        }
        .result-ring {
            width: 160px; height: 160px;
            border-radius: 50%;
            background: conic-gradient(var(--accent) 0%, var(--accent) var(--pct, 0%), var(--border) var(--pct, 0%));
            margin: 0 auto 28px;
            display: flex; align-items: center; justify-content: center;
            position: relative;
        }
        .result-ring::after {
            content: '';
            position: absolute;
            width: 120px; height: 120px;
            background: var(--card);
            border-radius: 50%;
        }
        .result-ring-text {
            position: relative;
            z-index: 1;
            font-family: 'Syne', sans-serif;
            font-size: 2rem;
            font-weight: 800;
            color: var(--ink);
        }
        .result-screen h2 {
            font-family: 'Syne', sans-serif;
            font-size: 1.8rem;
            font-weight: 800;
            margin-bottom: 8px;
        }
        .result-screen p { color: var(--muted); margin-bottom: 28px; font-size: 1rem; }

        .result-detail-row {
            display: flex;
            gap: 16px;
            justify-content: center;
            margin-bottom: 28px;
            flex-wrap: wrap;
        }
        .result-detail-pill {
            background: var(--surface);
            border: 1.5px solid var(--border);
            border-radius: 50px;
            padding: 8px 20px;
            font-family: 'Syne', sans-serif;
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--ink);
        }
        .result-detail-pill span { color: var(--accent); }

        .btn-back-home {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            background: var(--ink);
            color: #fff;
            border: none;
            border-radius: 12px;
            padding: 13px 32px;
            font-size: 0.9rem;
            cursor: pointer;
            transition: 0.2s;
            margin-right: 10px;
        }
        .btn-back-home:hover { background: var(--accent); }
        .btn-retry {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            background: linear-gradient(135deg, var(--accent), #7c6fff);
            color: #fff;
            border: none;
            border-radius: 12px;
            padding: 13px 32px;
            font-size: 0.9rem;
            cursor: pointer;
            transition: 0.2s;
        }
        .btn-retry:hover { opacity: 0.85; }

        /* review */
        .review-card {
            background: var(--card);
            border-radius: 16px;
            border: 1px solid var(--border);
            padding: 24px;
            margin-top: 14px;
            text-align: left;
        }
        .review-card h6 { font-family: 'Syne', sans-serif; font-weight: 700; margin-bottom: 12px; }
        .review-opt {
            display: flex; align-items: center; gap: 10px;
            font-size: 0.88rem; margin-bottom: 6px; padding: 8px 12px; border-radius: 8px;
        }
        .review-opt.correct-ans { background: #e8faf7; color: #008c6e; }
        .review-opt.wrong-ans   { background: #fff0f5; color: #c0244a; }
        .review-opt .dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
        .review-opt.correct-ans .dot { background: var(--accent3); }
        .review-opt.wrong-ans   .dot { background: var(--accent2); }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:GlobalHeader ID="GlobalHeader1" runat="server"/>

        <!-- Hidden state fields -->
        <asp:HiddenField ID="hfCurrentQ" runat="server" Value="0"/>
        <asp:HiddenField ID="hfAnswers"  runat="server" Value=""/>
        <asp:HiddenField ID="hfQuizID"   runat="server" Value=""/>
        <asp:HiddenField ID="hfPhase"    runat="server" Value="quiz"/>

        <!-- ══ QUIZ PHASE ══ -->
        <asp:Panel ID="pnlQuiz" runat="server">
            <div class="quiz-hero">
                <div class="container quiz-hero-inner">
                    <asp:Button ID="btnBackQuiz" runat="server" Text="← Back to Assessments"
                        CssClass="btn-back-quiz" OnClick="btnBackHome_Click" />
                    <h1><asp:Label ID="lblQuizTitle" runat="server"/></h1>
                    <p><asp:Label ID="lblQuizDesc" runat="server"/></p>
                    <div class="quiz-progress-bar">
                        <div class="quiz-progress-fill" id="progressFill" style="width:0%"></div>
                    </div>
                </div>
            </div>

            <div class="container quiz-main">
                <!-- Dot nav -->
                <div class="q-dots" id="dotNav">
                    <asp:Repeater ID="rptDots" runat="server">
                        <ItemTemplate>
                            <div class="q-dot" id='dot<%# Container.ItemIndex %>' onclick="jumpTo(<%# Container.ItemIndex %>)">
                                <%# Container.ItemIndex + 1 %>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <!-- Question cards (all rendered, shown/hidden by JS) -->
                <div class="question-wrapper">
                    <asp:Repeater ID="rptQuestions" runat="server">
                        <ItemTemplate>
                            <div class="q-slide" id='slide<%# Container.ItemIndex %>' style="display:none">
                                <div class="q-counter">Question <%# Container.ItemIndex + 1 %> of <%# Eval("Total") %></div>
                                <div class="q-card">
                                    <div class="q-text"><%# Eval("QuestionText") %></div>
                                    <div class="options-grid">
                                        <button type="button" class="option-btn" onclick="selectOption(<%# Container.ItemIndex %>,'A',this)">
                                            <span class="option-letter">A</span><%# Eval("OptionA") %>
                                        </button>
                                        <button type="button" class="option-btn" onclick="selectOption(<%# Container.ItemIndex %>,'B',this)">
                                            <span class="option-letter">B</span><%# Eval("OptionB") %>
                                        </button>
                                        <button type="button" class="option-btn" onclick="selectOption(<%# Container.ItemIndex %>,'C',this)">
                                            <span class="option-letter">C</span><%# Eval("OptionC") %>
                                        </button>
                                        <button type="button" class="option-btn" onclick="selectOption(<%# Container.ItemIndex %>,'D',this)">
                                            <span class="option-letter">D</span><%# Eval("OptionD") %>
                                        </button>
                                    </div>
                                </div>
                                <div class="quiz-nav">
                                    <button type="button" class="btn-nav btn-prev" onclick="goToQ(<%# Container.ItemIndex - 1 %>)"
                                        <%# Container.ItemIndex == 0 ? "style='display:none'" : "" %>>← Prev</button>
                                    <asp:Button runat="server" ID="btnSubmitQ" CssClass="btn-nav btn-submit"
                                        Text="Submit Quiz" OnClick="btnSubmit_Click"
                                        Style='<%# ((bool)Eval("ViewOnly") == true) ? "display:none" :
                                                   ((Container.ItemIndex == (int)Eval("LastIndex")) ? "" : "display:none") %>'/>
                                    <button type="button" class="btn-nav btn-next" onclick="goToQ(<%# Container.ItemIndex + 1 %>)"
                                        <%# (Container.ItemIndex == (int)Eval("LastIndex")) ? "style='display:none'" : "" %>>Next →</button>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </asp:Panel>

        <!-- ══ RESULT PHASE ══ -->
        <asp:Panel ID="pnlResult" runat="server" Visible="false">
            <div class="quiz-hero" style="padding-bottom:60px;">
                <div class="container quiz-hero-inner">
                    <h1 style="color:#fff">Quiz Complete!</h1>
                </div>
            </div>
            <div class="container quiz-main">
                <div class="result-screen">
                    <div class="result-ring" id="resultRing">
                        <div class="result-ring-text">
                            <asp:Label ID="lblScorePct" runat="server"/>%
                        </div>
                    </div>
                    <h2><asp:Label ID="lblResultHeading" runat="server"/></h2>
                    <p><asp:Label ID="lblResultMsg" runat="server"/></p>

                    <div class="result-detail-row">
                        <div class="result-detail-pill">Score: <span><asp:Label ID="lblFinalScore" runat="server"/></span></div>
                        <div class="result-detail-pill">Correct: <span><asp:Label ID="lblCorrectCount" runat="server"/></span></div>
                        <div class="result-detail-pill">Wrong: <span><asp:Label ID="lblWrongCount" runat="server"/></span></div>
                    </div>

                    <asp:Button ID="btnBackHome" runat="server" Text="← Back to Assessments"
                        CssClass="btn-back-home" OnClick="btnBackHome_Click"/>
                    <asp:Button ID="btnRetry" runat="server" Text="Retry Quiz"
                        CssClass="btn-retry" OnClick="btnRetry_Click"/>

                    <!-- Review -->
                    <div style="margin-top:40px;text-align:left;">
                        <h5 style="font-family:'Syne',sans-serif;font-weight:700;margin-bottom:16px;">Review Answers</h5>
                        <asp:Repeater ID="rptReview" runat="server">
                            <ItemTemplate>
                                <div class="review-card">
                                    <h6>Q<%# Container.ItemIndex + 1 %>: <%# Eval("QuestionText") %></h6>
                                    <div class="review-opt <%# Eval("IsCorrect").ToString()=="True" ? "correct-ans" : "wrong-ans" %>">
                                        <div class="dot"></div>
                                        Your answer: <%# Eval("SelectedOption") %> — <%# Eval("SelectedText") %>
                                    </div>
                                    <asp:Panel ID="pnlCorrectShow" runat="server" Visible='<%# Eval("IsCorrect").ToString()!="True" %>'>
                                        <div class="review-opt correct-ans">
                                            <div class="dot"></div>
                                            Correct: <%# Eval("CorrectOption") %> — <%# Eval("CorrectText") %>
                                        </div>
                                    </asp:Panel>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </asp:Panel>

    </form>

    <script>
        var totalQ = parseInt('<asp:Literal ID="litTotalQ" runat="server" />') || 0;
        var answers = {};
        var currentQ = 0;

        window.addEventListener('DOMContentLoaded', function () {
            var phase = document.getElementById('<%= hfPhase.ClientID %>').value;
            if (phase === 'quiz') {
                initQuiz();
            }
        });

        function initQuiz() {
            var saved = document.getElementById('<%= hfAnswers.ClientID %>').value;
            if (saved) {
                try { answers = JSON.parse(saved); } catch(e) {}
            }

            Object.keys(answers).forEach(function(idx) {
                var btns = document.querySelectorAll('#slide' + idx + ' .option-btn');
                btns.forEach(function(btn) {
                    if (btn.textContent.trim().startsWith(answers[idx])) {
                        btn.classList.add('selected');
                    }
                });
                markDot(parseInt(idx), true);
            });

            var startQ = parseInt(document.getElementById('<%= hfCurrentQ.ClientID %>').value) || 0;
            showSlide(startQ);
        }

        function showSlide(idx) {
            document.querySelectorAll('.q-slide').forEach(function(s) { s.style.display = 'none'; });
            var slide = document.getElementById('slide' + idx);
            if (slide) slide.style.display = 'block';
            currentQ = idx;

            document.querySelectorAll('.q-dot').forEach(function(d, i) {
                d.classList.remove('current');
                if (i === idx) d.classList.add('current');
            });

            var pct = totalQ > 0 ? Math.round(((idx + 1) / totalQ) * 100) : 0;
            var fill = document.getElementById('progressFill');
            if (fill) fill.style.width = pct + '%';

            document.getElementById('<%= hfCurrentQ.ClientID %>').value = idx;
        }

        function goToQ(idx) {
            if (idx < 0 || idx >= totalQ) return;
            showSlide(idx);
        }

        function jumpTo(idx) { showSlide(idx); }

        function selectOption(qIdx, letter, btn) {
            var btns = btn.closest('.options-grid').querySelectorAll('.option-btn');
            btns.forEach(function(b) { b.classList.remove('selected'); });
            btn.classList.add('selected');
            answers[qIdx] = letter;
            markDot(qIdx, true);
            document.getElementById('<%= hfAnswers.ClientID %>').value = JSON.stringify(answers);
    }

    function markDot(idx, answered) {
        var dot = document.getElementById('dot' + idx);
        if (dot) {
            dot.classList.remove('current');
            if (answered) dot.classList.add('answered');
        }
    }
    </script>
</body>
</html>
