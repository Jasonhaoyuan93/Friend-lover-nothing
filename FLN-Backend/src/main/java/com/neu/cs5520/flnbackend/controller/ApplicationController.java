package com.neu.cs5520.flnbackend.controller;

import com.neu.cs5520.flnbackend.model.Application;
import com.neu.cs5520.flnbackend.service.ApplicationManagementService;
import java.io.IOException;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class ApplicationController {

  private final ApplicationManagementService applicationManagementService;

  @Autowired
  ApplicationController(ApplicationManagementService applicationManagementService){
    this.applicationManagementService = applicationManagementService;
  }

  @PostMapping("/application/create/")
  public Application createApplication(@RequestPart Application application, @RequestPart
      MultipartFile video) throws IOException {
    return applicationManagementService.applyForEvent(application, video);
  }

  @PostMapping("/application/closeApplication/")
  public void updateApplication(@RequestBody Application application){
    applicationManagementService.updateApplication(application);
  }

  @GetMapping("/application/applicant/{applicantId}")
  public List<Application> readApplicationsOfApplicant(@PathVariable String applicantId){
    return applicationManagementService.readApplicationsOfApplicant(applicantId);
  }

  @GetMapping("/application/owner/{ownersId}")
  public List<Application> readApplicationsOfOwner(@PathVariable String ownersId){
    return applicationManagementService.readApplicationsOfOwner(ownersId);
  }

  @DeleteMapping("/application/{eventId}/{accountId}")
  public void deleteApplication(@PathVariable long eventId, @PathVariable String accountId){
    applicationManagementService.deleteApplication(eventId, accountId);
  }
}
