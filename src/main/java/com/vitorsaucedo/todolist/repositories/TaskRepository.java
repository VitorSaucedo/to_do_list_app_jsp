package com.vitorsaucedo.todolist.repositories;

import com.vitorsaucedo.todolist.entities.Task;
import com.vitorsaucedo.todolist.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface TaskRepository extends JpaRepository<Task, Long> {

    // Busca todas as tarefas do usuário logado
    List<Task> findAllByUserOrderByCreationDateDesc(User user);

    // Busca pendentes
    @Query("SELECT t FROM Task t WHERE t.user = :user AND t.isFinished = false ORDER BY t.creationDate DESC")
    List<Task> findPendingTasks(@Param("user") User user);

    // Busca finalizadas
    @Query("SELECT t FROM Task t WHERE t.user = :user AND t.isFinished = true ORDER BY t.creationDate DESC")
    List<Task> findFinishedTasks(@Param("user") User user);
}