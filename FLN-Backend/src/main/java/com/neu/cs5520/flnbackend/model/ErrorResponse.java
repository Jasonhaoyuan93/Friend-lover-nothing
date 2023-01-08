package com.neu.cs5520.flnbackend.model;

import lombok.Getter;
import lombok.Setter;
import org.springframework.http.HttpStatus;

@Getter
@Setter
public class ErrorResponse {

  private HttpStatus httpStatus;

  private String errorCause;

  public ErrorResponse(HttpStatus httpStatus, String errorCause) {
    this.httpStatus = httpStatus;
    this.errorCause = errorCause;
  }
}
