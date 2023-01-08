package com.neu.cs5520.flnbackend.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import java.io.Serializable;
import java.util.List;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.CascadeType;
import org.hibernate.annotations.LazyCollection;
import org.hibernate.annotations.LazyCollectionOption;

@Getter
@Setter
@Entity
public class Event implements Serializable {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private long id;

  @ManyToOne(fetch = FetchType.LAZY)
  @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
  @JoinColumn(name = "account_id", nullable = false)
  private Account account;

  @OneToMany(mappedBy = "event")
  @Cascade(CascadeType.ALL)
  @JsonManagedReference
  @LazyCollection(LazyCollectionOption.FALSE)
  private List<EventImage> eventImages;

  @OneToMany(mappedBy = "event", fetch = FetchType.EAGER)
  @JsonBackReference
  private List<Application> applications;

  private String videoLocation;

  private boolean isClosed;
}
