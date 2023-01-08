package com.neu.cs5520.flnbackend.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
public class Application implements Serializable {

  @ManyToOne
  @JoinColumn(nullable = false)
  private Event event;

  @OneToOne
  @JoinColumn(nullable = false)
  private Account account;

  @Id
  private String cloudVideoFileLocation;

  private boolean isApproved;

  private boolean isClosed;

}
