USE Learn_Sphere;
GO
-- ═══════════════════════════════════════════════════════════════════════════
--  Learn_Sphere  —  Full Database Script
--  Original tables kept, new Forum/Report/Notification/Block tables added
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Drop views if they exist ──────────────────────────────────────────────
IF OBJECT_ID('dbo.vw_LearnerAttemptSummary', 'V') IS NOT NULL DROP VIEW dbo.vw_LearnerAttemptSummary;
IF OBJECT_ID('dbo.vw_EducatorQuizStats',     'V') IS NOT NULL DROP VIEW dbo.vw_EducatorQuizStats;
GO

-- ── Drop new tables first (FK-safe order) ────────────────────────────────
IF OBJECT_ID('dbo.Notifications',    'U') IS NOT NULL DROP TABLE dbo.Notifications;
IF OBJECT_ID('dbo.Reports',          'U') IS NOT NULL DROP TABLE dbo.Reports;
IF OBJECT_ID('dbo.ForumComments',    'U') IS NOT NULL DROP TABLE dbo.ForumComments;
IF OBJECT_ID('dbo.ForumPosts',       'U') IS NOT NULL DROP TABLE dbo.ForumPosts;
IF OBJECT_ID('dbo.UserBlocks',       'U') IS NOT NULL DROP TABLE dbo.UserBlocks;

-- ── Drop original tables in reverse dependency order ─────────────────────
IF OBJECT_ID('dbo.Messages',              'U') IS NOT NULL DROP TABLE dbo.Messages;
IF OBJECT_ID('dbo.QuizAnswers',           'U') IS NOT NULL DROP TABLE dbo.QuizAnswers;
IF OBJECT_ID('dbo.QuizAttempts',          'U') IS NOT NULL DROP TABLE dbo.QuizAttempts;
IF OBJECT_ID('dbo.SavedQuizzes',          'U') IS NOT NULL DROP TABLE dbo.SavedQuizzes;
IF OBJECT_ID('dbo.QuizQuestions',         'U') IS NOT NULL DROP TABLE dbo.QuizQuestions;
IF OBJECT_ID('dbo.Quizzes',               'U') IS NOT NULL DROP TABLE dbo.Quizzes;
IF OBJECT_ID('dbo.EducatorApplications',  'U') IS NOT NULL DROP TABLE dbo.EducatorApplications;
IF OBJECT_ID('dbo.Profiles',              'U') IS NOT NULL DROP TABLE dbo.Profiles;
IF OBJECT_ID('dbo.Users',                 'U') IS NOT NULL DROP TABLE dbo.Users;
GO


-- ═══════════════════════════════════════════════════════════════════════════
--  CORE TABLES
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Users ─────────────────────────────────────────────────────────────────
CREATE TABLE dbo.Users (
    UserID         INT           IDENTITY(1,1) PRIMARY KEY,
    Username       NVARCHAR(50)  NOT NULL UNIQUE,
    Email          NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash   NVARCHAR(255) NOT NULL,
    Role           NVARCHAR(20)  NOT NULL,   -- 'Learner' | 'Educator' | 'Administrator'
    DateRegistered DATETIME      NOT NULL DEFAULT GETDATE()
);
GO

-- ── Profiles ──────────────────────────────────────────────────────────────
CREATE TABLE dbo.Profiles (
    ProfileID    INT           IDENTITY(1,1) PRIMARY KEY,
    UserID       INT           NOT NULL UNIQUE,
    FullName     NVARCHAR(100) NULL,
    Bio          NVARCHAR(500) NULL,
    ProfileImage NVARCHAR(255) NULL,
    CONSTRAINT FK_Profiles_Users
        FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID) ON DELETE CASCADE
);
GO

-- ── Educator Applications ─────────────────────────────────────────────────
CREATE TABLE dbo.EducatorApplications (
    ApplicationID      INT           IDENTITY(1,1) PRIMARY KEY,
    Username           NVARCHAR(50)  NOT NULL,
    Email              NVARCHAR(100) NOT NULL,
    PasswordHash       NVARCHAR(200) NOT NULL,
    Qualification      NVARCHAR(200) NOT NULL,
    PortfolioLink      NVARCHAR(300) NULL,
    VerificationStatus NVARCHAR(20)  NOT NULL DEFAULT 'Pending',  -- 'Pending' | 'Approved' | 'Rejected'
    DateSubmitted      DATETIME      NOT NULL DEFAULT GETDATE()
);
GO

