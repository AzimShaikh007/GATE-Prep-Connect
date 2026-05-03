<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>GATE Prep - Login</title>
    <link rel="stylesheet" href="/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
</head>
<body class="auth-body">
    <div class="auth-card">
        <div class="auth-header">
            <h2>Welcome to GATE Prep Connect</h2>
            <p>Your gateway to peer mentorship and exclusive materials</p>
        </div>
        
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>

        <form action="/login" method="post" class="auth-form">
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" required placeholder="Enter your email">
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required placeholder="Enter your password">
            </div>
            <button type="submit" class="btn btn-primary btn-block">Login</button>
        </form>
        <p class="auth-footer">Don't have an account? <a href="/register">Register here</a></p>
    </div>
</body>
</html>
