package com.vitorsaucedo.todolist.exceptions;

public class TaskAlreadyFinishedException extends RuntimeException {
    public TaskAlreadyFinishedException(String message) {
        super(message);
    }
}