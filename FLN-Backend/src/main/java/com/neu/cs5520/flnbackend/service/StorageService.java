package com.neu.cs5520.flnbackend.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.PutObjectRequest;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
@Slf4j
public class StorageService {

  private static final String DOT = ".";
  private static final String DATE_STAMP_PATTERN = "yyddMMhhmmss";

  @Value("${application.bucket.name}")
  private String bucketName;

  private final AmazonS3 s3Client;

  @Autowired
  public StorageService(AmazonS3 s3Client) {
    this.s3Client = s3Client;
  }

  public String uploadFile(MultipartFile file, String awsPath, String fileName) throws IOException {
    String fileExtension = FilenameUtils.getExtension(file.getOriginalFilename());
    String timeStamp = new SimpleDateFormat(DATE_STAMP_PATTERN).format(new Date());
    String awsFullPath = awsPath+fileName+timeStamp+DOT+fileExtension;
    File dir = new File(awsPath);
    if(!dir.exists()&&!dir.mkdirs()){
      throw new IOException("local folder creation failed");
    }
    File convFile = new File(awsFullPath);
    try(FileOutputStream fos = new FileOutputStream(convFile)){
      fos.write(file.getBytes());
    }
    PutObjectRequest request = new PutObjectRequest(bucketName, awsFullPath, convFile)
        .withCannedAcl(CannedAccessControlList.PublicRead);
    s3Client.putObject(request);
    log.info("File uploaded to AWS S3: %s".formatted(fileName));
    if(!convFile.delete()){
      log.error("file delete failed for file: " + convFile.getAbsolutePath());
    }
    return  s3Client.getUrl(bucketName, awsFullPath).toString();
  }

}
