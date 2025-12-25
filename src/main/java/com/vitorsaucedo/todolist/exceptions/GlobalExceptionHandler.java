package com.vitorsaucedo.todolist.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.validation.BindException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@ControllerAdvice
public class GlobalExceptionHandler {

    // Exceções de validação
    @ExceptionHandler(InvalidTaskDataException.class)
    public String handleInvalidTaskData(InvalidTaskDataException ex, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        return "redirect:/tasks";
    }

    @ExceptionHandler(InvalidCredentialsException.class)
    public String handleInvalidCredentials(InvalidCredentialsException ex, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        return "redirect:/login";
    }

    // Exceções de negócio
    @ExceptionHandler(TaskAlreadyFinishedException.class)
    public String handleTaskAlreadyFinished(TaskAlreadyFinishedException ex, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        return "redirect:/tasks";
    }

    @ExceptionHandler(DuplicateUserException.class)
    public String handleDuplicateUser(DuplicateUserException ex, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        return "redirect:/register";
    }

    @ExceptionHandler(TaskNotFoundException.class)
    public String handleTaskNotFound(TaskNotFoundException ex, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        return "redirect:/tasks";
    }

    @ExceptionHandler(UnauthorizedAccessException.class)
    public String handleUnauthorizedAccess(UnauthorizedAccessException ex, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        return "redirect:/tasks";
    }

    // Validação Spring
    @ExceptionHandler(BindException.class)
    public String handleBindException(BindException ex, RedirectAttributes redirectAttributes) {
        String errorMessage = ex.getBindingResult().getAllErrors().get(0).getDefaultMessage();
        redirectAttributes.addFlashAttribute("errorMessage", errorMessage);
        return "redirect:/tasks";
    }

    // Exceção genérica
    @ExceptionHandler(Exception.class)
    public String handleGenericException(Exception ex, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("errorMessage", "Ocorreu um erro inesperado: " + ex.getMessage());
        return "redirect:/tasks";
    }
}