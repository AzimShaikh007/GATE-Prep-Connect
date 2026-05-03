<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Platform Reports - GATE Prep</title>
        <link rel="stylesheet" href="/css/style.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>

    <body>
        <nav class="navbar">
            <div class="nav-brand">GATE Prep Connect</div>
            <div class="nav-links">
                <a href="/dashboard">Dashboard</a>
                <a href="/materials">Materials</a>
                <a href="/report" class="active">Stats & Reports</a>
                <a href="/profile">Profile</a>
                <span class="user-badge">${user.name} (${user.role})</span>
                <a href="/logout" class="btn btn-outline">Logout</a>
            </div>
        </nav>

        <div class="container">
            <div class="header-section text-center">
                <h2>Platform Engagement Report</h2>
                <p>Real-time automated report showcasing platform health and mentorship activity.</p>
                <button onclick="window.print()" class="btn btn-primary mt-1">Export as PDF</button>
            </div>

            <div class="stats-container mt-2">
                <div class="stat-box">
                    <h3>${totalDoubts}</h3>
                    <p>Total Doubts</p>
                </div>
                <div class="stat-box stat-success">
                    <h3>${resolvedDoubts}</h3>
                    <p>Resolved Doubts</p>
                </div>
                <div class="stat-box stat-warning">
                    <h3>${pendingDoubts}</h3>
                    <p>Pending Queries</p>
                </div>
                <div class="stat-box stat-info">
                    <h3>${totalMaterials}</h3>
                    <p>Materials Shared</p>
                </div>
            </div>

            <div class="chart-container glass-panel mt-2" style="max-width: 600px; margin: 2rem auto; padding: 2rem;">
                <canvas id="engagementChart"></canvas>
            </div>

            <%-- Phase 3: Leaderboard --%>
            <div class="glass-panel mt-2" style="max-width:600px;margin:2rem auto;padding:1.8rem;">
                <h3 style="color:#e2e8f0;font-size:1rem;font-weight:600;margin-bottom:1rem;text-align:center;">
                    🏆 Top Mentors by Reputation
                </h3>
                <c:choose>
                    <c:when test="${empty topSeniors}">
                        <p style="text-align:center;color:#64748b;">No seniors yet.</p>
                    </c:when>
                    <c:otherwise>
                        <ol style="list-style:none;padding:0;margin:0;">
                        <c:forEach var="s" items="${topSeniors}" varStatus="vs">
                            <li style="display:flex;align-items:center;justify-content:space-between;
                                       padding:.65rem .8rem;border-radius:8px;margin-bottom:.4rem;
                                       background:rgba(99,102,241,.08);border:1px solid rgba(99,102,241,.15);">
                                <span style="color:#a5b4fc;font-weight:600;margin-right:.6rem;">${vs.index+1}.</span>
                                <span style="color:#e2e8f0;flex:1;">${s.name}</span>
                                <span style="color:#f59e0b;font-weight:700;">⭐ ${s.reputation} pts</span>
                            </li>
                        </c:forEach>
                        </ol>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var ctx = document.getElementById('engagementChart').getContext('2d');
                var chart = new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: ['Resolved Doubts', 'Pending Doubts', 'Materials'],
                        datasets: [{
                            data: [${ resolvedDoubts }, ${ pendingDoubts }, ${ totalMaterials }],
                            backgroundColor: [
                                'rgba(16, 185, 129, 0.8)', // Green
                                'rgba(245, 158, 11, 0.8)', // Yellow
                                'rgba(59, 130, 246, 0.8)'  // Blue
                            ],
                            borderWidth: 0
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: { position: 'bottom' },
                            title: { display: true, text: 'Engagement Distribution' }
                        }
                    }
                });
            });
        </script>
    </body>

    </html>