package com.vitorsaucedo.todolist.controllers;

import com.vitorsaucedo.todolist.dtos.TaskDto;
import com.vitorsaucedo.todolist.services.TaskService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/tasks")
@RequiredArgsConstructor
public class TaskController {

    private final TaskService taskService;

    @GetMapping
    public String listAll(Model model) {
        List<TaskDto> tasks = taskService.listAll();
        model.addAttribute("tasks", tasks);
        model.addAttribute("activeTab", "all");
        model.addAttribute("newTask", new TaskDto(null, "", "", false, null)); // Para o form
        return "tasks";
    }

    @GetMapping("/pending")
    public String listPending(Model model) {
        List<TaskDto> tasks = taskService.listPending();
        model.addAttribute("tasks", tasks);
        model.addAttribute("activeTab", "pending");
        model.addAttribute("newTask", new TaskDto(null, "", "", false, null));
        return "tasks";
    }

    @GetMapping("/finished")
    public String listFinished(Model model) {
        List<TaskDto> tasks = taskService.listFinished();
        model.addAttribute("tasks", tasks);
        model.addAttribute("activeTab", "finished");
        model.addAttribute("newTask", new TaskDto(null, "", "", false, null));
        return "tasks";
    }

    @PostMapping("/create")
    public String create(@Valid @ModelAttribute TaskDto taskDto,
                         BindingResult result,
                         RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    result.getAllErrors().get(0).getDefaultMessage());
            return "redirect:/tasks";
        }

        taskService.create(taskDto);
        redirectAttributes.addFlashAttribute("successMessage", "Tarefa adicionada!");
        return "redirect:/tasks";
    }

    @PatchMapping("/toggle/{id}")
    public String toggleStatus(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        taskService.changeStatus(id);
        redirectAttributes.addFlashAttribute("successMessage", "Status alterado!");
        return "redirect:/tasks";
    }

    @DeleteMapping("/delete/{id}")
    public String delete(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        taskService.delete(id);
        redirectAttributes.addFlashAttribute("successMessage", "Tarefa removida.");
        return "redirect:/tasks";
    }

    @PostMapping("/update/{id}")
    public String update(@PathVariable Long id,
                         @Valid @ModelAttribute TaskDto taskDto,
                         BindingResult result,
                         RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    result.getAllErrors().get(0).getDefaultMessage());
            return "redirect:/tasks";
        }

        taskService.update(id, taskDto);
        redirectAttributes.addFlashAttribute("successMessage", "Tarefa atualizada!");
        return "redirect:/tasks";
    }
}