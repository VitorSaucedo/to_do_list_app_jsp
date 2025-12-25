package com.vitorsaucedo.todolist.services;

import com.vitorsaucedo.todolist.dtos.TaskDto;
import com.vitorsaucedo.todolist.entities.Task;
import com.vitorsaucedo.todolist.entities.User;
import com.vitorsaucedo.todolist.exceptions.InvalidTaskDataException;
import com.vitorsaucedo.todolist.exceptions.TaskAlreadyFinishedException;
import com.vitorsaucedo.todolist.exceptions.TaskNotFoundException;
import com.vitorsaucedo.todolist.exceptions.UnauthorizedAccessException;
import com.vitorsaucedo.todolist.repositories.TaskRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class TaskService {

    private final TaskRepository taskRepository;

    private User getAuthenticatedUser() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof User user) { // ← Pattern matching (Java 16+)
            return user;
        }

        throw new UnauthorizedAccessException("Usuário não está autenticado corretamente.");
    }

    public List<TaskDto> listAll() {
        return taskRepository.findAllByUserOrderByCreationDateDesc(getAuthenticatedUser())
                .stream()
                .map(this::toDto)
                .toList(); // ← Mais moderno que collect(Collectors.toList())
    }

    public List<TaskDto> listPending() {
        return taskRepository.findPendingTasks(getAuthenticatedUser())
                .stream()
                .map(this::toDto)
                .toList();
    }

    public List<TaskDto> listFinished() {
        return taskRepository.findFinishedTasks(getAuthenticatedUser())
                .stream()
                .map(this::toDto)
                .toList();
    }

    public void create(TaskDto taskDto) {
        // Validação de dados
        if (taskDto.name() == null || taskDto.name().trim().isEmpty()) {
            throw new InvalidTaskDataException("O nome da tarefa não pode ser vazio");
        }
        
        if (taskDto.name().length() > 255) {
            throw new InvalidTaskDataException("O nome da tarefa não pode ter mais de 255 caracteres");
        }
        
        if (taskDto.description() != null && taskDto.description().length() > 1000) {
            throw new InvalidTaskDataException("A descrição da tarefa não pode ter mais de 1000 caracteres");
        }

        User user = getAuthenticatedUser();
        Task task = new Task();

        task.setUser(user);
        task.setName(taskDto.name());
        task.setDescription(taskDto.description());
        task.setFinished(false);

        taskRepository.save(task);
    }

    public void changeStatus(Long id) {
        Task task = findTaskAndValidateOwnership(id);
        
        // Verifica se já está finalizada
        if (task.isFinished()) {
            throw new TaskAlreadyFinishedException("Esta tarefa já está finalizada");
        }
        
        task.setFinished(!task.isFinished());
        taskRepository.save(task);
    }

    public void delete(Long id) {
        Task task = findTaskAndValidateOwnership(id);
        taskRepository.delete(task);
    }

    public void update(Long id, TaskDto taskDto) {
        // Validação de dados
        if (taskDto.name() == null || taskDto.name().trim().isEmpty()) {
            throw new InvalidTaskDataException("O nome da tarefa não pode ser vazio");
        }
        
        if (taskDto.name().length() > 255) {
            throw new InvalidTaskDataException("O nome da tarefa não pode ter mais de 255 caracteres");
        }
        
        if (taskDto.description() != null && taskDto.description().length() > 1000) {
            throw new InvalidTaskDataException("A descrição da tarefa não pode ter mais de 1000 caracteres");
        }

        Task task = findTaskAndValidateOwnership(id);
        task.setName(taskDto.name());
        task.setDescription(taskDto.description());
        taskRepository.save(task);
    }

    private Task findTaskAndValidateOwnership(Long id) {
        User user = getAuthenticatedUser();
        Task task = taskRepository.findById(id)
                .orElseThrow(() -> new TaskNotFoundException("Tarefa não encontrada"));

        if (!task.getUser().getId().equals(user.getId())) {
            throw new UnauthorizedAccessException("Acesso Negado: Esta tarefa não pertence a você.");
        }
        return task;
    }

    private TaskDto toDto(Task task) {
        return new TaskDto(
                task.getId(),
                task.getName(),
                task.getDescription(),
                task.isFinished(),
                task.getCreationDate()
        );
    }
}