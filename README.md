// README.md placeholder
# 🚧 Crowdsourced Pothole & Traffic Hazard Reporter

A mobile and web-ready app built using **Flutter + Firebase** that allows users to report traffic issues like potholes, broken signs, and malfunctioning signals. Admins can view analytics and locations on a map dashboard.

---

## 🔥 Features

- 📍 GPS-enabled issue reporting (Pothole, Signal, Broken Sign, etc.)
- 📷 Photo upload using camera
- 🗺️ Google Maps view of all issues
- ☁️ Firebase backend for real-time storage
- 📊 Admin dashboard for filtering and tracking
- 📤 Uploads images to Firebase Storage
- 📈 Ready for Smart City / CSR funding pilots

---

## 📁 Project Structure

```bash
pothole_reporter/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── report_model.dart
│   ├── pages/
│   │   ├── home_page.dart
│   │   ├── report_form.dart
│   │   └── admin_dashboard.dart
│   └── services/
│       └── firebase_service.dart
├── assets/
├── firebase.json
├── pubspec.yaml
└── README.md

