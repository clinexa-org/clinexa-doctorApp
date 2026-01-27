# Clinexa Doctor App 🩺

A premium, production-grade Flutter application designed for doctors to manage clinics, track appointments, and create prescriptions with a seamless, modern interface.

## 🚀 Key Features

- **Dynamic Dashboard**: Real-time stats visualization for patients and today's appointments.
- **Appointment Management**:
  - Grouped view (Today, Tomorrow, Upcoming).
  - Detailed patient information and appointment history.
  - Interactive status controls (Confirm, Complete, Cancel).
- **Pro Prescription Creation**:
  - Integrated workflow from appointment details.
  - Smart dropdown selection for completed appointments.
  - Medication management with merged dosage/frequency logic.
- **Clinic Settings**:
  - Customizable working hours.
  - Slot duration management.
  - Profile & Avatar customization.
- **UI Excellence**:
  - Full **AM/PM Time Formatting** standardization.
  - Custom animations and glassmorphism elements.
  - Responsive design using `flutter_screenutil`.

## 🏗 Architecture

The project follows **Clean Architecture** principles to ensure maintainability and scalability:

- **Core**: Shared utilities (TimeHelper, ToastHelper), network configurations (Dio), and theme tokens.
- **Features**: Modularized by domain (Auth, Dashboard, Appointments, Prescriptions, Clinic Settings).
  - **Data**: Repositories, Models (JSON parsing), and Data Sources (API interaction).
  - **Domain**: Entities and Use Cases (Business logic).
  - **Presentation**: BLoC/Cubit (State management), Pages, and Widgets.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Navigation**: [go_router](https://pub.dev/packages/go_router)
- **Networking**: [dio](https://pub.dev/packages/dio)
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it)
- **Icons**: [iconsax](https://pub.dev/packages/iconsax)
- **Theming**: Custom design system with dark/light mode foundations.

## 📋 Prerequisites

- Flutter SDK (>= 3.4.3)
- Dart SDK (>= 3.4.3)

## ⚙️ Getting Started

1. **Clone the repository**:

   ```bash
   git clone https://github.com/clinexa-org/clinexa-doctorApp.git
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Setup Environment**:
   - Create/Update `.env` files in `assets/env/`.
   - Ensure `BASE_URL` points to the Clinexa API.

4. **Run the app**:
   ```bash
   flutter run
   ```

## 🤝 Contribution

This project is part of the **Clinexa Ecosystem**. For contributions or feedback, please reach out to the development team.

---

_Built with ❤️ by the Clinexa Team_
