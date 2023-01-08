package com.neu.cs5520.flnbackend.service;

import com.neu.cs5520.flnbackend.dao.EventDAO;
import com.neu.cs5520.flnbackend.model.Event;
import com.neu.cs5520.flnbackend.model.EventImage;
import java.io.IOException;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class EventManagementService {

  private static final String FILEPATH_FORMATTER = "%s/%s/%s/";
  private static final String DATA_FOLDER = "data";
  private static final String EVENT_FOLDER = "event";
  private static final String VIDEO_FILE_NAME = "intro_video";
  private static final String EVENT_IMAGE_NAME = "image_%d";

  private final EventDAO eventDAO;
  private final StorageService storageService;

  @Autowired
  public EventManagementService(EventDAO eventDAO, StorageService storageService) {
    this.eventDAO = eventDAO;
    this.storageService = storageService;
  }

  public Event addEvent(Event event, MultipartFile[] images, MultipartFile video)
      throws IOException {

    //obtain generated ID
    Event generatedEvent = eventDAO.save(event);

    return updateVideoAndImages(generatedEvent, images, video);
  }



  public void deleteEvent(long eventId){
    eventDAO.deleteById(eventId);
  }

  public Event updateEvent(Event event, MultipartFile[] images, MultipartFile video)
      throws IOException {
    return updateVideoAndImages(event, images, video);
  }

  public List<Event> getEventOfCustomer(String accountId){
    return eventDAO.findByAccountId(accountId);
  }

  private Event updateVideoAndImages(Event event, MultipartFile[] images, MultipartFile video)
      throws IOException {

    //video
    if(video!=null){
      String filePath = FILEPATH_FORMATTER.formatted(DATA_FOLDER, EVENT_FOLDER, event.getId());
      String awsLocation = storageService.uploadFile(video, filePath, VIDEO_FILE_NAME);
      event.setVideoLocation(awsLocation);
    }

    if(images!=null){
      //images
      for (int i = 0; i < images.length ; i++) {
        String filePath = FILEPATH_FORMATTER.formatted(DATA_FOLDER, EVENT_FOLDER, event.getId());
        String awsLocation = storageService.uploadFile(images[i], filePath, EVENT_IMAGE_NAME.formatted(i));
        if(i<event.getEventImages().size()){
          event.getEventImages().get(i).setImageLocation(awsLocation);
        }else{
          EventImage eventImage = new EventImage();
          eventImage.setImageLocation(awsLocation);
          eventImage.setEvent(event);
          event.getEventImages().add(eventImage);
        }
      }
    }

    //update
    event = eventDAO.save(event);
    return event;
  }

}
