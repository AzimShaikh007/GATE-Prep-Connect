<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - GATE Prep</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body> 
    <nav class="navbar">
        <div class="nav-brand">GATE Prep Connect</div>
        <div class="nav-links">
            <a href="/dashboard" class="active">Dashboard</a>
            <a href="/materials">Materials</a>
            <a href="/report">Stats & Reports</a>
            <span class="user-badge">${user.name} (${user.role})</span>
            <a href="/logout" class="btn btn-outline">Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="header-section">
            <h1>Welcome, ${user.name}!</h1>
            <p>Here you can view doubts, interact with peers, and stay on top of your preparation.</p>
        </div>

        <!-- IF USER IS STUDENT -->
        <c:if test="${user.role == 'STUDENT'}">
            <div class="action-card glass-panel">
                <h3>Ask a Doubt</h3>
                <form action="/ask-doubt" method="post" class="form-inline">
                    <input type="text" name="title" placeholder="Doubt Title" required>
                    <select name="subject" required>
                        <option value="Computer Science">Computer Science</option>
                        <option value="Mechanical">Mechanical</option>
                        <option value="Civil">Civil</option>
                        <option value="Electrical">Electrical</option>
                    </select>
                    <textarea name="description" placeholder="Describe your doubt in detail..." required></textarea>
                    <button type="submit" class="btn btn-primary">Submit Doubt</button>
                </form>
            </div>

            <h3 class="mt-2">My Recent Doubts</h3>
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

        <!-- IF USER IS SENIOR -->
        <c:if test="${user.role == 'SENIOR'}">
            <h3 class="mt-2">Doubts Need Help</h3>
            <div class="card-grid">
                <c:forEach items="${allDoubts}" var="doubt">
                    <div class="card doubt-card">
                        <div class="status-badge ${doubt.status == 'RESOLVED' ? 'status-green' : 'status-yellow'}">${doubt.status}</div>
                        <h4>${doubt.title}</h4>
                        <span class="subject-tag">${doubt.subject}</span>
                        <p class="subtext">Asked by: ${doubt.student.name}</p>
                        <p class="desc">${doubt.description}</p>
                        
                        <c:choose>
                            <c:when test="${doubt.status == 'PENDING'}">
                                <form action="/answer-doubt" method="post" class="answer-form">
                                    <input type="hidden" name="doubtId" value="${doubt.id}">
                                    <textarea name="answerText" placeholder="Write your solution here..." required></textarea>
                                    <button type="submit" class="btn btn-secondary btn-sm">Submit Solution</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <div class="answer-box">
                                    <strong>Answered by ${doubt.answeredBy.name}:</strong>
                                    <p>${doubt.answerText}</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
                <c:if test="${empty allDoubts}">
                    <p class="empty-state">No doubts available at the moment.</p>
                </c:if>
            </div>
        </c:if>
    </div>
</body>
</html>
