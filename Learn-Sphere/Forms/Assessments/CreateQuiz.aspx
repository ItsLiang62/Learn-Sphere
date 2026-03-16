<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateQuiz.aspx.cs" Inherits="Learn_Sphere.Forms.Assessment.CreateQuiz" %>
<%@ Register TagPrefix="uc" TagName="GlobalHeader" Src="~/Shared/GlobalHeader.ascx" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Create Quiz - LearnSphere</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea, #764ba2);
            min-height: 100vh;
        }

        .page-container { padding-top: 60px; padding-bottom: 60px; }

        .card-quiz {
            background: white;
            border-radius: 15px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.2);
            padding: 30px;
            margin-bottom: 30px;
        }

        .card-quiz h3 { font-weight: 600; color: #4b4bff; margin-bottom: 20px; }

        .btn-primary { background: linear-gradient(90deg, #4b4bff, #667eea); border: none; font-weight: 600; padding: 10px 25px; border-radius: 8px; color: #fff; transition: 0.3s; }
        .btn-primary:hover { background: linear-gradient(90deg, #667eea, #764ba2); }

        .btn-back { background: #f5f5f5; border: none; color: #333; font-weight: 500; padding: 10px 20px; border-radius: 8px; margin-bottom: 20px; }

        .question-card { background: #f7f7ff; border-radius: 10px; padding: 20px; margin-bottom: 15px; border-left: 5px solid #4b4bff; }
        .option-input { margin-bottom: 10px; }
        .option-input input[type="radio"] { accent-color: #4b4bff; margin-right: 6px; }
        .text-gradient { background: linear-gradient(90deg, #4b4bff, #667eea); -webkit-background-clip: text; -webkit-text-fill-color: transparent; font-weight: 700; }
        .remove-question { float: right; color: #dc3545; cursor: pointer; font-size: 0.9rem; }
        .remove-question:hover { text-decoration: underline; }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <uc:GlobalHeader ID="GlobalHeader1" runat="server" />

        <div class="container page-container">
            <asp:Button ID="btnBack" runat="server" Text="← Back to Assessments" CssClass="btn-back" OnClick="btnBack_Click" />

            <div class="card-quiz">
                <h3 class="text-gradient">Create a New Quiz</h3>
                <asp:Label ID="lblMessage" runat="server" CssClass="mb-3 d-block fw-bold"></asp:Label>

                <div class="mb-3">
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Quiz Title"></asp:TextBox>
                </div>
                <div class="mb-4">
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Quiz Description (optional)"></asp:TextBox>
                </div>

                <asp:Repeater ID="rptQuestions" runat="server">
                    <ItemTemplate>
                        <div class="question-card">
                            <asp:Button ID="btnRemove" runat="server" CssClass="remove-question"
                                        Text="Remove" CommandArgument="<%# Container.ItemIndex %>"
                                        OnClick="RemoveQuestion_Click" />
                            <h5>Question <%# Container.ItemIndex + 1 %></h5>

                            <div class="mb-2">
                                <asp:TextBox ID="txtQuestion" runat="server" CssClass="form-control"
                                             Text='<%# Eval("QuestionText") %>' placeholder="Enter question text"></asp:TextBox>
                            </div>

                            <div class="option-input">
                                <input type="radio" name="q<%# Container.ItemIndex %>_correct" value="A" <%# Eval("CorrectOption").ToString()=="A"?"checked":"" %> /> A:
                                <asp:TextBox ID="txtOptionA" runat="server" CssClass="form-control d-inline-block w-75 ms-2"
                                             Text='<%# Eval("OptionA") %>' placeholder="Option A"></asp:TextBox>
                            </div>
                            <div class="option-input">
                                <input type="radio" name="q<%# Container.ItemIndex %>_correct" value="B" <%# Eval("CorrectOption").ToString()=="B"?"checked":"" %> /> B:
                                <asp:TextBox ID="txtOptionB" runat="server" CssClass="form-control d-inline-block w-75 ms-2"
                                             Text='<%# Eval("OptionB") %>' placeholder="Option B"></asp:TextBox>
                            </div>
                            <div class="option-input">
                                <input type="radio" name="q<%# Container.ItemIndex %>_correct" value="C" <%# Eval("CorrectOption").ToString()=="C"?"checked":"" %> /> C:
                                <asp:TextBox ID="txtOptionC" runat="server" CssClass="form-control d-inline-block w-75 ms-2"
                                             Text='<%# Eval("OptionC") %>' placeholder="Option C"></asp:TextBox>
                            </div>
                            <div class="option-input">
                                <input type="radio" name="q<%# Container.ItemIndex %>_correct" value="D" <%# Eval("CorrectOption").ToString()=="D"?"checked":"" %> /> D:
                                <asp:TextBox ID="txtOptionD" runat="server" CssClass="form-control d-inline-block w-75 ms-2"
                                             Text='<%# Eval("OptionD") %>' placeholder="Option D"></asp:TextBox>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:Button ID="btnAddQuestion" runat="server" Text="Add Question" CssClass="btn-primary mt-2" OnClick="btnAddQuestion_Click" />
                <asp:Button ID="btnCreateQuiz" runat="server" Text="Create Quiz" CssClass="btn-primary mt-3" OnClick="btnCreateQuiz_Click" />
            </div>
        </div>
    </form>
</body>
</html>