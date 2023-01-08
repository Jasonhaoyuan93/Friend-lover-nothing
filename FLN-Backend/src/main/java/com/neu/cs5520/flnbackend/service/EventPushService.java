package com.neu.cs5520.flnbackend.service;

import com.neu.cs5520.flnbackend.dao.EventDAO;
import com.neu.cs5520.flnbackend.model.Event;
import java.util.LinkedList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class EventPushService {


  private final EventDAO eventDAO;

  @Autowired
  public EventPushService(EventDAO eventDAO) {
    this.eventDAO = eventDAO;
  }

  public List<Event> obtainRecommendedEvents(String accountId){
    List<Event> events = new LinkedList<>();
    List<Event> allEvents = eventDAO.findRecentEvents();
    for (int i = 0; i < 10 && i< allEvents.size(); i++) {
      events.add(allEvents.get(i));
    }
    return events;
  }

}
