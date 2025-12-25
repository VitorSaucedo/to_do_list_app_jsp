<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Criar Conta - ToDo List</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">

    <style>
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 15px;
            border: 1px solid #f5c6cb;
            display: flex;
            align-items: center;
            gap: 8px;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .register-icon {
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

        .password-strength {
            height: 4px;
            background: #eee;
            border-radius: 2px;
            margin-top: 5px;
            overflow: hidden;
        }

        .password-strength-bar {
            height: 100%;
            width: 0;
            transition: all 0.3s;
        }

        .strength-weak { background: #d9534f; width: 33%; }
        .strength-medium { background: #f0ad4e; width: 66%; }
        .strength-strong { background: #5cb85c; width: 100%; }

        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #999;
        }

        .requirements {
            text-align: left;
            font-size: 0.85em;
            color: #666;
            margin-top: 10px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 6px;
        }

        .requirements li {
            margin: 5px 0;
        }

        .requirement-met {
            color: var(--primary-color);
        }

        .requirement-unmet {
            color: #999;
        }
    </style>
</head>
<body>
<div class="container" style="text-align: center;">
    <header>
        <div class="register-icon">
            <i class="fas fa-user-plus"></i>
        </div>
        <h1>Crie sua conta</h1>
        <p>Comece a organizar suas tarefas hoje</p>
    </header>

    <c:if test="${not empty errorMessage}">
        <div class="alert-danger">
            <i class="fas fa-exclamation-triangle"></i>
            <span>${errorMessage}</span>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/auth/register"
          method="post"
          style="display: flex; flex-direction: column; gap: 15px;"
          onsubmit="return validateForm()">

        <div class="input-with-icon">
            <i class="fas fa-user"></i>
            <input type="text"
                   name="login"
                   id="username"
                   placeholder="Escolha um usuário"
                   autocomplete="off"
                   required
                   minlength="3"
                   autofocus>
        </div>

        <div class="input-with-icon">
            <i class="fas fa-lock"></i>
            <input type="password"
                   id="password"
                   name="password"
                   placeholder="Escolha uma senha"
                   required
                   minlength="6"
                   oninput="checkPasswordStrength()"
                   autocomplete="new-password">
            <i class="fas fa-eye password-toggle"
               onclick="togglePassword()"
               id="toggleIcon"></i>
        </div>

        <div class="password-strength">
            <div class="password-strength-bar" id="strengthBar"></div>
        </div>

        <div class="requirements">
            <small><strong>Requisitos da senha:</strong></small>
            <ul style="list-style: none; padding-left: 0;">
                <li id="req-length" class="requirement-unmet">
                    <i class="fas fa-circle" style="font-size: 0.5em;"></i> Mínimo de 6 caracteres
                </li>
                <li id="req-letter" class="requirement-unmet">
                    <i class="fas fa-circle" style="font-size: 0.5em;"></i> Pelo menos uma letra
                </li>
            </ul>
        </div>

        <button type="submit" style="width: 100%;">
            <i class="fas fa-user-check"></i> Criar Conta
        </button>
    </form>

    <p style="margin-top: 20px; font-size: 0.95rem;">
        Já tem uma conta?
        <a href="${pageContext.request.contextPath}/login"
           style="color: var(--primary-color); font-weight: 600;">
            Faça Login
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

    function checkPasswordStrength() {
        const password = document.getElementById('password').value;
        const strengthBar = document.getElementById('strengthBar');
        const reqLength = document.getElementById('req-length');
        const reqLetter = document.getElementById('req-letter');

        // Reset
        strengthBar.className = 'password-strength-bar';

        // Check requirements
        const hasLength = password.length >= 6;
        const hasLetter = /[a-zA-Z]/.test(password);

        // Update requirement indicators
        updateRequirement(reqLength, hasLength);
        updateRequirement(reqLetter, hasLetter);

        // Calculate strength
        let strength = 0;
        if (hasLength) strength++;
        if (hasLetter) strength++;
        if (password.length >= 8) strength++;
        if (/\d/.test(password)) strength++;
        if (/[^a-zA-Z0-9]/.test(password)) strength++;

        // Update strength bar
        if (strength <= 2) {
            strengthBar.classList.add('strength-weak');
        } else if (strength <= 3) {
            strengthBar.classList.add('strength-medium');
        } else {
            strengthBar.classList.add('strength-strong');
        }
    }

    function updateRequirement(element, met) {
        if (met) {
            element.classList.remove('requirement-unmet');
            element.classList.add('requirement-met');
            element.querySelector('i').className = 'fas fa-check-circle';
        } else {
            element.classList.remove('requirement-met');
            element.classList.add('requirement-unmet');
            element.querySelector('i').className = 'fas fa-circle';
            element.querySelector('i').style.fontSize = '0.5em';
        }
    }

    function validateForm() {
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;

        if (username.length < 3) {
            alert('O usuário deve ter no mínimo 3 caracteres!');
            return false;
        }

        if (password.length < 6) {
            alert('A senha deve ter no mínimo 6 caracteres!');
            return false;
        }

        if (!/[a-zA-Z]/.test(password)) {
            alert('A senha deve conter pelo menos uma letra!');
            return false;
        }

        return true;
    }
</script>
</body>
</html>