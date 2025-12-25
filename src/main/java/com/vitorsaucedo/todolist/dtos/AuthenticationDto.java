package com.vitorsaucedo.todolist.dtos;

import jakarta.validation.constraints.NotBlank;

public record AuthenticationDto(
        @NotBlank(message = "Login is required")
        String login,

        @NotBlank(message = "Password is required")
        String password
) {
}