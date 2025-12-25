package com.vitorsaucedo.todolist.controllers;

import com.vitorsaucedo.todolist.dtos.AuthenticationDto;
import com.vitorsaucedo.todolist.entities.User;
import com.vitorsaucedo.todolist.exceptions.DuplicateUserException;
import com.vitorsaucedo.todolist.exceptions.InvalidCredentialsException;
import com.vitorsaucedo.todolist.repositories.UserRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
public class AuthenticationController {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @GetMapping("/login")
    public String loginPage(
            Model model,
            @RequestParam(required = false) String error,
            @RequestParam(required = false) String logout
    ) {
        if (error != null) {
            model.addAttribute("errorMessage", "Usuário ou senha inválidos.");
        }
        if (logout != null) {
            model.addAttribute("successMessage", "Você saiu do sistema.");
        }
        return "login";
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("authDto", new AuthenticationDto("", ""));
        return "register";
    }

    @PostMapping("/auth/register")
    public String registerUser(@Valid @ModelAttribute AuthenticationDto data,
                               BindingResult result,
                               RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    result.getAllErrors().get(0).getDefaultMessage());
            return "redirect:/register";
        }

        if (userRepository.findByLogin(data.login()) != null) {
            throw new DuplicateUserException("Este usuário já existe!");
        }

        if (data.password().length() < 6) {
            throw new InvalidCredentialsException("A senha deve ter no mínimo 6 caracteres!");
        }

        try {
            String encryptedPassword = passwordEncoder.encode(data.password());
            User newUser = new User(null, data.login(), encryptedPassword);
            userRepository.save(newUser);

            redirectAttributes.addFlashAttribute("successMessage", "Conta criada com sucesso! Faça login.");
            return "redirect:/login";

        } catch (DuplicateUserException | InvalidCredentialsException e) {
            throw e; // Deixa o @ControllerAdvice tratar
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erro ao criar conta: " + e.getMessage());
            return "redirect:/register";
        }
    }
}