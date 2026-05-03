# GATE Prep Connect - Feature Roadmap

This document outlines potential features to expand the "GATE Prep Connect" platform from a basic CRUD application into a robust, interactive peer-mentorship ecosystem. The features are categorized by implementation complexity.

## 🟢 Phase 1: Quick Wins (Enhancing Existing Infrastructure)
These features build directly on the current MVC architecture and can be implemented relatively quickly.

### 1. Search & Filtering Mechanism
* **Description:** Add a comprehensive search bar to the Dashboard and Materials pages.
* **Functionality:** Allow users to filter doubts by Subject, Status (Pending/Resolved), and Date.
* **Value:** Improves UX drastically as the database grows, making it easier to find specific questions or study materials.

### 2. User Profiles
* **Description:** Create a dedicated `/profile` view for users.
* **Functionality:** 
  * **Students:** View a history of all their asked doubts and their current statuses.
  * **Seniors:** View "Mentorship Stats" (e.g., number of questions answered, materials uploaded).
* **Value:** Adds a personal touch, allowing users to track their activity and engagement on the platform.

### 3. Rich Text & Math Support
* **Description:** Upgrade the frontend text input areas.
* **Functionality:** Replace simple `<textarea>` fields with a WYSIWYG editor (e.g., Quill.js, TinyMCE). Integrate MathJax or KaTeX.
* **Value:** Essential for engineering students to properly format code snippets, mathematical equations, and complex formulas in their doubts and answers.

---

## 🟡 Phase 2: Intermediate Additions (New Business Logic)
These features require creating new entities, expanding the database schema, and handling slightly more complex relationships.

### 4. Threaded Discussions (Comments)
* **Description:** Move beyond a simple Q&A model to support conversations.
* **Functionality:** Create a `Comment` entity mapped to a `Doubt`. Allow students and seniors to have a back-and-forth discussion on a specific doubt.
* **Value:** Solves the issue where a student might need further clarification on a senior's initial answer.

### 5. Upvote & Reputation System
* **Description:** Gamify the mentorship experience.
* **Functionality:** Allow students to upvote answers they find helpful. Calculate and display a "Reputation Score" for Seniors based on these upvotes. Introduce automated badges (e.g., "Top Contributor").
* **Value:** Incentivizes seniors to provide high-quality, accurate answers and helps students identify the most reliable mentors.

### 6. Doubt Tagging System
* **Description:** Granular categorization for doubts.
* **Functionality:** Allow students to add multiple tags (e.g., `#Calculus`, `#DataStructures`, `#Aptitude`) to a doubt, in addition to the broad "Subject" category.
* **Value:** Makes searching and filtering much more powerful and specific.

### 7. "Mark as Duplicate" functionality
* **Description:** Moderation tool for seniors.
* **Functionality:** Allow seniors to flag a new doubt as a duplicate of an already resolved doubt, linking the two threads together.
* **Value:** Prevents database clutter and saves seniors from answering the exact same question multiple times.

---

## 🔴 Phase 3: Advanced Features (Integrations & Complex Architecture)
These features involve third-party integrations or significant architectural additions that will make the project stand out.

### 8. Email Notifications
* **Description:** Proactive alerts for users.
* **Functionality:** Integrate `spring-boot-starter-mail` (JavaMailSender).
  * Send an email to a Student the moment their doubt is resolved.
  * Send a daily/weekly digest to Seniors summarizing new pending doubts in their domain.
* **Value:** Increases user retention and engagement by pulling them back into the application without requiring them to constantly refresh the dashboard.

### 9. Administrator Role & Moderation Dashboard
* **Description:** Establish platform governance.
* **Functionality:** Create a third `ADMIN` role. Build an admin dashboard to delete inappropriate content, manage/ban users, and add/remove subject categories without direct database manipulation.
* **Value:** Critical for scaling the application safely and maintaining a healthy community environment.

### 10. Material Ratings & Reviews
* **Description:** Quality control for the repository.
* **Functionality:** Allow students to rate uploaded materials (e.g., 1-5 stars) and leave written reviews or feedback.
* **Value:** Crowdsources quality control, ensuring the best notes and resources surface to the top of the repository.
