package com.neu.cs5520.flnbackend.controller;

import com.neu.cs5520.flnbackend.model.Account;
import com.neu.cs5520.flnbackend.service.ProfileManagementService;
import java.io.IOException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class AccountController {

  private final ProfileManagementService profileManagementService;

  @Autowired
  AccountController(ProfileManagementService profileManagementService){
    this.profileManagementService = profileManagementService;
  }

  @PostMapping("/account/create/")
  public Account createAccount(@RequestBody Account account){
    return profileManagementService.addAccount(account);
  }
  @PostMapping("/account/update/")
  public Account updateAccount(@RequestPart Account account, @RequestPart(value = "file", required = false) MultipartFile multipartFile)
      throws IOException {
    return profileManagementService.updateAccount(account, multipartFile);
  }

  @GetMapping("/account/{accountId}")
  public Account readAccount(@PathVariable String accountId){
    return profileManagementService.readProfile(accountId);
  }

}
