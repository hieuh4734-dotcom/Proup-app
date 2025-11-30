// File: lib/firebase_options.dart
// Được tạo dựa trên google-services.json
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyAnXnqN8y8JotN7E8iCuzKPh-GuoMXFQQU',
    appId: '1:275867047380:web:865625229871b6fb69f241',
    messagingSenderId: '275867047380',
    projectId: 'proup-5095f',
    authDomain: 'proup-5095f.firebaseapp.com',
    storageBucket: 'proup-5095f.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnXnqN8y8JotN7E8iCuzKPh-GuoMXFQQU',
    appId: '1:275867047380:android:865625229871b6fb69f241',
    messagingSenderId: '275867047380',
    projectId: 'proup-5095f',
    storageBucket: 'proup-5095f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAnXnqN8y8JotN7E8iCuzKPh-GuoMXFQQU',
    appId: '1:275867047380:ios:865625229871b6fb69f241',
    messagingSenderId: '275867047380',
    projectId: 'proup-5095f',
    storageBucket: 'proup-5095f.firebasestorage.app',
    iosBundleId: 'com.example.proup',
  );
}

