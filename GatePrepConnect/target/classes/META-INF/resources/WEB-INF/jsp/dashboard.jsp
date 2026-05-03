<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - GATE Prep Connect</title>
    <link rel="stylesheet" href="/css/style.css">
    <!-- KaTeX and Quill.js for Rich Text & Math Support -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.8/dist/katex.min.css">
    <script src="https://cdn.jsdelivr.net/npm/katex@0.16.8/dist/katex.min.js"></script>
    <link href="https://cdn.quilljs.com/1.3.7/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.7/quill.min.js"></script>
    <style>
        .ql-container { font-size: 16px; background: #fff; color: #333; border-radius: 0 0 5px 5px; }
        .ql-toolbar { background: #f1f5f9; border-radius: 5px 5px 0 0; }
        .ql-editor { min-height: 100px; }

        /* ── Tags ── */
        .tag-chip {
            display: inline-block;
            background: rgba(99,102,241,0.15);
            color: #a5b4fc;
            border: 1px solid rgba(99,102,241,0.35);
            border-radius: 999px;
            padding: 2px 10px;
            font-size: 0.78rem;
            font-weight: 600;
            margin: 2px 2px 0 0;
        }
        .tags-row { margin: 6px 0 4px; }

        /* ── Comments ── */
        .comment-thread {
            margin-top: 12px;
            border-top: 1px solid rgba(255,255,255,0.12);
            padding-top: 10px;
        }
        .comment-item {
            background: rgba(255,255,255,0.06);
            border-radius: 8px;
            padding: 8px 12px;
            margin-bottom: 6px;
            font-size: 0.88rem;
        }
        .comment-author { font-weight: 700; color: #a5b4fc; margin-right: 6px; }
        .comment-time { font-size: 0.75rem; color: #94a3b8; }
        .comment-form { display: flex; gap: 8px; margin-top: 8px; }
        .comment-form input[type="text"] { flex: 1; padding: 7px 12px; font-size: 0.9rem; border-radius: 8px; }
        .toggle-comments-btn {
            background: none;
            border: 1px solid rgba(255,255,255,0.2);
            color: #94a3b8;
            border-radius: 6px;
            padding: 4px 10px;
            font-size: 0.8rem;
            cursor: pointer;
            margin-top: 8px;
        }
        .toggle-comments-btn:hover { color: #e2e8f0; border-color: rgba(255,255,255,0.4); }

        /* ── Upvote ── */
        .upvote-row { display: flex; align-items: center; gap: 10px; margin-top: 10px; }
        .upvote-btn {
            background: rgba(99,102,241,0.12);
            border: 1px solid rgba(99,102,241,0.4);
            color: #a5b4fc;
            border-radius: 8px;
            padding: 5px 14px;
            font-size: 0.88rem;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: background 0.2s;
        }
        .upvote-btn.upvoted { background: rgba(99,102,241,0.35); color: #fff; border-color: #6366f1; }
        .upvote-btn:hover { background: rgba(99,102,241,0.25); }

        /* ── Duplicate ── */
        .duplicate-notice {
            margin-top: 8px;
            padding: 7px 12px;
            background: rgba(245,158,11,0.15);
            border: 1px solid rgba(245,158,11,0.4);
            border-radius: 8px;
            font-size: 0.85rem;
            color: #fcd34d;
        }
        .mark-dup-form { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; margin-top: 6px; }
        .mark-dup-form select { flex: 1; min-width: 180px; padding: 6px 10px; font-size: 0.85rem; }

        /* ── Section separator ── */
        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 2rem 0 1rem;
        }
        .section-header h3 { margin: 0; }
        .section-divider {
            flex: 1;
            height: 1px;
            background: rgba(255,255,255,0.1);
        }
        .community-badge {
            background: rgba(99,102,241,0.2);
            color: #a5b4fc;
            border: 1px solid rgba(99,102,241,0.35);
            border-radius: 999px;
            padding: 2px 12px;
            font-size: 0.78rem;
            font-weight: 600;
            white-space: nowrap;
        }

        /* ── My Doubts quick-list (compact for students) ── */
        .my-doubt-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 14px;
            background: rgba(255,255,255,0.04);
            border-radius: 8px;
            margin-bottom: 8px;
            border: 1px solid rgba(255,255,255,0.07);
        }
        .my-doubt-item h5 { margin: 0; flex: 1; font-size: 0.95rem; }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">GATE Prep Connect</div>
        <div class="nav-links">
            <a href="/dashboard" class="active">Dashboard</a>
            <a href="/materials">Materials</a>
            <a href="/report">Stats &amp; Reports</a>
            <a href="/profile">Profile</a>
            <span class="user-badge">${user.name} (${user.role})</span>
            <a href="/logout" class="btn btn-outline">Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="header-section">
            <h1>Welcome, ${user.name}!</h1>
            <p>Here you can view doubts, participate in community discussions, and stay on top of your GATE preparation.</p>
        </div>

        <%-- ── Search / Filter bar ── --%>
        <div class="action-card glass-panel search-panel">
            <form action="/dashboard" method="get" class="search-form" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;">
                <input type="text" name="query" placeholder="Search title or description..." value="${query}" style="flex:1;min-width:200px;">
                <select name="subject">
                    <option value="">All Subjects</option>
                    <option value="Computer Science" ${subject == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                    <option value="Mechanical" ${subject == 'Mechanical' ? 'selected' : ''}>Mechanical</option>
                    <option value="Civil" ${subject == 'Civil' ? 'selected' : ''}>Civil</option>
                    <option value="Electrical" ${subject == 'Electrical' ? 'selected' : ''}>Electrical</option>
                </select>
                <select name="status">
                    <option value="">All Statuses</option>
                    <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>Pending</option>
                    <option value="RESOLVED" ${status == 'RESOLVED' ? 'selected' : ''}>Resolved</option>
                </select>
                <button type="submit" class="btn btn-primary">Filter</button>
                <a href="/dashboard" class="btn btn-outline">Clear</a>
            </form>
        </div>

        <%-- ═══════════════ STUDENT-ONLY: Ask + My Doubts ═══════════════ --%>
        <c:if test="${user.role == 'STUDENT'}">
            <div class="action-card glass-panel">
                <h3>Ask a New Doubt</h3>
                <form action="/ask-doubt" method="post" class="form-inline" onsubmit="return syncQuill(this)">
                    <input type="text" name="title" placeholder="Doubt Title" required>
                    <select name="subject" required>
                        <option value="Computer Science">Computer Science</option>
                        <option value="Mechanical">Mechanical</option>
                        <option value="Civil">Civil</option>
                        <option value="Electrical">Electrical</option>
                    </select>
                    <div class="quill-editor"></div>
                    <input type="hidden" name="description" required>
                    <input type="text" name="tagsInput" placeholder="Tags: e.g. #Calculus, DataStructures, Aptitude" style="margin-top:8px;">
                    <small style="color:#94a3b8;margin-top:2px;">Separate tags with commas or spaces. # prefix is optional.</small>
                    <button type="submit" class="btn btn-primary mt-1">Submit Doubt</button>
                </form>
            </div>

            <%-- Compact list of the student's own doubts --%>
            <div class="section-header">
                <h3>My Doubts</h3>
                <div class="section-divider"></div>
                <span class="community-badge">${myDoubts.size()} total</span>
            </div>
            <c:choose>
                <c:when test="${empty myDoubts}">
                    <p class="empty-state">You haven't asked any doubts yet. Use the form above to get started!</p>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${myDoubts}" var="md">
                        <div class="my-doubt-item">
                            <div class="status-badge ${md.status == 'RESOLVED' ? 'status-green' : 'status-yellow'}" style="position:static;margin:0;">${md.status}</div>
                            <h5>${md.title}</h5>
                            <span class="subject-tag" style="margin:0;">${md.subject}</span>
                            <c:if test="${not empty md.tags}">
                                <c:forEach items="${md.tags}" var="tag"><span class="tag-chip">${tag}</span></c:forEach>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </c:if>

        <%-- ═══════════════ COMMUNITY FEED (ALL USERS) ═══════════════ --%>
        <div class="section-header">
            <h3>
                <c:choose>
                    <c:when test="${user.role == 'SENIOR'}">Doubts Needing Help</c:when>
                    <c:otherwise>Community Discussions</c:otherwise>
                </c:choose>
            </h3>
            <div class="section-divider"></div>
            <span class="community-badge">
                <c:choose>
                    <c:when test="${user.role == 'SENIOR'}">You can answer &amp; comment</c:when>
                    <c:otherwise>Everyone can comment</c:otherwise>
                </c:choose>
            </span>
        </div>

        <div class="card-grid">
            <c:forEach items="${allDoubts}" var="doubt">
                <div class="card doubt-card">
                    <div class="status-badge ${doubt.status == 'RESOLVED' ? 'status-green' : 'status-yellow'}">${doubt.status}</div>
                    <h4>${doubt.title}</h4>
                    <span class="subject-tag">${doubt.subject}</span>
                    <p class="subtext">Asked by: <strong>${doubt.student.name}</strong></p>

                    <%-- Tags --%>
                    <c:if test="${not empty doubt.tags}">
                        <div class="tags-row">
                            <c:forEach items="${doubt.tags}" var="tag">
                                <span class="tag-chip">${tag}</span>
                            </c:forEach>
                        </div>
                    </c:if>

                    <p class="desc">${doubt.description}</p>

                    <%-- Duplicate notice --%>
                    <c:if test="${doubt.duplicateOfId != null}">
                        <div class="duplicate-notice">⚠️ Marked as duplicate of Doubt #${doubt.duplicateOfId}</div>
                    </c:if>

                    <%-- Resolved: show answer + upvote (everyone can upvote) --%>
                    <c:if test="${doubt.status == 'RESOLVED' and doubt.duplicateOfId == null}">
                        <div class="answer-box">
                            <strong>Answer by ${doubt.answeredBy.name}:</strong>
                            <p>${doubt.answerText}</p>
                        </div>
                        <div class="upvote-row">
                            <form action="/upvote" method="post" style="margin:0">
                                <input type="hidden" name="doubtId" value="${doubt.id}">
                                <c:set var="alreadyUpvoted" value="false"/>
                                <c:forEach items="${doubt.upvoters}" var="upvoter">
                                    <c:if test="${upvoter.id == user.id}"><c:set var="alreadyUpvoted" value="true"/></c:if>
                                </c:forEach>
                                <button type="submit" class="upvote-btn ${alreadyUpvoted ? 'upvoted' : ''}">
                                    ▲ ${doubt.upvoters.size()} ${alreadyUpvoted ? 'Upvoted' : 'Upvote Answer'}
                                </button>
                            </form>
                            <small style="color:#94a3b8">${doubt.answeredBy.name}'s reputation: <strong>${doubt.answeredBy.reputation} pts</strong></small>
                        </div>
                    </c:if>

                    <%-- PENDING: seniors can answer + mark-as-duplicate --%>
                    <c:if test="${doubt.status == 'PENDING' and user.role == 'SENIOR'}">
                        <form action="/answer-doubt" method="post" class="answer-form" onsubmit="return syncQuill(this)">
                            <input type="hidden" name="doubtId" value="${doubt.id}">
                            <div class="quill-editor"></div>
                            <input type="hidden" name="answerText" required>
                            <button type="submit" class="btn btn-secondary btn-sm mt-1">Submit Solution</button>
                        </form>

                        <%-- Mark as Duplicate --%>
                        <details style="margin-top:10px;">
                            <summary style="cursor:pointer;color:#fbbf24;font-size:0.85rem;font-weight:600;">🔗 Mark as Duplicate of a Resolved Doubt</summary>
                            <form action="/mark-duplicate" method="post" class="mark-dup-form">
                                <input type="hidden" name="doubtId" value="${doubt.id}">
                                <select name="originalDoubtId" required>
                                    <option value="">— Select the original resolved doubt —</option>
                                    <c:forEach items="${allDoubts}" var="other">
                                        <c:if test="${other.id != doubt.id and other.status == 'RESOLVED' and other.duplicateOfId == null}">
                                            <option value="${other.id}">#${other.id}: ${other.title}</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                                <button type="submit" class="btn btn-outline btn-sm">Confirm</button>
                            </form>
                        </details>
                    </c:if>

                    <%-- SENIOR: upvote count for their resolved answers --%>
                    <c:if test="${doubt.status == 'RESOLVED' and user.role == 'SENIOR' and doubt.duplicateOfId == null and doubt.answeredBy != null and doubt.answeredBy.id == user.id}">
                        <div class="upvote-row" style="margin-top:6px;">
                            <span class="upvote-btn" style="cursor:default;">▲ ${doubt.upvoters.size()} Upvotes on your answer</span>
                        </div>
                    </c:if>

                    <%-- ── Threaded Comments (ALL USERS) ── --%>
                    <div class="comment-thread">
                        <button class="toggle-comments-btn" onclick="toggleComments('${doubt.id}')">
                            💬 ${doubt.comments.size()} Comment<c:if test="${doubt.comments.size() != 1}">s</c:if> ▾
                        </button>
                        <div id="comment-body-${doubt.id}" style="display:none;margin-top:8px;">
                            <c:choose>
                                <c:when test="${empty doubt.comments}">
                                    <p style="color:#64748b;font-size:0.85rem;margin:4px 0 8px;">No comments yet. Be the first!</p>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${doubt.comments}" var="comment">
                                        <div class="comment-item">
                                            <span class="comment-author">${comment.user.name}</span>
                                            <span class="comment-time">${comment.createdAt}</span>
                                            <div style="margin-top:3px;">${comment.text}</div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            <%-- Any logged-in user can post a comment --%>
                            <form action="/add-comment" method="post" class="comment-form">
                                <input type="hidden" name="doubtId" value="${doubt.id}">
                                <input type="text" name="text" placeholder="Write a comment..." required>
                                <button type="submit" class="btn btn-secondary btn-sm">Post</button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty allDoubts}">
                <p class="empty-state">No doubts match your filters. Try clearing the search.</p>
            </c:if>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.quill-editor').forEach(function (editor) {
                editor.quillInstance = new Quill(editor, {
                    theme: 'snow',
                    placeholder: 'Type your text here...',
                    modules: {
                        formula: true,
                        toolbar: [
                            ['bold', 'italic', 'underline', 'strike'],
                            ['blockquote', 'code-block'],
                            [{ 'list': 'ordered' }, { 'list': 'bullet' }],
                            ['formula'],
                            ['clean']
                        ]
                    }
                });
            });
        });

        function syncQuill(form) {
            var editorDiv = form.querySelector('.quill-editor');
            var hiddenInput = form.querySelector('input[type="hidden"][name="description"], input[type="hidden"][name="answerText"]');
            if (editorDiv && editorDiv.quillInstance && hiddenInput) {
                var html = editorDiv.quillInstance.root.innerHTML;
                if (html === '<p><br></p>') {
                    alert('Please enter some content.');
                    return false;
                }
                hiddenInput.value = html;
            }
            return true;
        }

        function toggleComments(doubtId) {
            var body = document.getElementById('comment-body-' + doubtId);
            if (body) body.style.display = (body.style.display === 'none') ? 'block' : 'none';
        }
    </script>
</body>
</html>
