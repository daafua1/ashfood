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
    apiKey: 'AIzaSyCYHhjuoPy_Z5QxpyFwXd1LWsHn4ShUvf8',
    appId: '1:808463964758:web:6d2ecbf017048e9e5339f7',
    messagingSenderId: '808463964758',
    projectId: 'daafua-ashfood',
    authDomain: 'daafua-ashfood.firebaseapp.com',
    storageBucket: 'daafua-ashfood.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAzYEQ6dOAZuWrQ8IvlhoFR_2xzslW_dso',
    appId: '1:808463964758:android:82061b8511fbd5a75339f7',
    messagingSenderId: '808463964758',
    projectId: 'daafua-ashfood',
    storageBucket: 'daafua-ashfood.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBE1ibLOY4Tvepj_xwvCXo9ZV_B9JsKf7c',
    appId: '1:808463964758:ios:d4a649416462745d5339f7',
    messagingSenderId: '808463964758',
    projectId: 'daafua-ashfood',
    storageBucket: 'daafua-ashfood.appspot.com',
    iosClientId: '808463964758-sqt8b6s3k3pus9dhqbrp5gto5tth7jbl.apps.googleusercontent.com',
    iosBundleId: 'com.example.ashfood',
  );
}
