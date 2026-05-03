# Project Overview: GATE Prep Connect

## 1. Introduction
**GATE Prep Connect** is a specialized peer-mentorship platform designed to streamline the preparation journey for GATE aspirants. It bridges the gap between junior students and experienced mentors (seniors), facilitating subject-specific doubt resolution and centralized resource sharing.

## 2. Technical Architecture
The application is built using a robust, industry-standard architecture to ensure scalability and ease of maintenance.

### 2.1. Architectural Pattern: MVC
The system follows the **Model-View-Controller (MVC)** pattern:
*   **Model:** Managed by **Spring Data JPA** and **Hibernate**, mapping Java objects to the **H2 Database**.
*   **View:** Developed using **JSP (JavaServer Pages)** and **Vanilla CSS** with a modern **Glassmorphism** design language.
*   **Controller:** **Spring Boot 3** handles routing, security, and business logic execution.

### 2.2. Tech Stack
*   **Backend:** Java 17, Spring Boot 3.x, Spring Web MVC.
*   **Persistence:** Hibernate ORM, H2 Embedded Database (File-based).
*   **Frontend:** HTML5, CSS3, JSP, JSTL.
*   **Styling:** Custom CSS with responsive layouts and premium visual effects.

---

## 3. Core Features & Functionality

### 3.1. Advanced Doubt Resolution System
*   **Subject-Specific Queries:** Students can categorize doubts by core engineering subjects.
*   **Threaded Discussions:** Supports multi-turn conversations (Comments) on a single doubt for deep clarification.
*   **Rich Text Support:** Integration of WYSIWYG editors and MathJax for rendering complex mathematical formulas and code snippets.
*   **Doubt Tagging:** A granular tagging system (e.g., `#Calculus`, `#DataStructures`) for better organization and searchability.

### 3.2. Mentorship & Gamification
*   **Upvote System:** Students can upvote high-quality answers provided by mentors.
*   **Senior Reputation:** Mentors earn reputation points based on the helpfulness of their contributions, establishing authority within the community.
*   **Mentor Profiles:** Dedicated profiles showcasing contribution stats, including questions answered and materials shared.
*   **Top Mentor Leaderboard:** A dynamic ranking system in the Reports section highlighting the most active and highly-rated seniors based on their cumulative reputation.

### 3.3. Resource Repository
*   **Centralized Materials:** A dedicated section for seniors to upload notes, reference links, and study guides.
*   **Rating & Review System:** Students can rate (1-5 stars) and review uploaded materials, ensuring only the highest quality resources stay prominent.
*   **Search & Filtering:** Powerful search mechanism to find specific doubts or materials by keywords, subjects, or tags.

### 3.4. Analytics & Community Management
*   **Live Platform Stats:** Real-time tracking of platform engagement, including total doubts resolved, material counts, and active mentorship metrics.
*   **Duplicate Detection:** Mentors can mark new doubts as duplicates of existing resolved threads to maintain a clean knowledge base.
*   **Status Tracking:** Real-time visibility into doubt lifecycles (Pending vs. Resolved).

---

## 4. User Roles & Workflows

### 4.1. Junior Aspirant (Student)
*   **Workflow:** Ask doubts $\rightarrow$ Participate in discussions $\rightarrow$ Rate materials $\rightarrow$ Track preparation progress via personal dashboard.
*   **Objective:** Get fast, accurate resolutions to technical hurdles from experienced peers.

### 4.2. Senior Mentor (Senior)
*   **Workflow:** Browse pending doubts $\rightarrow$ Provide expert solutions $\rightarrow$ Upload quality study materials $\rightarrow$ Build reputation within the platform.
*   **Objective:** Give back to the community while building a credible mentorship profile.

---

## 5. Database Schema & Relationships
The system manages complex relationships to maintain data integrity:
*   **Users:** One-to-Many relationship with Doubts and Materials.
*   **Doubts:** Many-to-One with Users (Author/Mentor) and One-to-Many with Comments and Tags.
*   **Materials:** One-to-Many relationship with Ratings and Reviews.

## 6. Project Impact
*   **Centralization:** Eliminates the need for fragmented social media groups by providing a single source of truth for GATE prep.
*   **Incentivization:** The reputation system ensures active participation from senior students.
*   **Efficiency:** Search and duplicate detection save time for both students and mentors.
