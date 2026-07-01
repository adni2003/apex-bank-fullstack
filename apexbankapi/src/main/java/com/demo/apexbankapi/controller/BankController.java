package com.demo.apexbankapi.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.demo.apexbankapi.model.Account;
import com.demo.apexbankapi.repository.AccountRepository;
import com.demo.apexbankapi.service.BankService;

@RestController
@RequestMapping("/api/bank")
@CrossOrigin(origins = "*") // Allow local browser access during development
public class BankController {

    @Autowired
    private BankService bankService;

    // 1. Endpoint to open a new account
    // POST http://localhost:8082/api/bank/account
    @PostMapping("/account")
    public ResponseEntity<?> registerAccount(@RequestBody Account newAccount) {
        // Basic validation
        if (newAccount.getBalance() < 0) {
            return ResponseEntity.badRequest().body("Initial deposit cannot be negative.");
        }

        try {
            Account saved = bankService.createAccount(newAccount);
            return ResponseEntity.ok(saved);
        } catch (RuntimeException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }

    // 2. Endpoint to check account details
    // GET http://localhost:8082/api/bank/account/{accountNumber}
    @GetMapping("/account/{accountNumber}")
    public ResponseEntity<Account> checkBalance(@PathVariable String accountNumber) {
        Account account = bankService.getAccount(accountNumber);
        return ResponseEntity.ok(account);
    }

    // 3. Endpoint to transfer money between accounts
    // POST http://localhost:8082/api/bank/transfer
    @PostMapping("/transfer")
    public ResponseEntity<String> executeTransfer(
            @RequestParam String from,
            @RequestParam String to,
            @RequestParam Double amount) {
        
        bankService.transferFunds(from, to, amount);
        return ResponseEntity.ok("Transfer successfully completed!");
    }
}