CREATE UNIQUE INDEX UQ_PendingApplication
    ON dbo.EducatorApplications (Email, Username)
    WHERE VerificationStatus = 'Pending';
GO


-- ═══════════════════════════════════════════════════════════════════════════
--  ASSESSMENT TABLES
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Quizzes ───────────────────────────────────────────────────────────────
CREATE TABLE dbo.Quizzes (
    QuizID      INT           IDENTITY(1,1) PRIMARY KEY,
    Title       NVARCHAR(200) NOT NULL,
    Description NVARCHAR(500) NULL,
    EducatorID  INT           NOT NULL,
    DateCreated DATETIME      NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Quizzes_Educator
        FOREIGN KEY (EducatorID) REFERENCES dbo.Users(UserID)
);
GO

-- ── Quiz Questions ────────────────────────────────────────────────────────
CREATE TABLE dbo.QuizQuestions (
    QuestionID    INT           IDENTITY(1,1) PRIMARY KEY,
    QuizID        INT           NOT NULL,
    QuestionText  NVARCHAR(500) NOT NULL,
    OptionA       NVARCHAR(255) NOT NULL,
    OptionB       NVARCHAR(255) NOT NULL,
    OptionC       NVARCHAR(255) NOT NULL,
    OptionD       NVARCHAR(255) NOT NULL,
    CorrectOption CHAR(1)       NOT NULL,   -- 'A' | 'B' | 'C' | 'D'
    CONSTRAINT FK_QuizQuestions_Quiz
        FOREIGN KEY (QuizID) REFERENCES dbo.Quizzes(QuizID) ON DELETE CASCADE
);
GO

-- ── Saved Quizzes ─────────────────────────────────────────────────────────
CREATE TABLE dbo.SavedQuizzes (
    SavedID   INT      IDENTITY(1,1) PRIMARY KEY,
    UserID    INT      NOT NULL,
    QuizID    INT      NOT NULL,
    SavedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_SavedQuizzes_User
        FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID) ON DELETE CASCADE,
    CONSTRAINT FK_SavedQuizzes_Quiz
        FOREIGN KEY (QuizID) REFERENCES dbo.Quizzes(QuizID) ON DELETE CASCADE,
    CONSTRAINT UQ_SavedQuiz UNIQUE (UserID, QuizID)
);
GO

-- ── Quiz Attempts ─────────────────────────────────────────────────────────
CREATE TABLE dbo.QuizAttempts (
    AttemptID   INT      IDENTITY(1,1) PRIMARY KEY,
    QuizID      INT      NOT NULL,
    LearnerID   INT      NOT NULL,
    Score       INT      NOT NULL DEFAULT 0,
    AttemptDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_QuizAttempts_Quiz
        FOREIGN KEY (QuizID) REFERENCES dbo.Quizzes(QuizID),
    CONSTRAINT FK_QuizAttempts_Learner
        FOREIGN KEY (LearnerID) REFERENCES dbo.Users(UserID)
);
GO

-- ── Quiz Answers ──────────────────────────────────────────────────────────
CREATE TABLE dbo.QuizAnswers (
    AnswerID       INT     IDENTITY(1,1) PRIMARY KEY,
    AttemptID      INT     NOT NULL,
    QuestionID     INT     NOT NULL,
    SelectedOption CHAR(1) NULL,
    IsCorrect      BIT     NOT NULL DEFAULT 0,
    CONSTRAINT FK_QuizAnswers_Attempt
        FOREIGN KEY (AttemptID) REFERENCES dbo.QuizAttempts(AttemptID) ON DELETE CASCADE,
    CONSTRAINT FK_QuizAnswers_Question
        FOREIGN KEY (QuestionID) REFERENCES dbo.QuizQuestions(QuestionID)
);
GO


