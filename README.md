# GATE Prep Connect 🎓

> An MVC-based Client-Server Web Application built for Peer Mentorship

GATE Prep Connect is a comprehensive peer mentorship platform designed specifically for college students preparing for the GATE examination. It bridges the gap between Junior Aspirants and Senior Mentors by providing a structured, role-based environment for subject-specific doubt resolution and study material sharing.

## 🚀 Features

*   **Role-Based Authentication:** Distinct dashboards and permissions for 'Students' and 'Seniors'.
*   **Targeted Doubt Resolution:** Queries are categorized by engineering branches, allowing seniors to track, answer, and resolve doubts effectively.
*   **Material Repository:** A centralized hub where mentors can upload subject-specific notes and links.
*   **Live Analytics Dashboard:** Automatically tracks and generates statistical reports regarding platform engagement and resolution ratios.

## 💻 Tech Stack

This project was built strictly adhering to the **Model-View-Controller (MVC)** design pattern to fulfill advanced Java engineering curriculum requirements.

*   **Frontend (View):** JSP (JavaServer Pages), JSTL, HTML5, Vanilla CSS (Glassmorphism UI).
*   **Backend (Controller):** Java 17, Spring Boot 3, Spring Web MVC.
*   **Database (Model):** Hibernate (Spring Data JPA), Embedded H2 Database (File-based).

## 🛠️ How to Run Locally

You do not need to install a standalone Tomcat server or MySQL database to run this project. Everything is embedded!

1. Clone this repository to your local machine.
2. Open your terminal and navigate to the project directory.
3. Run the following command to boot the server (uses the included Maven Wrapper):
   ```bash
   # On Windows
   .\mvnw.cmd spring-boot:run

   # On Mac/Linux
   ./mvnw spring-boot:run
   ```
4. Open your web browser and navigate to `http://localhost:8080`.
