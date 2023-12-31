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
        return macos;
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
    apiKey: 'AIzaSyAunfruX5K0ihaerbX1ZCIz9CFqPndi-W8',
    appId: '1:1085985549026:web:27260236db53945d380cbb',
    messagingSenderId: '1085985549026',
    projectId: 'notication',
    authDomain: 'notication.firebaseapp.com',
    storageBucket: 'notication.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2hmb71KS8ZxI4DU1jCGHmziC6PeBoVas',
    appId: '1:1085985549026:android:716830b4efc57def380cbb',
    messagingSenderId: '1085985549026',
    projectId: 'notication',
    storageBucket: 'notication.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAsULGbmDjdc_XQV_KXVzaFgdOR808PNYQ',
    appId: '1:1085985549026:ios:0d93144e7fa33011380cbb',
    messagingSenderId: '1085985549026',
    projectId: 'notication',
    storageBucket: 'notication.appspot.com',
    iosBundleId: 'com.vanh.notifications',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAsULGbmDjdc_XQV_KXVzaFgdOR808PNYQ',
    appId: '1:1085985549026:ios:8157e95fe2d064e4380cbb',
    messagingSenderId: '1085985549026',
    projectId: 'notication',
    storageBucket: 'notication.appspot.com',
    iosBundleId: 'com.vanh.notifications.RunnerTests',
  );
}
