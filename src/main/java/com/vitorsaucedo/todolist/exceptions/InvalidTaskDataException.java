package com.vitorsaucedo.todolist.exceptions;

public class InvalidTaskDataException extends RuntimeException {
    public InvalidTaskDataException(String message) {
        super(message);
    }
}