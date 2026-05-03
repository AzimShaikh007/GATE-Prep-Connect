<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Materials - GATE Prep</title>
    <link rel="stylesheet" href="/css/style.css">
    
    <!-- KaTeX and Quill.js for Rich Text & Math Support -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.8/dist/katex.min.css">
    <script src="https://cdn.jsdelivr.net/npm/katex@0.16.8/dist/katex.min.js"></script>
    <link href="https://cdn.quilljs.com/1.3.7/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.7/quill.min.js"></script>
    <style>
        .ql-container {
            font-size: 16px;
            background: #fff;
            color: #333;
            border-radius: 0 0 5px 5px;
        }
        .ql-toolbar {
            background: #f1f5f9;
            border-radius: 5px 5px 0 0;
        }
        .ql-editor {
            min-height: 100px;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">GATE Prep Connect</div>
        <div class="nav-links">
            <a href="/dashboard">Dashboard</a>
            <a href="/materials" class="active">Materials</a>
            <a href="/report">Stats & Reports</a>
            <a href="/profile">Profile</a>
            <span class="user-badge">${user.name} (${user.role})</span>
            <a href="/logout" class="btn btn-outline">Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="header-section">
            <h2>Study Materials Repository</h2>
            <p>Access notes, previous year question papers, and preparation strategies shared by seniors.</p>
        </div>

        <div class="action-card glass-panel search-panel mb-2">
            <form action="/materials" method="get" class="search-form" style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
                <input type="text" name="query" placeholder="Search title or description..." value="${query}" style="flex: 1; min-width: 200px;">
                <select name="subject">
                    <option value="">All Subjects</option>
                    <option value="Computer Science" ${subject == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                    <option value="Mechanical" ${subject == 'Mechanical' ? 'selected' : ''}>Mechanical</option>
                    <option value="Civil" ${subject == 'Civil' ? 'selected' : ''}>Civil</option>
                    <option value="Electrical" ${subject == 'Electrical' ? 'selected' : ''}>Electrical</option>
                </select>
                <button type="submit" class="btn btn-primary">Filter</button>
                <a href="/materials" class="btn btn-outline">Clear</a>
            </form>
        </div>

        <c:if test="${user.role == 'SENIOR'}">
            <div class="action-card glass-panel mb-2">
                <h3>Upload Material</h3>
                <form action="/upload-material" method="post" class="form-inline" onsubmit="return syncQuill(this)">
                    <input type="text" name="title" placeholder="Material Title (e.g. CS Notes Chap 1)" required>
                    <select name="subject" required>
                        <option value="Computer Science">Computer Science</option>
                        <option value="Mechanical">Mechanical</option>
                        <option value="Civil">Civil</option>
                        <option value="Electrical">Electrical</option>
                    </select>
                    <input type="url" name="downloadLink" placeholder="Google Drive / DropBox Link" required>
                    <div class="quill-editor"></div>
                    <input type="hidden" name="description" required>
                    <button type="submit" class="btn btn-primary mt-1">Upload</button>
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

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var editors = document.querySelectorAll('.quill-editor');
            editors.forEach(function(editor) {
                var q = new Quill(editor, {
                    theme: 'snow',
                    placeholder: 'Short description of what the material contains...',
                    modules: {
                        formula: true,
                        toolbar: [
                            ['bold', 'italic', 'underline', 'strike'],
                            ['blockquote', 'code-block'],
                            [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                            ['formula'],
                            ['clean']
                        ]
                    }
                });
                editor.quillInstance = q;
            });
        });

        function syncQuill(form) {
            var editorDiv = form.querySelector('.quill-editor');
            var hiddenInput = form.querySelector('input[type="hidden"][name="description"]');
            if (editorDiv && editorDiv.quillInstance && hiddenInput) {
                var html = editorDiv.quillInstance.root.innerHTML;
                if (html === '<p><br></p>') {
                    alert('Please enter a description.');
                    return false;
                }
                hiddenInput.value = html;
            }
            return true;
        }
    </script>
</body>
</html>
