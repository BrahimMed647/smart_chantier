# Smart Chantier

Smart Chantier is a professional construction site management application developed during an internship at **Smart MS**.

The platform helps organizations, project managers, engineers, and site supervisors efficiently manage construction projects, daily activities, tasks, reports, photos, and team collaboration from a mobile application.

---

# Features

## Authentication

- Secure Login
- User Registration
- Password Reset
- Role-Based Access Control
- Google Authentication (optional)

---

## User Management

### Administrator

- Manage all users
- Manage organizations
- Manage projects
- View reports and statistics

### Engineer

- Study and monitor projects
- Create and manage tasks
- Track project progress
- Access reports

### Site Supervisor (Chef Chantier)

- Daily site monitoring
- Create daily reports
- Upload site photos
- Track workers
- Monitor task completion

---

## Project Management

- Create projects
- Update projects
- Delete projects
- Project progress tracking
- Budget monitoring
- Project status management

---

## Task Management

- Create tasks
- Assign tasks
- Update task status
- Set priorities
- Set deadlines
- Monitor completion rates

---

## Daily Reports

- Create daily reports
- Record completed work
- Record workforce numbers
- Add remarks and observations
- Track daily site progress

---

## Photo Management

- Upload construction photos
- Store photos securely
- Link photos to projects
- Track construction evolution

---

## Organization Management

- Create organizations
- Manage organization members
- Assign users to organizations
- Track organization projects

---

# Technologies

## Frontend

- Flutter
- Dart
- Material Design 3
- Provider / Riverpod (state management)

## Backend

- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Cloud Messaging

## Database

Cloud Firestore

---

# Architecture

```text
Flutter Mobile App
        │
        ▼
Firebase Authentication
        │
        ▼
Cloud Firestore
        │
        ▼
Firebase Storage
