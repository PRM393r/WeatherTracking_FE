# WeatherTracking — Flutter Frontend

Frontend cho **Smart Weather App v2** — Flutter + Firebase.

**Stack:** Flutter 3.x · Firebase Auth · Cloud Firestore · Cloud Functions · FCM · Riverpod · GoRouter

---

## Thong tin project

| Muc | Gia tri |
|-----|---------|
| Firebase Project ID | `weathertracking-su26` |
| Android Package | `com.fpt.weather_tracking` |
| Flutter SDK | ^3.11.5 |
| Dart SDK | ^3.11.5 |
| Repo | https://github.com/PRM393r/WeatherTracking_FE |

---

## Cau truc thu muc

```
WeatherTracking-FE/
├── lib/
│   ├── main.dart                    # Entry point — Firebase init + ProviderScope
│   ├── firebase_options.dart        # Auto-generated boi FlutterFire CLI
│   ├── core/
│   │   ├── theme.dart               # AppColors, AppTheme (weather color palette)
│   │   └── router.dart              # GoRouter — auth redirect logic
│   └── features/
│       ├── auth/
│       │   ├── providers/
│       │   │   └── auth_provider.dart   # authStateProvider, AuthNotifier
│       │   └── screens/
│       │       ├── login_screen.dart
│       │       ├── register_screen.dart
│       │       └── forgot_password_screen.dart
│       └── home/
│           └── screens/
│               └── home_screen.dart
├── android/
│   └── app/
│       ├── google-services.json     # Firebase Android config
│       └── build.gradle.kts
├── pubspec.yaml
└── test/
    └── widget_test.dart
```

---

## Dependencies

```yaml
# Firebase
firebase_core: ^3.13.1
firebase_auth: ^5.5.4
cloud_firestore: ^5.6.9
cloud_functions: ^5.3.5
firebase_messaging: ^15.2.5
firebase_storage: ^12.4.5

# UI
google_fonts: ^6.2.1
cupertino_icons: ^1.0.8

# State management
flutter_riverpod: ^2.6.1

# Navigation
go_router: ^15.1.2
```

---

## Setup moi truong local

### 1. Yeu cau

- Flutter SDK 3.x+
- Android Studio / Xcode (emulator hoac thiet that)
- File `google-services.json` (Android) — lay tu Dev 4 hoac Firebase Console

### 2. Clone va cai dependencies

```bash
git clone https://github.com/PRM393r/WeatherTracking_FE.git
cd WeatherTracking_FE
flutter pub get
```

### 3. Lay file `google-services.json`

File nay duoc commit vao repo (private repo — an toan cho team sharing).

Neu khong co, tai tu Firebase Console:
- Vao https://console.firebase.google.com → project `weathertracking-su26`
- Project Settings → Your apps → Android app
- Download `google-services.json` → dat vao `android/app/google-services.json`

### 4. Chay app

```bash
# Kiem tra device
flutter devices

# Chay
flutter run

# Hoac chi dinh device
flutter run -d <device_id>
```

---

## Git Workflow

```
main (production)
 └── develop
      └── trungle2605  ← Dev 4 lam viec o day
```

Commit convention: `feat(PRM-XX): mo ta`

---

## Color Palette (Weather Theme)

| Ten | Hex | Dung cho |
|-----|-----|---------|
| `blockSky` | `#BDE0F7` | Troi nang / clear |
| `blockMint` | `#C8E6CD` | AQI tot / xac nhan |
| `blockRain` | `#C5D8F4` | Mua |
| `blockSunset` | `#F4D6B0` | Chieu toi / nong |
| `blockStorm` | `#9BAEC8` | Bao / may mu |
| `blockCoral` | `#F3C9B6` | Canh bao nhiet |
| `blockNavy` | `#1A2744` | Ban dem / dark card |
| `ink` | `#111111` | Text chinh |
| `canvas` | `#FFFFFF` | Nen trang |
| `surfaceSoft` | `#F7F7F5` | Nen card |

---

## Ket noi Backend (Cloud Functions)

Flutter goi Cloud Functions qua HTTPS Callable — Firebase SDK tu gan ID Token, khong can tu viet auth header.

```dart
// Vi du goi getWeather
final result = await FirebaseFunctions.instance
    .httpsCallable('getWeather')
    .call({'lat': 10.8231, 'lng': 106.6297});
```

De tro vao emulator local (development):

```dart
// Them vao main.dart truoc runApp()
FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5002);
FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8180);
FirebaseAuth.instance.useAuthEmulator('localhost', 9199);
```

---

## Auth Flow

```
App khoi dong
    │
    ├── FirebaseAuth.instance.authStateChanges()   ← Stream<User?>
    │       │
    │       ├── null (chua login) → redirect /login
    │       └── User   (da login) → redirect /home
    │
Router (GoRouter)
    ├── /login
    ├── /register
    ├── /forgot-password
    └── /home
```

`authStateProvider` (Riverpod StreamProvider) lang nghe trang thai auth → GoRouter tu dong redirect khi login/logout.

---

## Phan cong team

| Dev | Vai tro | Phan trong repo nay |
|-----|---------|----------------------|
| **Dev 1** | **Flutter UI & Animation** | **Screens, widgets, animation** |
| **Dev 2** | **Flutter Integration** | **Goi Cloud Functions, Firestore** |
| Dev 3 | Cloud Functions, CI/CD | Khong |
| Dev 4 | Firebase Config & AI | `firebase_options.dart`, Firebase setup |

---

## Chay ung dung (tom tat)

```bash
# 1. Cai deps
flutter pub get

# 2. Kiem tra
flutter analyze

# 3. Chay
flutter run
```

Backend emulator (neu can test voi local functions):
```bash
# Terminal rieng, trong thu muc WeatherTracking-BE
firebase emulators:start --only functions,firestore,auth
```
