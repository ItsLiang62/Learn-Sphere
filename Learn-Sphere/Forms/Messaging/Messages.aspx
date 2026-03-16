<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Messages.aspx.cs" Inherits="Learn_Sphere.Forms.Messaging.Messages" EnableEventValidation="false" %>
<%@ Register TagPrefix="uc" TagName="GlobalHeader" Src="~/Shared/GlobalHeader.ascx" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Messages — LearnSphere</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&display=swap" rel="stylesheet" />

    <style>
        :root {
            --ink: #0d0d1a; --surface: #f4f3ff; --card: #ffffff;
            --accent: #5b4fff; --accent2: #ff4f8b; --accent3: #00d4aa;
            --muted: #7b7a99; --border: #e4e2ff;
            --shadow: 0 4px 24px rgba(91,79,255,0.10);
            --bubble-me: #5b4fff; --bubble-them: #f0eeff;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Roboto', sans-serif; background: var(--surface); color: var(--ink); min-height: 100vh; }

        .hero {
            background: linear-gradient(135deg, #0d0d1a 0%, #1a1040 60%, #2d1260 100%);
            padding: 48px 0 32px; position: relative; overflow: hidden;
        }
        .hero::before {
            content: ''; position: absolute; inset: 0;
            background: radial-gradient(ellipse at 20% 80%, rgba(91,79,255,0.3) 0%, transparent 60%),
                        radial-gradient(ellipse at 80% 20%, rgba(255,79,139,0.2) 0%, transparent 55%);
        }
        .hero-inner { position: relative; z-index: 1; }
        .hero h1 { font-size: clamp(1.6rem,4vw,2.6rem); font-weight: 900; color: #fff; letter-spacing: -0.5px; }
        .hero p   { color: rgba(255,255,255,0.5); font-size: 0.95rem; margin-top: 6px; font-weight: 300; }

        /* Layout */
        .msg-wrap { padding: 28px 0 60px; }
        .msg-layout {
            display: grid; grid-template-columns: 300px 1fr;
            height: calc(100vh - 220px); min-height: 500px;
            background: var(--card); border-radius: 20px;
            border: 1px solid var(--border); box-shadow: var(--shadow); overflow: hidden;
        }

        /* Users panel */
        .users-panel { border-right: 1px solid var(--border); display: flex; flex-direction: column; overflow: hidden; }
        .users-header { padding: 18px 16px 12px; border-bottom: 1px solid var(--border); flex-shrink: 0; }
        .users-header h5 { font-size: 0.9rem; font-weight: 700; margin-bottom: 10px; }
        .search-box { position: relative; }
        .search-box i { position: absolute; left: 10px; top: 50%; transform: translateY(-50%); color: var(--muted); font-size: 0.8rem; }
        .search-box input { font-family: 'Roboto', sans-serif; font-size: 0.83rem; width: 100%; padding: 8px 10px 8px 30px; border: 1.5px solid var(--border); border-radius: 9px; background: var(--surface); color: var(--ink); }
        .search-box input:focus { outline: none; border-color: var(--accent); }

        .role-tabs { display: flex; gap: 4px; padding: 8px 16px; border-bottom: 1px solid var(--border); flex-shrink: 0; }
        .role-tab { font-family: 'Roboto', sans-serif; font-size: 0.7rem; font-weight: 700; padding: 4px 10px; border-radius: 50px; border: 1.5px solid var(--border); background: transparent; color: var(--muted); cursor: pointer; transition: all 0.15s; }
        .role-tab.active { background: var(--accent); border-color: var(--accent); color: #fff; }
        .role-tab:hover:not(.active) { border-color: var(--accent); color: var(--accent); }

        .users-list { flex: 1; overflow-y: auto; }
        .users-list::-webkit-scrollbar { width: 3px; }
        .users-list::-webkit-scrollbar-thumb { background: var(--border); border-radius: 3px; }

        .user-btn {
            display: flex; align-items: center; gap: 10px;
            padding: 11px 16px; width: 100%; text-align: left;
            background: none; border: none; cursor: pointer; transition: background 0.12s;
        }
        .user-btn:hover  { background: var(--surface); }
        .user-btn.active { background: #ede9ff; }
        .user-btn.hidden { display: none !important; }

        .u-av {
            width: 38px; height: 38px; border-radius: 50%; flex-shrink: 0;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.95rem; color: #fff;
        }
        .u-av.learner       { background: linear-gradient(135deg,#00d4aa,#00b894); }
        .u-av.educator      { background: linear-gradient(135deg,#5b4fff,#7c6fff); }
        .u-av.administrator { background: linear-gradient(135deg,#ff4f8b,#ff8ab3); }

        .u-info { flex: 1; min-width: 0; }
        .u-info strong { font-size: 0.85rem; font-weight: 700; display: block; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .u-info span   { font-size: 0.73rem; color: var(--muted); }
        .u-unread { width: 19px; height: 19px; border-radius: 50%; background: var(--accent2); color: #fff; font-size: 0.65rem; font-weight: 700; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }

        /* Chat panel */
        .chat-panel { display: flex; flex-direction: column; overflow: hidden; }

        .chat-empty { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: var(--muted); text-align: center; padding: 40px; }
        .chat-empty i  { font-size: 2.8rem; color: var(--border); margin-bottom: 14px; display: block; }
        .chat-empty h5 { font-weight: 700; color: var(--ink); margin-bottom: 5px; font-size: 1rem; }
        .chat-empty p  { font-size: 0.85rem; }

        .chat-active { display: none; flex-direction: column; flex: 1; overflow: hidden; }

        .chat-header { padding: 14px 20px; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 10px; flex-shrink: 0; }
        .chat-header-info { flex: 1; min-width: 0; }
        .chat-header-info strong { font-size: 0.92rem; font-weight: 700; display: block; }
        .chat-header-info span   { font-size: 0.75rem; color: var(--muted); }
        .btn-view-prof { font-family: 'Roboto', sans-serif; font-size: 0.75rem; font-weight: 700; background: var(--surface); border: 1.5px solid var(--border); color: var(--muted); border-radius: 8px; padding: 6px 12px; cursor: pointer; transition: 0.15s; text-decoration: none; display: inline-flex; align-items: center; gap: 5px; }
        .btn-view-prof:hover { border-color: var(--accent); color: var(--accent); }

        .chat-msgs { flex: 1; overflow-y: auto; padding: 18px 20px; display: flex; flex-direction: column; gap: 8px; }
        .chat-msgs::-webkit-scrollbar { width: 3px; }
        .chat-msgs::-webkit-scrollbar-thumb { background: var(--border); border-radius: 3px; }

        .msg-row { display: flex; align-items: flex-end; gap: 7px; }
        .msg-row.mine   { flex-direction: row-reverse; }
        .msg-av { width: 26px; height: 26px; border-radius: 50%; flex-shrink: 0; display: flex; align-items: center; justify-content: center; font-size: 0.65rem; font-weight: 700; color: #fff; }
        .msg-wrap-inner { max-width: 62%; display: flex; flex-direction: column; }
        .msg-row.mine   .msg-wrap-inner { align-items: flex-end; }
        .msg-row.theirs .msg-wrap-inner { align-items: flex-start; }
        .msg-bubble { font-size: 0.875rem; padding: 9px 13px; border-radius: 16px; line-height: 1.45; word-break: break-word; }
        .msg-row.mine   .msg-bubble { background: var(--bubble-me); color: #fff; border-bottom-right-radius: 3px; }
        .msg-row.theirs .msg-bubble { background: var(--bubble-them); color: var(--ink); border-bottom-left-radius: 3px; }
        .msg-meta { font-size: 0.65rem; color: var(--muted); margin-top: 3px; padding: 0 3px; }
        .date-sep { text-align: center; margin: 6px 0; }
        .date-sep span { font-size: 0.7rem; font-weight: 600; color: var(--muted); background: var(--surface); border: 1px solid var(--border); border-radius: 50px; padding: 2px 10px; }

        .chat-input-area { padding: 14px 20px; border-top: 1px solid var(--border); display: flex; gap: 8px; align-items: flex-end; flex-shrink: 0; }
        .chat-input { font-family: 'Roboto', sans-serif; font-size: 0.88rem; flex: 1; padding: 10px 14px; border: 1.5px solid var(--border); border-radius: 12px; background: var(--surface); color: var(--ink); resize: none; max-height: 110px; overflow-y: auto; line-height: 1.4; }
        .chat-input:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px rgba(91,79,255,0.08); }
        .btn-send { font-family: 'Roboto', sans-serif; font-size: 0.83rem; font-weight: 700; background: linear-gradient(135deg,var(--accent),#7c6fff); color: #fff; border: none; border-radius: 10px; padding: 10px 18px; cursor: pointer; display: flex; align-items: center; gap: 6px; flex-shrink: 0; transition: 0.18s; }
        .btn-send:hover { opacity: 0.88; }
        .btn-send:disabled { opacity: 0.4; cursor: not-allowed; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:GlobalHeader ID="GlobalHeader1" runat="server" />

        <div class="hero">
            <div class="container hero-inner">
                <h1><i class="fa-solid fa-envelope me-3" style="color:var(--accent)"></i>Messages</h1>
                <p>Connect with learners, educators, and admins across LearnSphere</p>
            </div>
        </div>

        <div class="container msg-wrap">
            <div class="msg-layout">

                <!-- USERS PANEL -->
                <div class="users-panel">
                    <div class="users-header">
                        <h5><i class="fa-solid fa-users me-2" style="color:var(--accent)"></i>Users</h5>
                        <div class="search-box">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <input type="text" id="searchUsers" placeholder="Search…" oninput="filterUsers()" />
                        </div>
                    </div>
                    <div class="role-tabs">
                        <button type="button" class="role-tab active" onclick="setRoleFilter(this,'all')">All</button>
                        <button type="button" class="role-tab" onclick="setRoleFilter(this,'learner')">Learners</button>
                        <button type="button" class="role-tab" onclick="setRoleFilter(this,'educator')">Educators</button>
                        <button type="button" class="role-tab" onclick="setRoleFilter(this,'administrator')">Admins</button>
                    </div>
                    <div class="users-list" id="usersList">
                        <asp:Repeater ID="rptUsers" runat="server">
                            <ItemTemplate>
                                <button type="button" class="user-btn"
                                    data-uid="<%# Eval("UserID") %>"
                                    data-name="<%# Eval("DisplayName") %>"
                                    data-role="<%# Eval("Role").ToString().ToLower() %>"
                                    data-initial="<%# Eval("Initial") %>"
                                    onclick="selectUser(this)">
                                    <div class="u-av <%# Eval("Role").ToString().ToLower() %>"><%# Eval("Initial") %></div>
                                    <div class="u-info">
                                        <strong><%# Eval("DisplayName") %></strong>
                                        <span><%# Eval("Role") %></span>
                                    </div>
                                    <%# Convert.ToInt32(Eval("UnreadCount")) > 0
                                        ? "<div class='u-unread'>" + Eval("UnreadCount") + "</div>"
                                        : "" %>
                                </button>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>

                <!-- CHAT PANEL -->
                <div class="chat-panel">

                    <div class="chat-empty" id="chatEmpty">
                        <i class="fa-regular fa-comments"></i>
                        <h5>No conversation selected</h5>
                        <p>Pick a user on the left to start chatting.</p>
                    </div>

                    <div class="chat-active" id="chatActive">
                        <div class="chat-header">
                            <div class="u-av" id="hdrAvatar">?</div>
                            <div class="chat-header-info">
                                <strong id="hdrName">—</strong>
                                <span id="hdrRole">—</span>
                            </div>
                            <a id="lnkProfile" href="#" class="btn-view-prof">
                                <i class="fa-solid fa-user"></i> View Profile
                            </a>
                        </div>
                        <div class="chat-msgs" id="chatMsgs"></div>
                        <div class="chat-input-area">
                            <textarea id="msgInput" class="chat-input" rows="1"
                                placeholder="Type a message… (Enter to send)"
                                oninput="autoResize(this)"
                                onkeydown="handleKey(event)"></textarea>
                            <button type="button" class="btn-send" id="btnSendUI" onclick="doSend()" disabled>
                                <i class="fa-solid fa-paper-plane"></i> Send
                            </button>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <asp:HiddenField ID="hfAction"        runat="server" Value="" />
        <asp:HiddenField ID="hfTargetID"      runat="server" Value="" />
        <asp:HiddenField ID="hfContent"       runat="server" Value="" />
        <asp:HiddenField ID="hfCurrentUserID" runat="server" Value="" />
        <asp:HiddenField ID="hfMsgJson"       runat="server" Value="" />
        <asp:HiddenField ID="hfUnreadJson"    runat="server" Value="" />
        <asp:HiddenField ID="hfLoadedFor"     runat="server" Value="" />

        <asp:Button ID="btnSubmit" runat="server" Style="display:none"
            OnClick="btnSubmit_Click" />

    </form>

    <script>
        var ME = parseInt('<%= Session["UserID"] ?? "0" %>') || 0;

        var selectedUID  = 0;
        var selectedRole = '';
        var roleFilter   = 'all';

        function hf(id)     { return document.getElementById(id); }
        function val(id)    { return hf(id) ? hf(id).value : ''; }
        function set(id, v) { if (hf(id)) hf(id).value = v; }

        var HF_ACTION  = '<%= hfAction.ClientID %>';
        var HF_TARGET  = '<%= hfTargetID.ClientID %>';
        var HF_CONTENT = '<%= hfContent.ClientID %>';
        var HF_MSGJSON = '<%= hfMsgJson.ClientID %>';
        var HF_UNREAD  = '<%= hfUnreadJson.ClientID %>';
        var HF_LOADED  = '<%= hfLoadedFor.ClientID %>';

        window.addEventListener('DOMContentLoaded', function () {
            var loadedFor = val(HF_LOADED);
            if (loadedFor && parseInt(loadedFor) > 0) {
                var btn = document.querySelector('[data-uid="' + loadedFor + '"]');
                if (btn) {
                    openChatUI(btn);
                    renderMessages(safeParseJSON(val(HF_MSGJSON)));
                }
            }

            hf('msgInput').addEventListener('input', function () {
                hf('btnSendUI').disabled = this.value.trim() === '';
            });
        });

        function filterUsers() { applyFilter(); }
        function setRoleFilter(btn, role) {
            document.querySelectorAll('.role-tab').forEach(function (b) { b.classList.remove('active'); });
            btn.classList.add('active');
            roleFilter = role;
            applyFilter();
        }
        function applyFilter() {
            var kw = hf('searchUsers').value.toLowerCase().trim();
            document.querySelectorAll('.user-btn').forEach(function (b) {
                var name = (b.getAttribute('data-name') || '').toLowerCase();
                var role = (b.getAttribute('data-role') || '').toLowerCase();
                var ok   = (roleFilter === 'all' || role === roleFilter) && name.includes(kw);
                b.classList.toggle('hidden', !ok);
            });
        }

        function selectUser(btn) {
            document.querySelectorAll('.user-btn').forEach(function (b) { b.classList.remove('active'); });
            btn.classList.add('active');
            selectedUID  = parseInt(btn.getAttribute('data-uid'));
            selectedRole = btn.getAttribute('data-role');
            set(HF_ACTION,  'load');
            set(HF_TARGET,  selectedUID);
            set(HF_CONTENT, '');
            hf('<%= btnSubmit.ClientID %>').click();
        }

        function doSend() {
            var txt = hf('msgInput').value.trim();
            if (!txt || !selectedUID) return;
            set(HF_ACTION,  'send');
            set(HF_TARGET,  selectedUID);
            set(HF_CONTENT, txt);
            hf('<%= btnSubmit.ClientID %>').click();
    }

    function handleKey(e) {
        if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); doSend(); }
    }
    function autoResize(el) {
        el.style.height = 'auto';
        el.style.height = Math.min(el.scrollHeight, 110) + 'px';
    }

    function openChatUI(btn) {
        selectedUID = parseInt(btn.getAttribute('data-uid'));
        selectedRole = btn.getAttribute('data-role');
        var name = btn.getAttribute('data-name');
        var initial = btn.getAttribute('data-initial');

        var av = hf('hdrAvatar');
        av.textContent = initial;
        av.className = 'u-av ' + selectedRole;
        hf('hdrName').textContent = name;
        hf('hdrRole').textContent = selectedRole.charAt(0).toUpperCase() + selectedRole.slice(1);

        // Same tab navigation — no target="_blank"
        hf('lnkProfile').href = '/Forms/Profile/ViewProfile.aspx?userID=' + selectedUID;

        hf('chatEmpty').style.display = 'none';
        hf('chatActive').style.display = 'flex';
    }

    function renderMessages(msgs) {
        var c = hf('chatMsgs');
        c.innerHTML = '';
        var lastDate = '';

        (msgs || []).forEach(function(m) {
            if (m.DateLabel !== lastDate) {
                var sep = document.createElement('div');
                sep.className = 'date-sep';
                sep.innerHTML = '<span>' + esc(m.DateLabel) + '</span>';
                c.appendChild(sep);
                lastDate = m.DateLabel;
            }
            var mine = (m.SenderID === ME);
            var row = document.createElement('div');
            row.className = 'msg-row ' + (mine ? 'mine' : 'theirs');

            var av = document.createElement('div');
            av.className = 'msg-av ' + (m.SenderRole || 'learner').toLowerCase();
            av.textContent = (m.SenderName || '?')[0].toUpperCase();

            var wrap = document.createElement('div'); wrap.className = 'msg-wrap-inner';
            var bubble = document.createElement('div'); bubble.className = 'msg-bubble'; bubble.textContent = m.Content;
            var meta = document.createElement('div'); meta.className = 'msg-meta'; meta.textContent = m.TimeLabel;
            wrap.appendChild(bubble);
            wrap.appendChild(meta);

            if (!mine) row.appendChild(av);
            row.appendChild(wrap);
            if (mine) row.appendChild(av);
            c.appendChild(row);
        });

        c.scrollTop = c.scrollHeight;
    }

    function safeParseJSON(s) {
        try { return JSON.parse(s || '[]'); } catch (e) { return []; }
    }
    function esc(s) {
        var d = document.createElement('div');
        d.textContent = s;
        return d.innerHTML;
    }
    </script>
</body>
</html>
