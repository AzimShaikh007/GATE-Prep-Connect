# GATE Prep Connect - Architecture & Project Report

## 1. Project Overview
**GATE Prep Connect** is a structured, peer-mentorship web application designed to aid college students preparing for the GATE examination. It provides a collaborative environment bridging the gap between "Junior Aspirants" and "Senior Mentors." The core objective is to facilitate targeted, subject-specific doubt resolution and centralize study material distribution.

## 2. Architecture & Tech Stack
The project is engineered following a strict **Model-View-Controller (MVC)** architectural pattern, separating the application logic into three interconnected elements to ensure scalability, maintainability, and clean code principles.

*   **Model (Data Layer):** 
    *   **Database:** H2 Embedded Database (File-based, zero configuration required).
    *   **ORM:** Hibernate / Spring Data JPA maps Java POJO entities to database tables.
*   **View (Presentation Layer):**
    *   **Frontend Technologies:** JSP (JavaServer Pages), JSTL (Jakarta EE 10 compatible), HTML5, and Vanilla CSS (featuring a Glassmorphism UI).
    *   *Mechanism:* The Spring Controllers pass data (`Model` attributes) to the JSP files, which dynamically render the HTML sent to the client.
*   **Controller (Business/Routing Layer):**
    *   **Framework:** Spring Boot 3, Spring Web MVC, Java 17.
    *   *Mechanism:* `PortalController` intercepts HTTP requests, processes business logic (e.g., authentication checks, database interactions via Repositories), and returns the appropriate view.

## 3. User Roles & Permissions
The system relies on Role-Based Access Control (RBAC) defined via user sessions. 

### 3.1. Student (Aspirant)
*   **Target Audience:** Juniors preparing for the GATE exam.
*   **Permissions & Access:**
    *   Can ask new subject-specific doubts.
    *   Can view the status and answers of their *own* doubts on the dashboard.
    *   Can browse and access study materials uploaded by Seniors.
    *   Can view platform analytics (Reports).

### 3.2. Senior (Mentor)
*   **Target Audience:** Experienced students/alumni who have cleared or possess strong knowledge regarding the GATE syllabus.
*   **Permissions & Access:**
    *   Can view a global feed of *all pending doubts* submitted by students.
    *   Can write answers and mark doubts as "RESOLVED".
    *   Can upload new study materials (notes, reference links).
    *   Can view platform analytics (Reports).

## 4. Core Data Models (Entities)
The application state is managed by three primary relational entities:

1.  **User:** Stores user credentials and role (`STUDENT` or `SENIOR`). Forms a one-to-many relationship with Doubts and Materials.
2.  **Doubt:** Stores the question (`title`, `description`, `subject`), the author (`student`), the responder (`answeredBy`), the `answerText`, and the lifecycle `status` (`PENDING` or `RESOLVED`).
3.  **Material:** Stores study resources containing `title`, `subject`, `description`, a `downloadLink`, and tracks the `uploadedBy` user.

## 5. Primary Use Cases & Workflows

### Use Case 1: Authentication Workflow
*   **Action:** A user signs up specifying their role (Student/Senior).
*   **Flow:** The system verifies email uniqueness. Upon successful login, the user's entity is stored in the active HTTP Session, dictating which UI components and data they can access.

### Use Case 2: Doubt Resolution Cycle
*   **Action:** Student submits a doubt.
*   **Flow:** The doubt is saved with a `PENDING` status. Seniors see this doubt on their dashboard. A Senior selects the doubt, provides an answer, and submits it. The system updates the doubt with the `answerText`, links the Senior as `answeredBy`, and changes the status to `RESOLVED`. The student can now see the answer on their dashboard.

### Use Case 3: Resource Repository Management
*   **Action:** Senior uploads a resource.
*   **Flow:** The Senior fills out a form with material metadata and a link. This is stored in the database. All users (both Students and Seniors) can navigate to the `/materials` page to view and access these resources, ordered by upload date.

### Use Case 4: Platform Analytics & Reporting
*   **Action:** User accesses the `/report` route.
*   **Flow:** The system aggregates data across the database to display live statistics: Total Doubts Asked, Doubts Resolved, Doubts Pending, and Total Materials available. This serves as a health and engagement metric for the platform.
