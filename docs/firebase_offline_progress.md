# Firebase setup and offline progress

## Android setup

1. Create or select a Firebase project and register Android package
   `com.example.aminapp`.
2. Enable Firebase Authentication's Email/Password provider. The app derives an
   internal email from the public AmiN Student ID; this email is never shown.
3. Create Cloud Firestore and deploy `firestore.rules`.
4. Download `google-services.json` to `android/app/google-services.json`.
   The Android build enables the Google Services plugin only when this file is
   present, so offline-only development continues to work without Firebase.
5. Run `flutter pub get`, then build or run the Android application.

Do not add Recovery PINs, passwords, service-account keys, or Firebase Admin
credentials to source control. The Android client configuration identifies the
Firebase project but does not grant administrative access.

## Data flow

Every lesson, quiz, game, and learning-session update is committed to Drift with
its learning event and durable outbox item. The UI reads Drift immediately.
When Firebase Authentication is available, batches of at most 100 outbox writes
are merged into the authenticated student's Firestore subtree. Successful rows
are retained and marked synced; failed rows use bounded exponential retry.

Cloud paths are:

- `students/{uid}`
- `students/{uid}/installations/{installationId}`
- `students/{uid}/learning_events/{eventId}`
- `students/{uid}/lesson_progress/{lessonId}`
- `students/{uid}/quiz_attempts/{attemptId}`
- `students/{uid}/game_sessions/{gameSessionId}`
- `students/{uid}/learning_sessions/{sessionId}`
- `students/{uid}/summary/current`

Recovery downloads current progress and session/attempt state but deliberately
does not scan the complete learning-event history. Activity performed after the
last successful sync cannot be recovered after app data is erased.

## Emulator validation

Install the Firebase CLI, start the Auth and Firestore emulators with
`firebase emulators:start`, and verify that an authenticated test account can
access only `students/{itsUid}/**`. Requests to another UID and all unauthenticated
student requests must be denied.

The executable ownership tests live in `firebase_test`. After `npm install`, run
them while the Firestore emulator is active with `npm test` from that directory.
