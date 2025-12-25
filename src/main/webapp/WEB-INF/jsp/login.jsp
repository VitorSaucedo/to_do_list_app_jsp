<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - ToDo List</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">

    <style>
        .alert {
            padding: 12px;
            margin-bottom: 15px;
            border-radius: 6px;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 8px;
            animation: slideDown 0.3s ease;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .login-icon {
            font-size: 3em;
            color: var(--primary-color);
            margin-bottom: 10px;
        }

        .input-with-icon {
            position: relative;
        }

        .input-with-icon i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }

        .input-with-icon input {
            padding-left: 40px;
        }

        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #999;
        }
    </style>
</head>
<body>
<div class="container" style="text-align: center;">
    <header>
        <div class="login-icon">
            <i class="fas fa-tasks"></i>
        </div>
        <h1>Bem-vindo de volta!</h1>
        <p>Faça login para acessar suas tarefas</p>
    </header>

    <!-- Mensagens -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i>
            <span>${errorMessage}</span>
        </div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span>${successMessage}</span>
        </div>
    </c:if>

    <!-- Formulário de Login -->
    <form action="${pageContext.request.contextPath}/auth/login"
          method="post"
          style="display: flex; flex-direction: column; gap: 15px;">

        <div class="input-with-icon">
            <i class="fas fa-user"></i>
            <input type="text"
                   name="username"
                   placeholder="Usuário"
                   required
                   autocomplete="username"
                   autofocus>
        </div>

        <div class="input-with-icon">
            <i class="fas fa-lock"></i>
            <input type="password"
                   id="password"
                   name="password"
                   placeholder="Senha"
                   required
                   autocomplete="current-password">
            <i class="fas fa-eye password-toggle"
               onclick="togglePassword()"
               id="toggleIcon"></i>
        </div>

        <button type="submit" style="width: 100%;">
            <i class="fas fa-sign-in-alt"></i> Entrar
        </button>
    </form>

    <p style="margin-top: 20px; font-size: 0.95rem;">
        Não tem conta?
        <a href="${pageContext.request.contextPath}/register"
           style="color: var(--primary-color); font-weight: 600;">
            Registre-se aqui
        </a>
    </p>
</div>

<script>
    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const toggleIcon = document.getElementById('toggleIcon');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleIcon.classList.remove('fa-eye');
            toggleIcon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            toggleIcon.classList.remove('fa-eye-slash');
            toggleIcon.classList.add('fa-eye');
        }
    }

    // Auto-hide success message
    setTimeout(function() {
        const successAlert = document.querySelector('.alert-success');
        if (successAlert) {
            successAlert.style.transition = 'opacity 0.5s';
            successAlert.style.opacity = '0';
            setTimeout(() => successAlert.remove(), 500);
        }
    }, 5000);
</script>
</body>