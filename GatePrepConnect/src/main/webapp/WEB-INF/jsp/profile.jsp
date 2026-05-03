<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Profile - GATE Prep</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .profile-header {
            text-align: center;
            padding: 2rem;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            margin-bottom: 2rem;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }
        .stat-card {
            background: rgba(255, 255, 255, 0.03);
            padding: 1.5rem;
            border-radius: 8px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .stat-card h4 { margin: 0 0 0.5rem 0; font-size: 1rem; color: #ccc; }
        .stat-card .value { font-size: 2rem; font-weight: bold; color: #4facfe; }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">GATE Prep Connect</div>
        <div class="nav-links">
            <a href="/dashboard">Dashboard</a>
            <a href="/materials">Materials</a>
            <a href="/report">Stats & Reports</a>
            <a href="/profile" class="active">Profile</a>
            <span class="user-badge">${user.name} (${user.role})</span>
            <a href="/logout" class="btn btn-outline">Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="profile-header glass-panel">
            <h2>${user.name}</h2>
            <p>Email: ${user.email}</p>
            <span class="user-badge" style="font-size: 1rem;">Role: ${user.role}</span>
        </div>

        <c:if test="${user.role == 'STUDENT'}">
            <div class="action-card glass-panel mb-2">
                <h3>My Activity Overview</h3>
                <div class="stats-grid">
                    <div class="stat-card">
                        <h4>Total Doubts Asked</h4>
                        <div class="value">${myDoubts.size()}</div>
                    </div>
                    <div class="stat-card">
                        <h4>Resolved Doubts</h4>
                        <div class="value">${resolvedCount}</div>
                    </div>
                    <div class="stat-card">
                        <h4>Pending Doubts</h4>
                        <div class="value">${pendingCount}</div>
                    </div>
                </div>
            </div>

            <h3 class="mt-2">My Doubt History</h3>
            <div class="card-grid">
                <c:forEach items="${myDoubts}" var="doubt">
                    <div class="card doubt-card">
                        <div class="status-badge ${doubt.status == 'RESOLVED' ? 'status-green' : 'status-yellow'}">${doubt.status}</div>
                        <h4>${doubt.title}</h4>
                        <span class="subject-tag">${doubt.subject}</span>
                        <p class="desc">${doubt.description}</p>
                        
                        <c:if test="${doubt.status == 'RESOLVED'}">
                            <div class="answer-box">
                                <strong>Answer by ${doubt.answeredBy.name}:</strong>
                                <p>${doubt.answerText}</p>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
                <c:if test="${empty myDoubts}">
                    <p class="empty-state">You haven't asked any doubts yet.</p>
                </c:if>
            </div>
        </c:if>

        <c:if test="${user.role == 'SENIOR'}">
            <div class="action-card glass-panel mb-2">
                <h3>Mentorship Stats</h3>
                <div class="stats-grid">
                    <div class="stat-card">
                        <h4>Doubts Answered</h4>
                        <div class="value">${answeredDoubtsCount}</div>
                    </div>
                    <div class="stat-card">
                        <h4>Materials Uploaded</h4>
                        <div class="value">${materialsUploadedCount}</div>
                    </div>
                    <%-- Phase 2: Reputation --%>
                    <div class="stat-card" style="border-color:rgba(99,102,241,0.5);">
                        <h4>Reputation Score</h4>
                        <div class="value" style="color:#a5b4fc;">${user.reputation}</div>
                    </div>
                </div>
                <%-- Phase 2: Automated Badges --%>
                <div style="margin-top:1.2rem;">
                    <strong style="color:#94a3b8;">Badges:</strong>
                    <div style="margin-top:6px;display:flex;gap:8px;flex-wrap:wrap;">
                        <c:if test="${answeredDoubtsCount >= 1}">
                            <span style="background:rgba(16,185,129,0.15);border:1px solid rgba(16,185,129,0.4);color:#6ee7b7;padding:4px 14px;border-radius:999px;font-size:0.82rem;font-weight:600;">🌱 First Answer</span>
                        </c:if>
                        <c:if test="${answeredDoubtsCount >= 10}">
                            <span style="background:rgba(59,130,246,0.15);border:1px solid rgba(59,130,246,0.4);color:#93c5fd;padding:4px 14px;border-radius:999px;font-size:0.82rem;font-weight:600;">📚 Active Mentor</span>
                        </c:if>
                        <c:if test="${user.reputation >= 5}">
                            <span style="background:rgba(245,158,11,0.15);border:1px solid rgba(245,158,11,0.4);color:#fcd34d;padding:4px 14px;border-radius:999px;font-size:0.82rem;font-weight:600;">⭐ Rising Star</span>
                        </c:if>
                        <c:if test="${user.reputation >= 20}">
                            <span style="background:rgba(239,68,68,0.15);border:1px solid rgba(239,68,68,0.4);color:#fca5a5;padding:4px 14px;border-radius:999px;font-size:0.82rem;font-weight:600;">🏆 Top Contributor</span>
                        </c:if>
                        <c:if test="${materialsUploadedCount >= 5}">
                            <span style="background:rgba(139,92,246,0.15);border:1px solid rgba(139,92,246,0.4);color:#c4b5fd;padding:4px 14px;border-radius:999px;font-size:0.82rem;font-weight:600;">📂 Resource Provider</span>
                        </c:if>
                        <c:if test="${answeredDoubtsCount == 0 and user.reputation == 0}">
                            <span style="color:#64748b;font-size:0.85rem;">No badges yet — start answering doubts to earn them!</span>
                        </c:if>
                    </div>
                </div>
            </div>

            <h3 class="mt-2">Doubts I Answered</h3>
            <div class="card-grid mb-2">
                <c:forEach items="${myAnsweredDoubts}" var="doubt">
                    <div class="card doubt-card">
                        <div class="status-badge status-green">${doubt.status}</div>
                        <h4>${doubt.title}</h4>
                        <span class="subject-tag">${doubt.subject}</span>
                        <p class="desc">${doubt.description}</p>
                        <div class="answer-box">
                            <strong>My Answer:</strong>
                            <p>${doubt.answerText}</p>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty myAnsweredDoubts}">
                    <p class="empty-state">You haven't answered any doubts yet.</p>
                </c:if>
            </div>

            <h3 class="mt-2">Materials I Uploaded</h3>
            <div class="material-grid">
                <c:forEach items="${myMaterials}" var="material">
                    <div class="card material-card">
                        <div class="material-icon">📘</div>
                        <div class="material-content">
                            <h4>${material.title}</h4>
                            <span class="subject-tag">${material.subject}</span>
                            <p class="desc">${material.description}</p>
                            <div class="material-footer">
                                <a href="${material.downloadLink}" target="_blank" class="btn btn-sm btn-secondary">Download / View</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty myMaterials}">
                    <p class="empty-state">You haven't uploaded any materials yet.</p>
                </c:if>
            </div>
        </c:if>
    </div>
</body>
</html>
