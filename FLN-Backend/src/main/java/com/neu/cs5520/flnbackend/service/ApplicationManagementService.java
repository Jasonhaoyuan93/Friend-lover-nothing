package com.neu.cs5520.flnbackend.service;

import com.neu.cs5520.flnbackend.dao.ApplicationDAO;
import com.neu.cs5520.flnbackend.dao.EventDAO;
import com.neu.cs5520.flnbackend.model.Application;
import java.io.IOException;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ApplicationManagementService {

  private static final String FILEPATH_FORMATTER = "%s/%s/%s/";
  private static final String DATA_FOLDER = "data";
  private static final String APPLICATION_FOLDER = "application";
  private static final String APPLICATION_ID_FORMAT = "(%d,%s)";
  private static final String VIDEO_FILE_NAME = "intro_video";

  private final ApplicationDAO applicationDAO;
  private final EventDAO eventDAO;

  private final StorageService storageService;

  @Autowired
  public ApplicationManagementService(ApplicationDAO applicationDAO, EventDAO eventDAO,
      StorageService storageService) {
    this.applicationDAO = applicationDAO;
    this.eventDAO = eventDAO;
    this.storageService = storageService;
  }

  public Application applyForEvent(Application application, MultipartFile video)
      throws IOException {
    String awsS3Location = storageService.uploadFile(video,
        FILEPATH_FORMATTER.formatted(DATA_FOLDER, APPLICATION_FOLDER, APPLICATION_ID_FORMAT
            .formatted(application.getEvent().getId(), application.getAccount().getId())),
        VIDEO_FILE_NAME);
    application.setCloudVideoFileLocation(awsS3Location);
    return applicationDAO.save(application);
  }

  public void updateApplication(Application application) {
    applicationDAO.closeApplication(application.getAccount().getId(), application.getEvent().getId(), application.isApproved());
  }

  public void deleteApplication(long eventId, String accountId) {
    applicationDAO.deleteByIds(accountId, eventId);
  }

  public List<Application> readApplicationsOfApplicant(String applicantId) {
    return applicationDAO.getAllApplicationOfAccount(applicantId).stream().toList();
  }

  public List<Application> readApplicationsOfOwner(String ownerAccountId) {
    return eventDAO.findPlacedApplication(ownerAccountId);
  }
}