-- ═══════════════════════════════════════════════════════════════════════════
--  MESSAGING TABLE
-- ═══════════════════════════════════════════════════════════════════════════

CREATE TABLE dbo.Messages (
    MessageID      INT           IDENTITY(1,1) PRIMARY KEY,
    SenderID       INT           NOT NULL,
    ReceiverID     INT           NOT NULL,
    MessageContent NVARCHAR(MAX) NOT NULL,
    DateSent       DATETIME      NOT NULL DEFAULT GETDATE(),
    IsRead         BIT           NOT NULL DEFAULT 0,
    CONSTRAINT FK_Messages_Sender
        FOREIGN KEY (SenderID) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_Messages_Receiver
        FOREIGN KEY (ReceiverID) REFERENCES dbo.Users(UserID)
);
GO


-- ═══════════════════════════════════════════════════════════════════════════
--  FORUM / MODERATION TABLES  (NEWLY ADDED)
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Forum Posts ───────────────────────────────────────────────────────────
CREATE TABLE dbo.ForumPosts (
    PostID           INT            IDENTITY(1,1) PRIMARY KEY,
    UserID           INT            NOT NULL,
    Title            NVARCHAR(200)  NOT NULL,
    Content          NVARCHAR(MAX)  NOT NULL,
    DatePosted       DATETIME       NOT NULL DEFAULT GETDATE(),
    IsPinned         BIT            NOT NULL DEFAULT 0,
    IsDeleted        BIT            NOT NULL DEFAULT 0,
    DeletedByAdminID INT            NULL,
    DeletedDate      DATETIME       NULL,
    CONSTRAINT FK_ForumPosts_User
        FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_ForumPosts_Admin
        FOREIGN KEY (DeletedByAdminID) REFERENCES dbo.Users(UserID)
);
GO

-- ── Forum Comments ────────────────────────────────────────────────────────
CREATE TABLE dbo.ForumComments (
    CommentID        INT            IDENTITY(1,1) PRIMARY KEY,
    PostID           INT            NOT NULL,
    UserID           INT            NOT NULL,
    CommentText      NVARCHAR(MAX)  NOT NULL,
    DateCommented    DATETIME       NOT NULL DEFAULT GETDATE(),
    IsDeleted        BIT            NOT NULL DEFAULT 0,
    DeletedByAdminID INT            NULL,
    DeletedDate      DATETIME       NULL,
    CONSTRAINT FK_ForumComments_Post
        FOREIGN KEY (PostID) REFERENCES dbo.ForumPosts(PostID) ON DELETE CASCADE,
    CONSTRAINT FK_ForumComments_User
        FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_ForumComments_Admin
        FOREIGN KEY (DeletedByAdminID) REFERENCES dbo.Users(UserID)
);
GO

-- ── Reports ───────────────────────────────────────────────────────────────
CREATE TABLE Reports (
    ReportID INT IDENTITY(1,1) PRIMARY KEY,

    ReporterUserID INT NOT NULL,
    ReportedPostID INT NULL,
    ReportedCommentID INT NULL,

    ReportType NVARCHAR(50) NOT NULL,  -- Post / Comment
    Reason NVARCHAR(255) NOT NULL,
    Explanation NVARCHAR(MAX) NULL,

    ReportStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending',

    DateCreated DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (ReporterUserID) REFERENCES Users(UserID),
    FOREIGN KEY (ReportedPostID) REFERENCES ForumPosts(PostID),
    FOREIGN KEY (ReportedCommentID) REFERENCES ForumComments(CommentID),

    CONSTRAINT CK_Reports_Type CHECK (ReportType IN ('Post', 'Comment')),

    CONSTRAINT CK_Reports_Status CHECK 
    (ReportStatus IN ('Pending', 'ReviewedOnly', 'PostDeleted', 'CommentDeleted'))
);
GO

