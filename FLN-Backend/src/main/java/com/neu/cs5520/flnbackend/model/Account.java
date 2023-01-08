package com.neu.cs5520.flnbackend.model;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
public class Account implements Serializable {

  @Id
  @Column(length = 50, nullable = false)
  private String id;

  @Column(length = 62, nullable = false)
  private String email;

  @Column(length = 50)
  private String firstName;

  @Column(length = 50)
  private String lastName;

  int age;

  private String link;

  @Column(length = 100)
  private String description;

  @Column(length = 26)
  private String phone;

  @Column(length = 15)
  private String gender;

  private String profileImageLocation;

  @Column(length = 50)
  private String interest1;

  @Column(length = 50)
  private String interest2;

  @Column(length = 50)
  private String interest3;

}
