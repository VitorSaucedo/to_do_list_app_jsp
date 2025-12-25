package com.vitorsaucedo.todolist.services;

import com.vitorsaucedo.todolist.exceptions.InvalidCredentialsException;
import com.vitorsaucedo.todolist.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthorizationService implements UserDetailsService {

    private final UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        UserDetails user = userRepository.findByLogin(username);

        if (user == null) {
            throw new InvalidCredentialsException("Usuário ou senha inválidos.");
        }

        return user;
    }
}