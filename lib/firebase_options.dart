// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDgZIAGxF7KY-uya30_AN1gKYQkNqh-F_A',
    appId: '1:540403678087:web:520abccf00a39cd55b3122',
    messagingSenderId: '540403678087',
    projectId: 'instagram-99284',
    authDomain: 'instagram-99284.firebaseapp.com',
    storageBucket: 'instagram-99284.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCmRE3oHbzppHeDzEVVckkknP7uGbwNz3I',
    appId: '1:540403678087:android:f27d6735bf6993c45b3122',
    messagingSenderId: '540403678087',
    projectId: 'instagram-99284',
    storageBucket: 'instagram-99284.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-EVdvMsiXz8vp7UghM1jJCA7JILcNeiE',
    appId: '1:540403678087:ios:fdbcbf04a5c19c0c5b3122',
    messagingSenderId: '540403678087',
    projectId: 'instagram-99284',
    storageBucket: 'instagram-99284.appspot.com',
    iosClientId: '540403678087-b4bihcok2vvjr9p91rnufatktsf4on5v.apps.googleusercontent.com',
    iosBundleId: 'com.example.instagram',
  );
}
