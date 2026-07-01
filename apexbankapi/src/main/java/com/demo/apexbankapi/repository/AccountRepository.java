package com.demo.apexbankapi.repository;

import java.util.Optional;
import com.demo.apexbankapi.model.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AccountRepository extends JpaRepository<Account, Long> {
    
    // Custom query method: Spring Data JPA automatically generates the SQL for this 
    // under the hood just by reading the method name!
    Optional<Account> findByAccountNumber(String accountNumber);
}
