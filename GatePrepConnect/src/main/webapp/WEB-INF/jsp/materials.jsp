<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Materials - GATE Prep</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">GATE Prep Connect</div>
        <div class="nav-links">
            <a href="/dashboard">Dashboard</a>
            <a href="/materials" class="active">Materials</a>
            <a href="/report">Stats & Reports</a>
            <span class="user-badge">${user.name} (${user.role})</span>
            <a href="/logout" class="btn btn-outline">Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="header-section">
            <h2>Study Materials Repository</h2>
            <p>Access notes, previous year question papers, and preparation strategies shared by seniors.</p>
        </div>

        <c:if test="${user.role == 'SENIOR'}">
            <div class="action-card glass-panel mb-2">
                <h3>Upload Material</h3>
                <form action="/upload-material" method="post" class="form-inline">
                    <input type="text" name="title" placeholder="Material Title (e.g. CS Notes Chap 1)" required>
                    <select name="subject" required>
                        <option value="Computer Science">Computer Science</option>
                        <option value="Mechanical">Mechanical</option>
                        <option value="Civil">Civil</option>
                        <option value="Electrical">Electrical</option>
                    </select>
                    <input type="url" name="downloadLink" placeholder="Google Drive / DropBox Link" required>
                    <textarea name="description" placeholder="Short description of what the material contains..." required></textarea>
                    <button type="submit" class="btn btn-primary">Upload</button>
                </form>
            </div>
        </c:if>

        <div class="material-grid">
            <c:forEach items="${materials}" var="material">
                <div class="card material-card">
                    <div class="material-icon">📘</div>
                    <div class="material-content">
                        <h4>${material.title}</h4>
                        <span class="subject-tag">${material.subject}</span>
                        <p class="desc">${material.description}</p>
                        <div class="material-footer">
                            <span class="subtext">By ${material.uploadedBy.name}</span>
                            <a href="${material.downloadLink}" target="_blank" class="btn btn-sm btn-secondary">Download / View</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty materials}">
                <p class="empty-state">No materials have been uploaded yet.</p>
            </c:if>
        </div>
    </div>
</body>
</html>
