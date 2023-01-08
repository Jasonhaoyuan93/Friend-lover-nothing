package com.neu.cs5520.flnbackend.controller;


import com.neu.cs5520.flnbackend.model.Event;
import com.neu.cs5520.flnbackend.service.EventManagementService;
import com.neu.cs5520.flnbackend.service.EventPushService;
import java.io.IOException;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class EventController {

  private final EventManagementService eventManagementService;
  private final EventPushService eventPushService;

  @Autowired
  EventController(EventManagementService eventManagementService, EventPushService eventPushService){
    this.eventPushService = eventPushService;
    this.eventManagementService = eventManagementService;
  }

  @PostMapping("/event/create/")
  public Event createEvent(@RequestPart Event event, @RequestPart(required = false) MultipartFile[] images, @RequestPart(required = false) MultipartFile video)
      throws IOException {
    event.getEventImages().forEach(eventImage -> eventImage.setEvent(event));
    return eventManagementService.addEvent(event, images, video);
  }
  @PostMapping("/event/update/")
  public Event updateEvent(@RequestPart Event event, @RequestPart(required = false) MultipartFile[] images, @RequestPart(required = false) MultipartFile video)
      throws IOException {
    event.getEventImages().forEach(eventImage -> eventImage.setEvent(event));
    return eventManagementService.updateEvent(event, images, video);
  }
  @DeleteMapping("/event/{eventId}")
  public void deleteEvent(@PathVariable long eventId){
    eventManagementService.deleteEvent(eventId);
  }

  @GetMapping("/event/{accountId}")
  public List<Event> getRecommendedEvents(@PathVariable String accountId){
    return eventPushService.obtainRecommendedEvents(accountId);
  }

  @GetMapping("/event/manage/{accountId}")
  public List<Event> getEventsOfCustomer(@PathVariable String accountId){
    return eventManagementService.getEventOfCustomer(accountId);
  }

}
