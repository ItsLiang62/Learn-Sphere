using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace Learn_Sphere.Forms.Messaging
{
    public partial class Messages : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("~/Forms/Auth/Login.aspx");

            int userID = Convert.ToInt32(Session["UserID"]);
            hfCurrentUserID.Value = userID.ToString();

            // Always reload the user list (keeps unread counts fresh after every postback)
            LoadUsers(userID);

            // On first load there is nothing else to do
            if (!IsPostBack) return;

            // btnSubmit_Click handles the postback — nothing extra needed here
        }

        // ── button click (load or send) ────────────────────────────────────────────
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int userID = Convert.ToInt32(Session["UserID"]);
            string action = hfAction.Value;
            int targetID = 0;
            int.TryParse(hfTargetID.Value, out targetID);

            if (targetID == 0) return;

            if (action == "send")
            {
                string content = (hfContent.Value ?? "").Trim();
                if (!string.IsNullOrEmpty(content))
                {
                    if (content.Length > 2000) content = content.Substring(0, 2000);
                    DatabaseHelper.ExecuteNonQuery(
                        "INSERT INTO Messages (SenderID,ReceiverID,MessageContent,DateSent,IsRead) VALUES (@S,@R,@C,GETDATE(),0)",
                        new[]
                        {
                            new SqlParameter("@S", userID),
                            new SqlParameter("@R", targetID),
                            new SqlParameter("@C", content)
                        });
                    string senderName = Session["Username"] != null ? Session["Username"].ToString() : "Someone";

                    DatabaseHelper.ExecuteNonQuery(
                        "INSERT INTO Notifications (UserID, NotificationContent, DateCreated, IsRead) VALUES (@UserID, @Content, GETDATE(), 0)",
                        new[]
                        {
                            new SqlParameter("@UserID", targetID),
                            new SqlParameter("@Content", senderName + " sent you a new private message.")
                        });
                }
            }

            // Both load and send end by reading the conversation
            LoadConversation(userID, targetID);

            // Clear action so a browser refresh doesn't re-submit
            hfAction.Value = "";
            hfContent.Value = "";
        }

        // ── load conversation into hfMsgJson ──────────────────────────────────────
        private void LoadConversation(int me, int them)
        {
            // Mark messages from them → me as read
            DatabaseHelper.ExecuteNonQuery(
                "UPDATE Messages SET IsRead=1 WHERE SenderID=@T AND ReceiverID=@M AND IsRead=0",
                new[] { new SqlParameter("@T", them), new SqlParameter("@M", me) });

            string query = @"
               SELECT m.MessageID, m.SenderID, m.MessageContent AS Content, m.DateSent AS SentAt,
               su.Username AS SenderUsername,
               su.Role AS SenderRole,
               ISNULL(sp.FullName,'') AS SenderFullName
               FROM Messages m
               INNER JOIN Users su ON su.UserID = m.SenderID
               LEFT JOIN Profiles sp ON sp.UserID = m.SenderID
               WHERE (m.SenderID=@M AND m.ReceiverID=@T)
               OR (m.SenderID=@T AND m.ReceiverID=@M)
               ORDER BY m.DateSent ASC";

            DataTable dt = DatabaseHelper.ExecuteSelect(query,
                new[] { new SqlParameter("@M", me), new SqlParameter("@T", them) });

            var msgs = new List<object>();
            foreach (DataRow row in dt.Rows)
            {
                DateTime sent = Convert.ToDateTime(row["SentAt"]);
                string fullName = row["SenderFullName"].ToString().Trim();
                string uname = row["SenderUsername"].ToString();
                string dispName = string.IsNullOrEmpty(fullName) ? uname : fullName;

                string dateLabel;
                if (sent.Date == DateTime.Today) dateLabel = "Today";
                else if (sent.Date == DateTime.Today.AddDays(-1)) dateLabel = "Yesterday";
                else dateLabel = sent.ToString("MMM dd, yyyy");

                msgs.Add(new
                {
                    SenderID = Convert.ToInt32(row["SenderID"]),
                    SenderName = dispName,
                    SenderRole = row["SenderRole"].ToString(),
                    Content = row["Content"].ToString(),
                    DateLabel = dateLabel,
                    TimeLabel = sent.ToString("h:mm tt")
                });
            }

            hfMsgJson.Value = new JavaScriptSerializer().Serialize(msgs);
            hfLoadedFor.Value = them.ToString();
        }

        // ── load user list (always fresh) ──────────────────────────────────────────
        private void LoadUsers(int me)
        {
            string query = @"
                SELECT  u.UserID,
                        u.Username,
                        u.Role,
                        ISNULL(p.FullName,'') AS FullName,
                        ISNULL((
                            SELECT COUNT(*)
                            FROM   Messages msg
                            WHERE  msg.ReceiverID = @Me
                               AND msg.SenderID   = u.UserID
                               AND msg.IsRead     = 0
                        ), 0) AS UnreadCount
                FROM    Users u
                LEFT JOIN Profiles p ON p.UserID = u.UserID
                WHERE   u.UserID <> @Me
                ORDER BY
                    CASE WHEN EXISTS (
                        SELECT 1 FROM Messages msg
                        WHERE  msg.ReceiverID=@Me AND msg.SenderID=u.UserID AND msg.IsRead=0
                    ) THEN 0 ELSE 1 END,
                    u.Role, u.Username";

            DataTable dt = DatabaseHelper.ExecuteSelect(query,
                new[] { new SqlParameter("@Me", me) });

            dt.Columns.Add("DisplayName", typeof(string));
            dt.Columns.Add("Initial", typeof(string));

            foreach (DataRow row in dt.Rows)
            {
                string full = row["FullName"].ToString().Trim();
                string uname = row["Username"].ToString();
                string disp = string.IsNullOrEmpty(full) ? uname : full + " (" + uname + ")";
                row["DisplayName"] = disp;
                row["Initial"] = disp.Length > 0 ? disp[0].ToString().ToUpper() : "?";
            }

            rptUsers.DataSource = dt;
            rptUsers.DataBind();
        }
    }
}
