package com.neu.cs5520.flnbackend.model;


import java.io.Serial;
import java.io.Serializable;
import javax.persistence.Embeddable;
import lombok.Getter;
import lombok.Setter;

@Embeddable
@Getter
@Setter
public class ApplicationId implements Serializable {

  @Serial
  private static final long serialVersionUID = -9134918975669684534L;

  private long eventId;

  private String accountId;

  public ApplicationId(long eventId, String accountId) {
    this.eventId = eventId;
    this.accountId = accountId;
  }

  public ApplicationId() {
  }
}
