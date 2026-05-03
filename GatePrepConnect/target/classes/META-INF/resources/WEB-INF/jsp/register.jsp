<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>GATE Prep - Register</title>
    <link rel="stylesheet" href="/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
</head>
<body class="auth-body">
    <div class="auth-card">
        <div class="auth-header">
            <h2>Create an Account</h2>
            <p>Join the community and start your GATE journey</p>
        </div>
        
        <form action="/register" method="post" class="auth-form">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="name" required placeholder="John Doe">
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" required placeholder="john@example.com">
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required placeholder="Create a strong password">
            </div>
            <div class="form-group">
                <label>Join as</label>
                <select name="role" required class="select-field">
                    <option value="STUDENT">Student (Aspirant)</option>
                    <option value="SENIOR">Senior (Mentor)</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary btn-block">Register</button>
        </form>
        <p class="auth-footer">Already have an account? <a href="/">Login here</a></p>
    </div>
</body>
</html>
