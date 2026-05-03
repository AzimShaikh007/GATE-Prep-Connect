<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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