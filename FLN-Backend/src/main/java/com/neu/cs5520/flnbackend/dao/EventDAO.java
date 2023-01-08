package com.neu.cs5520.flnbackend.dao;

import com.neu.cs5520.flnbackend.model.Application;
import com.neu.cs5520.flnbackend.model.Event;
import java.util.List;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

public interface EventDAO extends CrudRepository<Event, Long> {

  @Query("select e from Event e where e.account.id = ?1 and e.isClosed=false")
  List<Event> findByAccountId(String accountId);

  @Query("select e from Event e where e.isClosed=false order by e.id desc")
  List<Event> findRecentEvents();

  @Query("select a from Application a where a.event in (select e from Event as e  where e.account.id=?1 and e.isClosed=false and a.isClosed=false)")
  List<Application> findPlacedApplication(String accountId);
}
