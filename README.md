# Login App (Flutter + SharedPreferences)

A simple Flutter app with **Register**, **Login** and a **Home page with AppBar**.
The user session is stored with `shared_preferences`, so you stay logged in even
after closing the app.

---

## 1. Features

| Screen | What it does |
|---|---|
| `LoginScreen` | Username + password, validates, saves session |
| `RegisterScreen` | Name, email, username, password, confirm password |
| `HomeScreen` | AppBar with logout button, shows the logged-in user's profile |

**Storage:** everything is kept locally in `SharedPreferences`
- `registered_users` → JSON map of all users
- `logged_in_user` → the username of the current session

---

## 2. Project structure

```
lib/
├── main.dart                      # entry point + decides which screen to show
├── services/
│   └── auth_service.dart          # all SharedPreferences read/write logic
└── screens/
    ├── login_screen.dart          # login UI
    ├── register_screen.dart       # register UI
    └── home_screen.dart           # home UI with AppBar
```

---

## 3. How the flow works

```
App starts
   │
   ▼
main() reads SharedPreferences ── logged_in_user exists?
        │                               │
       NO                              YES
        │                               │
        ▼                               ▼
   LoginScreen                      HomeScreen
        │
        ├── "Register" ──► RegisterScreen ──auto login──► HomeScreen
        │
        └── valid login ──────────────────────────────► HomeScreen
                                                              │
                                                     AppBar logout icon
                                                              │
                                                              ▼
                                                        LoginScreen
```


**`AppBar` properties used:**
| Property | Purpose |
|---|---|
| `title` | text at the left |
| `actions` | icons/buttons on the right (here: logout) |
| `backgroundColor` | bar colour (defaults to theme) |

---

## 5. Running the app

```bash
flutter pub get          # install dependencies
flutter analyze          # static checks (no issues)
flutter test             # widget tests
flutter run              # run on a connected device/emulator
```

If Gradle fails with a **"Cannot lock file hash cache ... already locked"** error,
a previous build was killed while holding the lock. Fix:

```bash
cd android && ./gradlew --stop          # stop the daemon
pkill -f GradleDaemon                   # make sure it is gone
rm -rf android/.gradle/8.14/fileHashes  # delete the stale lock
flutter run
```

---

## 6. Ideas to extend it

1. Store passwords **hashed** (`bcrypt` / `crypto` package).
2. Add "Remember me" and a session expiry timestamp.
3. Move users into `hive` / `sqflite` when the data grows.
4. Add a "Forgot password?" flow.
5. Validate with `AutovalidateMode.onUserInteraction` for live errors.