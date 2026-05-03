<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Admin Panel – GATE Prep Connect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/style.css">
    <style>
        /* ── Admin-specific overrides ─────────────────────────────── */
        body { background: #0a0e1a; }

        .admin-header {
            background: linear-gradient(135deg,#1a1f3a 0%,#12162b 100%);
            border-bottom: 1px solid rgba(239,68,68,.25);
            padding: 1.2rem 2rem;
            display: flex; align-items: center; justify-content: space-between;
        }
        .admin-header .logo { font-size:1.3rem; font-weight:700; color:#ef4444; letter-spacing:.5px; }
        .admin-header nav a {
            color:#94a3b8; text-decoration:none; font-size:.85rem;
            margin-left:1.5rem; transition:color .2s;
        }
        .admin-header nav a:hover { color:#fff; }

        .admin-main { max-width:1200px; margin:2rem auto; padding:0 1.5rem; }

        /* stat cards */
        .stats-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:1.2rem; margin-bottom:2.5rem; }
        .stat-card  {
            background:linear-gradient(135deg,rgba(30,40,70,.8),rgba(20,28,55,.9));
            border:1px solid rgba(255,255,255,.08); border-radius:14px;
            padding:1.4rem 1.6rem; text-align:center;
        }
        .stat-card .num  { font-size:2.4rem; font-weight:700; color:#fff; }
        .stat-card .label{ font-size:.8rem; color:#64748b; margin-top:.3rem; text-transform:uppercase; letter-spacing:.8px; }
        .stat-card.danger .num { color:#ef4444; }
        .stat-card.green  .num { color:#22c55e; }

        /* admin sections */
        .admin-section { margin-bottom:2.5rem; }
        .admin-section h2 {
            font-size:1.05rem; font-weight:600; color:#e2e8f0;
            border-left:3px solid #6366f1; padding-left:.8rem;
            margin-bottom:1.1rem;
        }

        /* table */
        .admin-table { width:100%; border-collapse:collapse; }
        .admin-table th {
            background:rgba(99,102,241,.12); color:#94a3b8;
            font-size:.75rem; text-transform:uppercase; letter-spacing:.7px;
            padding:.7rem 1rem; text-align:left;
        }
        .admin-table td {
            padding:.7rem 1rem; font-size:.85rem; color:#cbd5e1;
            border-bottom:1px solid rgba(255,255,255,.05);
        }
        .admin-table tr:last-child td { border-bottom:none; }
        .admin-table tr:hover td { background:rgba(255,255,255,.03); }

        /* badges */
        .badge { display:inline-block; padding:.15rem .6rem; border-radius:999px; font-size:.72rem; font-weight:600; }
        .badge-student { background:rgba(59,130,246,.2); color:#93c5fd; }
        .badge-senior  { background:rgba(168,85,247,.2); color:#c4b5fd; }
        .badge-admin   { background:rgba(239,68,68,.2);  color:#fca5a5; }
        .badge-banned  { background:rgba(239,68,68,.3);  color:#f87171; }
        .badge-active  { background:rgba(34,197,94,.2);  color:#86efac; }
        .badge-pending  { background:rgba(234,179,8,.2);  color:#fde047; }
        .badge-resolved { background:rgba(34,197,94,.2);  color:#86efac; }

        /* action buttons */
        .btn-ban   { background:rgba(239,68,68,.15); color:#f87171; border:1px solid rgba(239,68,68,.3); }
        .btn-unban { background:rgba(34,197,94,.15); color:#86efac; border:1px solid rgba(34,197,94,.3); }
        .btn-del   { background:rgba(239,68,68,.15); color:#f87171; border:1px solid rgba(239,68,68,.3); }
        .btn-sm    { padding:.3rem .75rem; font-size:.78rem; border-radius:6px; cursor:pointer; }
        .btn-sm:hover { filter:brightness(1.2); }

        /* tab bar */
        .tab-bar { display:flex; gap:.6rem; margin-bottom:1.4rem; border-bottom:1px solid rgba(255,255,255,.07); padding-bottom:.8rem; }
        .tab-btn {
            background:transparent; border:1px solid rgba(255,255,255,.1);
            color:#94a3b8; border-radius:8px; padding:.4rem 1.1rem;
            font-size:.82rem; cursor:pointer; transition:all .2s;
        }
        .tab-btn.active, .tab-btn:hover {
            background:rgba(99,102,241,.2); border-color:#6366f1; color:#a5b4fc;
        }
        .tab-panel { display:none; }
        .tab-panel.active { display:block; }

        /* scrollable table wrapper */
        .table-wrap { background:rgba(15,20,40,.6); border:1px solid rgba(255,255,255,.07); border-radius:14px; overflow:hidden; overflow-x:auto; }
    </style>
</head>
<body>

<!-- ── Header ───────────────────────────────────────────────────── -->
<header class="admin-header">
    <span class="logo">🛡 GATE Prep Connect — Admin</span>
    <nav>
        <a href="/dashboard">Dashboard</a>
        <a href="/report">Report</a>
        <a href="/logout">Logout</a>
    </nav>
</header>

<main class="admin-main">
    <h1 style="font-size:1.6rem;font-weight:700;color:#fff;margin-bottom:1.5rem;">
        Moderation Control Panel
    </h1>

    <!-- ── Stats ────────────────────────────────────────────────── -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="num">${totalUsers}</div>
            <div class="label">Total Users</div>
        </div>
        <div class="stat-card danger">
            <div class="num">${bannedUsers}</div>
            <div class="label">Banned Users</div>
        </div>
        <div class="stat-card">
            <div class="num">${totalDoubts}</div>
            <div class="label">Total Doubts</div>
        </div>
        <div class="stat-card green">
            <div class="num">${resolvedDoubts}</div>
            <div class="label">Resolved</div>
        </div>
        <div class="stat-card">
            <div class="num">${totalMaterials}</div>
            <div class="label">Materials</div>
        </div>
    </div>

    <!-- ── Tabs ─────────────────────────────────────────────────── -->
    <div class="tab-bar">
        <button class="tab-btn active" onclick="showTab('users',this)">👥 Users</button>
        <button class="tab-btn"        onclick="showTab('doubts',this)">❓ Doubts</button>
        <button class="tab-btn"        onclick="showTab('materials',this)">📚 Materials</button>
    </div>

    <!-- Users Tab -->
    <div id="tab-users" class="tab-panel active admin-section">
        <div class="table-wrap">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>#</th><th>Name</th><th>Email</th><th>Role</th>
                        <th>Reputation</th><th>Status</th><th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${allUsers}" varStatus="vs">
                    <tr>
                        <td>${vs.index + 1}</td>
                        <td>${u.name}</td>
                        <td style="color:#64748b;">${u.email}</td>
                        <td>
                            <span class="badge badge-${u.role.toLowerCase()}">${u.role}</span>
                        </td>
                        <td><c:out value="${u.reputation}" default="0"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${u.banned}"><span class="badge badge-banned">Banned</span></c:when>
                                <c:otherwise><span class="badge badge-active">Active</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <form method="post" action="/admin/ban-user" style="display:inline;">
                                <input type="hidden" name="userId" value="${u.id}"/>
                                <c:choose>
                                    <c:when test="${u.banned}">
                                        <button type="submit" class="btn-sm btn-unban">Unban</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="submit" class="btn-sm btn-ban"
                                                onclick="return confirm('Ban ${u.name}?')">Ban</button>
                                    </c:otherwise>
                                </c:choose>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Doubts Tab -->
    <div id="tab-doubts" class="tab-panel admin-section">
        <div class="table-wrap">
            <table class="admin-table">
                <thead>
                    <tr><th>#</th><th>Title</th><th>Subject</th><th>Student</th><th>Status</th><th>Action</th></tr>
                </thead>
                <tbody>
                <c:forEach var="d" items="${allDoubts}" varStatus="vs">
                    <tr>
                        <td>${vs.index + 1}</td>
                        <td>${d.title}</td>
                        <td>${d.subject}</td>
                        <td>${d.student.name}</td>
                        <td>
                            <span class="badge badge-${d.status.toLowerCase()}">${d.status}</span>
                        </td>
                        <td>
                            <form method="post" action="/admin/delete-doubt" style="display:inline;">
                                <input type="hidden" name="doubtId" value="${d.id}"/>
                                <button type="submit" class="btn-sm btn-del"
                                        onclick="return confirm('Delete this doubt permanently?')">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Materials Tab -->
    <div id="tab-materials" class="tab-panel admin-section">
        <div class="table-wrap">
            <table class="admin-table">
                <thead>
                    <tr><th>#</th><th>Title</th><th>Subject</th><th>Uploaded By</th><th>Date</th><th>Action</th></tr>
                </thead>
                <tbody>
                <c:forEach var="m" items="${allMaterials}" varStatus="vs">
                    <tr>
                        <td>${vs.index + 1}</td>
                        <td>${m.title}</td>
                        <td>${m.subject}</td>
                        <td>${m.uploadedBy.name}</td>
                        <td><fmt:formatDate value="${m.uploadedAt}" pattern="dd MMM yyyy"/></td>
                        <td>
                            <form method="post" action="/admin/delete-material" style="display:inline;">
                                <input type="hidden" name="materialId" value="${m.id}"/>
                                <button type="submit" class="btn-sm btn-del"
                                        onclick="return confirm('Delete this material permanently?')">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</main>

<script>
function showTab(name, btn) {
    document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.getElementById('tab-' + name).classList.add('active');
    btn.classList.add('active');
}
</script>

</body>
</html>
