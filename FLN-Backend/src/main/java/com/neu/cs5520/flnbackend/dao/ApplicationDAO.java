package com.neu.cs5520.flnbackend.dao;

import com.neu.cs5520.flnbackend.model.Application;
import java.util.List;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.lang.NonNull;
import org.springframework.transaction.annotation.Transactional;

public interface ApplicationDAO extends CrudRepository<Application, String> {

  @Query("select a from Application a where a.account.id = ?1")
  List<Application> getAllApplicationOfAccount(String accountId);

  @Transactional
  @Modifying
  @Query("delete from Application a where a.account.id = ?1 and a.event.id = ?2")
  void deleteByIds(@NonNull String accountId, @NonNull long eventId);

  @Transactional
  @Modifying
  @Query("update Application a set a.isClosed=true, a.isApproved=?3 where a.account.id = ?1 and a.event.id = ?2")
  void closeApplication(@NonNull String accountId, @NonNull long eventId, boolean isApproved);

}
