package com.demo.apexbankapi.service;

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.demo.apexbankapi.model.Account;
import com.demo.apexbankapi.repository.AccountRepository;

@Service
public class BankService {

    @Autowired
    private AccountRepository accountRepository;

    // 1. Create a new bank account
    public Account createAccount(Account account) {
        // Simple business check: ensure account number isn't already taken
        Optional<Account> existing = accountRepository.findByAccountNumber(account.getAccountNumber());
        if (existing.isPresent()) {
            throw new RuntimeException("Account number already exists!");
        }
        return accountRepository.save(account);
    }

    // 2. Fetch account details
    public Account getAccount(String accountNumber) {
        return accountRepository.findByAccountNumber(accountNumber)
                .orElseThrow(() -> new RuntimeException("Account not found"));
    }

    // 3. Transfer Funds (The Core Engine)
    @Transactional // Critical for banking! It ensures atomic operations.
    public void transferFunds(String fromAccountNumber, String toAccountNumber, Double amount) {
        // Validate amount
        if (amount <= 0) {
            throw new IllegalArgumentException("Transfer amount must be greater than zero");
        }

        // Fetch and verify accounts
        Account fromAccount = accountRepository.findByAccountNumber(fromAccountNumber)
                .orElseThrow(() -> new RuntimeException("Sender account not found"));
        
        Account toAccount = accountRepository.findByAccountNumber(toAccountNumber)
                .orElseThrow(() -> new RuntimeException("Receiver account not found"));

        // Check if sender has enough money
        if (fromAccount.getBalance() < amount) {
            throw new RuntimeException("Insufficient balance to complete transfer");
        }

        // Deduct from sender and credit the receiver
        fromAccount.setBalance(fromAccount.getBalance() - amount);
        toAccount.setBalance(toAccount.getBalance() + amount);

        // Save updated states back to MySQL
        accountRepository.save(fromAccount);
        accountRepository.save(toAccount);
    }
}
