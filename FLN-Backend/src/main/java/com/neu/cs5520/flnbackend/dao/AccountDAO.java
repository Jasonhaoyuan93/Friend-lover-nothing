package com.neu.cs5520.flnbackend.dao;

import com.neu.cs5520.flnbackend.model.Account;
import org.springframework.data.repository.CrudRepository;

public interface AccountDAO extends CrudRepository<Account, String> {

}
