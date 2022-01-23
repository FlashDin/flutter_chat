// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA72kO2v1pcPlr1jgjVNIZKVP4kr0xfuKQ',
    appId: '1:277832416635:web:6afc3064c0f3669db711de',
    messagingSenderId: '277832416635',
    projectId: 'flutter-chat-cbbc0',
    authDomain: 'flutter-chat-cbbc0.firebaseapp.com',
    storageBucket: 'flutter-chat-cbbc0.appspot.com',
    measurementId: 'G-JQ1KLH21CC',
    databaseURL: 'https://flutter-chat-cbbc0-default-rtdb.asia-southeast1.firebasedatabase.app'
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBOq_8KemuwNngMfv17Yq7MxZDjrFc9_k0',
    appId: '1:277832416635:android:391b3e77493985efb711de',
    messagingSenderId: '277832416635',
    projectId: 'flutter-chat-cbbc0',
    storageBucket: 'flutter-chat-cbbc0.appspot.com',
    databaseURL: 'https://flutter-chat-cbbc0-default-rtdb.asia-southeast1.firebasedatabase.app'
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCFiW5VAW2R_xTfb2X4LuTgj7G6XamXfS0',
    appId: '1:277832416635:ios:4973560e41f58f6db711de',
    messagingSenderId: '277832416635',
    projectId: 'flutter-chat-cbbc0',
    storageBucket: 'flutter-chat-cbbc0.appspot.com',
    iosClientId: '277832416635-n4qajo20ov067g9rebumg60k9pvkohmi.apps.googleusercontent.com',
    iosBundleId: 'com.example.app',
    databaseURL: 'https://flutter-chat-cbbc0-default-rtdb.asia-southeast1.firebasedatabase.app'
  );
}
