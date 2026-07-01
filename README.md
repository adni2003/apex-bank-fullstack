# ApexBank - Full-Stack Secure Banking Portal

A secure, enterprise-grade full-stack banking ecosystem featuring a responsive web dashboard built with **Flutter Web** and an atomic transactional engine powered by **Java (Spring Boot)** and **MySQL**.

## 🛠️ System Architecture

The application is split into two independent decoupled systems:

1. **Frontend App (`/apex-bank-frontend`)**: Built using **Flutter (Dart)** to deliver a clean visual dashboard, input masking to restrict malicious inputs, and dynamic real-time state synchronization.
2. **Backend Engine (`/apex-bank-backend`)**: Developed with **Spring Boot (Java 17)** following a strict Controller-Service-Repository architecture, managing automated Object-Relational Mapping (ORM) via **Spring Data JPA**.

## 🔒 Key Security & Technical Standards Implemented
* **Atomic Transactions (`@Transactional`)**: Ensures database rollbacks during peer-to-peer fund transfer failures, avoiding any possibility of data loss or balance mismatches.
* **CORS Restrictions**: Configured Cross-Origin Resource Sharing on REST endpoints to explicitly mitigate unauthorized third-party cross-site request forgery (CSRF) attempts.
* **Input Constraints**: Handled robust client-side and server-side validation rules to verify financial figures and prevent logical database manipulation (such as negative transfer vectors).

## 🚀 Core Functionalities
* **Dashboard Metric Synchronizer**: Dynamically queries MySQL via REST to present live data, individual user account names, and formatted decimal currency balances.
* **Secure Peer-to-Peer Fund Transfer**: Deducts funds atomically from the primary sender and credits the recipient ledger profile instantaneously.
* **Dynamic Database Registration**: Opens and records entirely new valid bank accounts into local storage right from the visual web UI.
