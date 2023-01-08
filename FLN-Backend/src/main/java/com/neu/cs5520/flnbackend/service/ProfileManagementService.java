package com.neu.cs5520.flnbackend.service;

import com.neu.cs5520.flnbackend.dao.AccountDAO;
import com.neu.cs5520.flnbackend.model.Account;
import java.io.IOException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ProfileManagementService {

  private static final String FILEPATH_FORMATTER = "%s/%s/%s/";
  private static final String DATA_FOLDER = "data";
  private static final String USER_FOLDER = "user";
  private static final String PROFILE_IMAGE_NAME = "profile_image";

  private final AccountDAO accountDAO;

  private final StorageService storageService;

  @Autowired
  public ProfileManagementService(AccountDAO accountDAO, StorageService storageService) {
    this.accountDAO = accountDAO;
    this.storageService = storageService;
  }

  public Account addAccount(Account account) {
    return accountDAO.save(account);
  }

  public Account updateAccount(Account account, MultipartFile multipartFile) throws IOException {
    return uploadProfileImageAndSave(account, multipartFile);
  }

  public Account readProfile(String accountId) {
    return accountDAO.findById(accountId).orElseThrow();
  }

  private Account uploadProfileImageAndSave(Account account, MultipartFile multipartFile)
      throws IOException {
    if(multipartFile!=null){
      String filePath = FILEPATH_FORMATTER.formatted(DATA_FOLDER, USER_FOLDER, account.getId());
      String awsLocation = storageService.uploadFile(multipartFile, filePath, PROFILE_IMAGE_NAME);
      account.setProfileImageLocation(awsLocation);
    }else{
      account.setProfileImageLocation(accountDAO.findById(account.getId()).orElseThrow().getProfileImageLocation());
    }
    return accountDAO.save(account);
  }

}
