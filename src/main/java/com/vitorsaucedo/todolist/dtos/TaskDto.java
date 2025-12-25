package com.vitorsaucedo.todolist.dtos;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;

public record TaskDto(
        Long id,

        @NotBlank(message = "O nome da tarefa não pode ser vazio")
        @Size(max = 255, message = "Máximo de 255 caracteres")
        String name,

        @Size(max = 1000, message = "Máximo de 1000 caracteres")
        String description,

        Boolean isFinished,

        LocalDateTime creationDate
) {
        public static TaskDto forCreation(String name, String description) {
                return new TaskDto(null, name, description, false, null);
        }
}