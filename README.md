# 🚀 Daily Routine Flow

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.7+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-2.5+-06B6D4?style=for-the-badge)
![SQLite](https://img.shields.io/badge/SQLite-Local%20DB-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Notifications-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)

**Your all-in-one daily productivity companion — Track. Flow. Thrive.**

[Features](#-features) • [Screenshots](#-screenshots) • [Tech Stack](#-tech-stack) • [Architecture](#-architecture) • [Installation](#-installation) • [Contributing](#-contributing)

</div>

---

## 📖 Overview

**Daily Routine Flow** is a beautifully designed, feature-rich Flutter mobile app that helps you manage your daily life in one place. Track todos, monitor water intake, schedule tasks by date, and jot down quick notes — all with a stunning glassmorphism UI and smooth animations.

Built with ❤️ using Flutter, Riverpod, SQLite, and Firebase.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| ✅ **Todo List** | Create, edit, prioritize (Low/Medium/High), and complete tasks with beautiful glass cards |
| 💧 **Water Tracker** | Log daily water intake with animated progress rings, quick-add buttons, and streak tracking |
| 📅 **Task Scheduler** | Schedule tasks by date with a horizontal calendar strip, reminders, and overdue indicators |
| 📝 **Quick Notes** | Write and save color-coded notes organized by date with instant search |
| 🏠 **Smart Dashboard** | Dynamic overview with personalized greeting, water progress, today's summary, and quick actions |
| 🔔 **Smart Notifications** | Local push notifications for task reminders and hydration alerts |
| 👤 **Profile & Settings** | Customizable avatar, name, dark/light theme toggle, water goal, and notification controls |
| 🎨 **Aurora Glass UI** | Custom glassmorphism design system with vibrant gradients, micro-animations, and dark mode |
| 💾 **Local-First** | All data stored locally with SQLite — works offline, no account required |

---

## 📸 Screenshots

<div align="center">

| Splash | Onboarding | Dashboard |
|--------|------------|-----------|
| ![Splash](screenshots/splash.png) | ![Onboarding](screenshots/onboarding.png) | ![Dashboard](screenshots/dashboard.png) |

| Todo List | Water Tracker | Task Scheduler |
|-----------|---------------|----------------|
| ![Todo](screenshots/todo.png) | ![Water](screenshots/water.png) | ![Task](screenshots/task.png) |

| Quick Notes | Settings |
|-------------|----------|
| ![Notes](screenshots/notes.png) | ![Settings](screenshots/settings.png) |

</div>

> *Add your screenshots in a `screenshots/` folder for the best README!*

---

## 🛠 Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter 3.7+** | Cross-platform mobile framework |
| **Dart 3.0+** | Programming language |
| **Riverpod 2.5+** | State management (AsyncNotifier, Provider) |
| **SQLite (sqflite)** | Local database for offline storage |
| **GoRouter** | Declarative routing with nested navigation |
| **Firebase Cloud Messaging** | Push notifications |
| **flutter_local_notifications** | Local notification scheduling |
| **Shared Preferences** | Simple key-value storage |
| **Google Fonts** | Typography (Poppins) |

---

## 🏗 Architecture

The project follows **Clean Architecture** with a **feature-first** folder structure:
