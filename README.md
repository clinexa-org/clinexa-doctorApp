
<img width="1184" height="864" alt="Gemini_Generated_Image_g369zbg369zbg369" src="https://github.com/user-attachments/assets/96d3bccf-520e-4abf-965d-483b5b570863" />

# Clinexa Doctor 🩺

**Clinexa Doctor** is a premium, production-grade Flutter application designed to empower healthcare professionals with a comprehensive clinic management solution. It streamlines daily operations, from appointment tracking to prescription management, all within a modern, responsive, and intuitive interface.

## 🚀 Key Features

### 🔐 Authentication & Security

- **Secure Login & Registration**: Robust authentication flow using Firebase Auth.
- **Forgot Password**: Seamless recovery process.
- **Token Management**: Secure storage of session tokens using `flutter_secure_storage`.

### 📊 Dashboard

- **Real-time Overview**: Instant visibility into today's appointments and patient statistics.
- **Performance Metrics**: Visual breakdown of appointment statuses (Pending, Completed, Cancelled).

### 📅 Appointment Management

- **Smart Scheduling**:
  - **Today's View**: Focused view for immediate daily tasks.
  - **Upcoming & Past**: comprehensive history and future schedule.
- **Status Workflow**: Interactive controls to Accept, Cancel, or Complete appointments.
- **Detailed Insights**: View complete patient information and appointment context before the consultation.

### 👤 Patient Profiles

- **Comprehensive Records**: specific patient details and history.
- **Communication**: Direct actions to contact patients (if configured).

### 💊 Prescription Management

- **Pro Creation Suite**:
  - Create prescriptions directly from completed appointments.
  - Add medications with dosage, frequency, and duration.
- **PDF Generation**: Generate professional, printable PDF prescriptions.
- **History**: View past prescriptions for any patient.

### 🔔 Notifications

- **Real-time Updates**: Instant alerts for new appointments and status changes using Firebase Realtime Database (RTDB) & FCM.
- **Local Notifications**: Foreground alerts to keep doctors informed even when the app is open.

### ⚙️ Clinic Settings

- **Profile Management**: Update doctor details, avatar, and clinic information.
- **Schedule Configuration**: Customize working hours and appointment slot durations.
- **Language**: Support for English and Arabic (Localization).

---

## 🏗️ Technical Architecture

This project strictly adheres to **Clean Architecture** principles, ensuring scalability, testability, and maintainability.

### Layered Structure

- **Presentation Layer**:
  - **State Management**: `flutter_bloc` / `Cubit` pattern.
  - **UI**: Responsive widgets using `flutter_screenutil` and material design 3.
  - **Navigation**: Type-safe routing with `go_router`.
- **Domain Layer**:
  - Pure Dart entities and abstract repositories definition (Business Logic).
  - Use Cases for singular actions.
- **Data Layer**:
  - **Repositories Implementation**: Handling data retrieval strategies.
  - **Data Sources**: Remote (API/Firebase) and Local (Storage) data fetching.
  - **Models**: DTOs (Data Transfer Objects) with JSON serialization.

### 🛠️ Tech Stack

| Category | Technology |
| :--- | :--- |
| **Language** | Dart |
| **Framework** | Flutter |
| **State Management** | flutter_bloc, equatable |
| **Navigation** | go_router |
| **Networking** | Dio, pretty_dio_logger |
| **Dependency Injection** | get_it, injectable |
| **Backend / Services** | Firebase (Auth, Firestore, RTDB, Messaging), Socket.io (legacy/fallback) |
| **Local Storage** | shared_preferences, flutter_secure_storage |
| **UI Utilities** | flutter_screenutil, google_fonts, flutter_svg, toastification |
| **Utils** | intl, dartz (functional programming) |

---

## 📂 Project Structure

```text
lib/
├── app/                 # App configuration and global providers
├── core/                # Core utilities, constants, and shared widgets
│   ├── network/         # Network clients and interceptors
│   ├── di/              # Dependency injection setup
│   ├── config/          # Theme, Routes, and Assets
│   ├── error/           # Error handling and Failures
│   └── utils/           # Helper functions (Date, String, etc.)
├── features/            # Feature-based modules
│   ├── auth/            # Login, Register, Forgot Password
│   ├── dashboard/       # specific stats and charts
│   ├── doctor_appointments/ # Appointment lists and logic
│   ├── doctor_profile/  # Doctor's personal and clinic settings
│   ├── notifications/   # Notification list and handling logic
│   ├── patient_profile/ # Patient details view
│   ├── prescriptions/   # Prescription creation and viewing
│   └── clinic_settings/ # Configuration for clinic hours/slots
└── main.dart            # Application entry point
```

---

## 📋 Prerequisites

Before running the project, ensure you have the following installed:

- **Flutter SDK**: `>=3.4.3 <4.0.0`
- **Dart SDK**: `>=3.4.3 <4.0.0`
- **Android Studio** or **VS Code** with Flutter extensions.
- **Git**

---

## ⚙️ Getting Started

Follow these steps to set up the project locally.

### 1. Clone the Repository

```bash
git clone https://github.com/clinexa-org/clinexa-doctorApp.git
cd clinexa-doctorApp
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Environment Configuration

1. Locate the `assets/env/` directory.
2. Ensure `.env.dev` and `.env.prod` files exist.
3. Add your configuration keys (API Base URL, etc.):

```env
BASE_URL=https://api.clinexa.com/api/v1
```

### 4. Run the Application

**Debug Mode:**

```bash
flutter run
```

**Release Mode:**

```bash
flutter run --release
```

### 5. Build for Production

**Android (APK):**

```bash
flutter build apk --release
```

**Android (App Bundle):**

```bash
flutter build appbundle --release
```

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature/your-feature-name`.
3. Make your changes and commit them: `git commit -m 'Add some feature'`.
4. Push to the branch: `git push origin feature/your-feature-name`.
5. Submit a pull request.

---

<p align="center">
  Built with ❤️ by the <strong>Fares Samy</strong>
</p>
