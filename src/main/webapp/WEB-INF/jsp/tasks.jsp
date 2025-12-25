<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciador de Tarefas</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">

    <style>
        .task-done span { text-decoration: line-through; color: #888; }
        .btn-icon { background: none; border: none; cursor: pointer; padding: 5px; font-size: 1.1rem; transition: all 0.2s; }
        .btn-icon:hover { transform: scale(1.2); }
        .text-warning { color: #f0ad4e; }
        .text-danger { color: #d9534f; }
        .text-success { color: #5cb85c; }
        .alert { padding: 10px; margin: 10px 0; border-radius: 4px; text-align: center; animation: slideDown 0.3s ease; }
        .alert-success { background-color: #dff0d8; color: #3c763d; border: 1px solid #c3e6cb; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .task-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #fff;
            padding: 15px;
            margin-bottom: 8px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: all 0.2s;
        }

        .task-item:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            transform: translateY(-2px);
        }

        .task-content {
            flex-grow: 1;
            padding-right: 10px;
        }

        .task-name {
            display: block;
            font-size: 1.1em;
            font-weight: 600;
            margin-bottom: 4px;
            color: #333;
        }

        .task-description {
            color: #666;
            font-size: 0.9em;
        }

        .task-date {
            color: #999;
            font-size: 0.75em;
            font-style: italic;
            margin-top: 4px;
        }

        .task-actions {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #999;
        }

        .empty-state i {
            font-size: 3em;
            margin-bottom: 10px;
            opacity: 0.3;
        }

        .logout-btn {
            background: transparent;
            color: var(--danger-color);
            border: none;
            cursor: pointer;
            padding: 8px 12px;
            border-radius: 6px;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .logout-btn:hover {
            background: rgba(231, 76, 60, 0.1);
        }
    </style>
</head>
<body>
<div class="container">
    <header>
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h1>Minhas Tarefas</h1>
                <p>Organize seu dia com eficiência</p>
            </div>
            <form action="${pageContext.request.contextPath}/logout" method="post" style="margin: 0;">
                <!-- Token CSRF (quando habilitar) -->
                <%-- <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> --%>
                <button type="submit" class="logout-btn" title="Sair da conta">
                    <i class="fas fa-sign-out-alt"></i> Sair
                </button>
            </form>
        </div>
    </header>

    <!-- Mensagens de Feedback -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> ${successMessage}
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i> ${errorMessage}
        </div>
    </c:if>

    <!-- Formulário de Nova Tarefa -->
    <section class="input-group">
        <form action="${pageContext.request.contextPath}/tasks/create" method="post" style="display: flex; width: 100%; gap: 10px;">
            <input type="text"
                   name="name"
                   placeholder="O que precisa ser feito?"
                   maxlength="255"
                   required
                   style="flex: 2;"
                   autocomplete="off">
            <input type="text"
                   name="description"
                   placeholder="Descrição (opcional)"
                   maxlength="1000"
                   style="flex: 2;"
                   autocomplete="off">
            <button type="submit" style="flex: 1;">
                <i class="fas fa-plus"></i> Adicionar
            </button>
        </form>
    </section>

    <!-- Filtros -->
    <div class="filters">
        <button class="filter-btn ${activeTab == 'all' ? 'active' : ''}"
                onclick="window.location.href='${pageContext.request.contextPath}/tasks'">
            Todas <c:if test="${activeTab == 'all'}"><small>(${tasks.size()})</small></c:if>
        </button>
        <button class="filter-btn ${activeTab == 'pending' ? 'active' : ''}"
                onclick="window.location.href='${pageContext.request.contextPath}/tasks/pending'">
            Pendentes <c:if test="${activeTab == 'pending'}"><small>(${tasks.size()})</small></c:if>
        </button>
        <button class="filter-btn ${activeTab == 'finished' ? 'active' : ''}"
                onclick="window.location.href='${pageContext.request.contextPath}/tasks/finished'">
            Concluídas <c:if test="${activeTab == 'finished'}"><small>(${tasks.size()})</small></c:if>
        </button>
    </div>

    <!-- Lista de Tarefas -->
    <ul id="taskList">
        <c:forEach items="${tasks}" var="task">
            <li class="task-item ${task.isFinished ? 'task-done' : ''}">
                <div class="task-content">
                    <span class="task-name">
                        <c:choose>
                            <c:when test="${task.isFinished}">
                                <i class="fas fa-check-circle" style="color: var(--primary-color);"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="far fa-circle" style="color: #ccc;"></i>
                            </c:otherwise>
                        </c:choose>
                        <c:out value="${task.name}"/>
                    </span>
                    <c:if test="${not empty task.description}">
                        <div class="task-description">
                            <c:out value="${task.description}"/>
                        </div>
                    </c:if>
                    <div class="task-date">
                        <i class="far fa-clock"></i>
                        <spring:eval expression="task.creationDate" />
                    </div>
                </div>

                <div class="task-actions">
                    <!-- Toggle Status -->
                    <a href="${pageContext.request.contextPath}/tasks/toggle/${task.id}"
                       class="btn-icon text-success"
                       title="${task.isFinished ? 'Reabrir tarefa' : 'Marcar como concluída'}">
                        <i class="fas ${task.isFinished ? 'fa-undo' : 'fa-check'}"></i>
                    </a>

                    <!-- Editar -->
                    <button type="button"
                            class="btn-icon text-warning"
                            onclick="openEditModal('${task.id}', '${fn:escapeXml(task.name)}', '${fn:escapeXml(task.description)}')"
                            title="Editar tarefa">
                        <i class="fas fa-pencil-alt"></i>
                    </button>

                    <!-- Deletar -->
                    <a href="${pageContext.request.contextPath}/tasks/delete/${task.id}"
                       class="btn-icon text-danger"
                       onclick="return confirm('Tem certeza que deseja excluir a tarefa: ${fn:escapeXml(task.name)}?');"
                       title="Excluir tarefa">
                        <i class="fas fa-trash"></i>
                    </a>
                </div>
            </li>
        </c:forEach>

        <!-- Estado Vazio -->
        <c:if test="${empty tasks}">
            <div class="empty-state">
                <i class="fas fa-tasks"></i>
                <p style="font-size: 1.1em; margin-top: 10px;">
                    <c:choose>
                        <c:when test="${activeTab == 'pending'}">
                            Nenhuma tarefa pendente! 🎉
                        </c:when>
                        <c:when test="${activeTab == 'finished'}">
                            Nenhuma tarefa concluída ainda.
                        </c:when>
                        <c:otherwise>
                            Nenhuma tarefa encontrada.<br>
                            <small>Adicione uma nova tarefa acima para começar!</small>
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
        </c:if>
    </ul>
</div>

<!-- Modal de Edição -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <h2><i class="fas fa-edit"></i> Editar Tarefa</h2>

        <form id="editForm" method="post">
            <div class="form-group">
                <label for="editName">Nome da Tarefa *</label>
                <input type="text"
                       name="name"
                       id="editName"
                       required
                       maxlength="255"
                       autocomplete="off">
            </div>
            <div class="form-group">
                <label for="editDesc">Descrição</label>
                <textarea name="description"
                          id="editDesc"
                          rows="3"
                          maxlength="1000"
                          placeholder="Adicione detalhes sobre a tarefa..."></textarea>
            </div>
            <button type="submit" class="save-btn">
                <i class="fas fa-save"></i> Salvar Alterações
            </button>
        </form>
    </div>
</div>

<script>

    function openEditModal(id, name, desc) {
        const modal = document.getElementById('editModal');
        const form = document.getElementById('editForm');
        const nameInput = document.getElementById('editName');
        const descInput = document.getElementById('editDesc');

        // Decodifica HTML entities (proteção XSS)
        const textarea = document.createElement('textarea');
        textarea.innerHTML = name;
        const decodedName = textarea.value;

        textarea.innerHTML = desc;
        const decodedDesc = textarea.value;

        nameInput.value = decodedName;
        descInput.value = decodedDesc;
        form.action = '${pageContext.request.contextPath}/tasks/update/' + id;

        modal.style.display = 'block';
        nameInput.focus();
    }

    function closeModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    // Fechar modal ao clicar fora
    window.onclick = function(event) {
        const modal = document.getElementById('editModal');
        if (event.target === modal) {
            closeModal();
        }
    }

    // Fechar modal com ESC
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeModal();
        }
    });

    // Auto-hide alerts após 5 segundos
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 500);
        });
    }, 5000);
</script>
</body>
</html>