-- ── User Blocks ───────────────────────────────────────────────────────────
CREATE TABLE dbo.UserBlocks (
    BlockID           INT            IDENTITY(1,1) PRIMARY KEY,
    UserID            INT            NOT NULL,
    BlockReason       NVARCHAR(255)  NOT NULL,
    BlockDate         DATETIME       NOT NULL DEFAULT GETDATE(),
    BlockedByAdminID  INT            NOT NULL,
    IsActive          BIT            NOT NULL DEFAULT 1,
    CONSTRAINT FK_UserBlocks_User
        FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_UserBlocks_Admin
        FOREIGN KEY (BlockedByAdminID) REFERENCES dbo.Users(UserID)
);
GO

-- ── Notifications ────────────────────────────────────────────────────────
CREATE TABLE dbo.Notifications (
    NotificationID      INT            IDENTITY(1,1) PRIMARY KEY,
    UserID              INT            NOT NULL,
    NotificationContent NVARCHAR(300)  NOT NULL,
    RelatedPostID       INT            NULL,
    RelatedCommentID    INT            NULL,
    RelatedMessageID    INT            NULL,
    DateCreated         DATETIME       NOT NULL DEFAULT GETDATE(),
    IsRead              BIT            NOT NULL DEFAULT 0,
    CONSTRAINT FK_Notifications_User
        FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_Notifications_Post
        FOREIGN KEY (RelatedPostID) REFERENCES dbo.ForumPosts(PostID),
    CONSTRAINT FK_Notifications_Comment
        FOREIGN KEY (RelatedCommentID) REFERENCES dbo.ForumComments(CommentID),
    CONSTRAINT FK_Notifications_Message
        FOREIGN KEY (RelatedMessageID) REFERENCES dbo.Messages(MessageID)
);
GO


-- ═══════════════════════════════════════════════════════════════════════════
--  VIEWS
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Learner attempt summary ───────────────────────────────────────────────
CREATE VIEW dbo.vw_LearnerAttemptSummary AS
SELECT
    qa.AttemptID,
    qa.LearnerID,
    qa.QuizID,
    q.Title,
    q.EducatorID,
    qa.Score,
    qa.AttemptDate,
    (SELECT COUNT(*) FROM dbo.QuizQuestions WHERE QuizID = q.QuizID) AS TotalQ,
    CAST(
        ROUND(
            100.0 * qa.Score /
            NULLIF((SELECT COUNT(*) FROM dbo.QuizQuestions WHERE QuizID = q.QuizID), 0),
            0
        ) AS INT
    ) AS ScorePct
FROM dbo.QuizAttempts qa
INNER JOIN dbo.Quizzes q ON q.QuizID = qa.QuizID;
GO

-- ── Educator quiz stats ───────────────────────────────────────────────────
CREATE VIEW dbo.vw_EducatorQuizStats AS
SELECT
    q.QuizID,
    q.EducatorID,
    q.Title,
    q.DateCreated,
    qc.TotalQuestions,
    COUNT(qa.AttemptID) AS TotalAttempts,
    ISNULL(CAST(ROUND(AVG(100.0 * qa.Score / NULLIF(qc.TotalQuestions, 0)), 0) AS INT), 0) AS AvgScore,
    ISNULL(CAST(ROUND(MAX(100.0 * qa.Score / NULLIF(qc.TotalQuestions, 0)), 0) AS INT), 0) AS MaxScore
FROM dbo.Quizzes q
INNER JOIN (
    SELECT QuizID, COUNT(*) AS TotalQuestions
    FROM dbo.QuizQuestions
    GROUP BY QuizID
) qc ON qc.QuizID = q.QuizID
LEFT JOIN dbo.QuizAttempts qa ON qa.QuizID = q.QuizID
GROUP BY q.QuizID, q.EducatorID, q.Title, q.DateCreated, qc.TotalQuestions;
GO


-- ═══════════════════════════════════════════════════════════════════════════
--  SEED DATA
-- ═══════════════════════════════════════════════════════════════════════════

-- Admin account
INSERT INTO dbo.Users (Username, Email, PasswordHash, Role)
VALUES (
    'Admin',
    'admin@learnsphere.com',
    '$2a$11$8HFQc6HpexOhZdsC8N4LtOqarBOW4NJ3iA/kTQJrko1TjggoV6TSy',
    'Administrator'
);
GO