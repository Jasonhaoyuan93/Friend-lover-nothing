package com.neu.cs5520.flnbackend.controller;

import com.neu.cs5520.flnbackend.model.ErrorResponse;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ControllerErrorHandler {

  @ResponseStatus(HttpStatus.BAD_REQUEST)
  @ExceptionHandler(Exception.class)
  public ErrorResponse handleConflict(Exception exception) {
    exception.printStackTrace();
    return new ErrorResponse(HttpStatus.BAD_REQUEST, exception.getMessage());
  }

}
