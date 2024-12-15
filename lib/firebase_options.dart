// File generated by FlutterFire CLI.
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCCNghvMrWOUBgbdPzgUEcA0XSm3g-kyu4',
    appId: '1:578862938675:web:fee2ab10649aa27a048146',
    messagingSenderId: '578862938675',
    projectId: 'instagram-cleanarcth',
    authDomain: 'instagram-cleanarcth.firebaseapp.com',
    storageBucket: 'instagram-cleanarcth.firebasestorage.app',
    measurementId: 'G-E296R49Y6R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuL4irmm6R60nLWBSFVlmDEB8Oivpvs-o',
    appId: '1:578862938675:android:5da3729a8622ee57048146',
    messagingSenderId: '578862938675',
    projectId: 'instagram-cleanarcth',
    storageBucket: 'instagram-cleanarcth.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAOmmr_jNabAKkCt0h_haGsA8GkS977Rdk',
    appId: '1:578862938675:ios:ae74479849114631048146',
    messagingSenderId: '578862938675',
    projectId: 'instagram-cleanarcth',
    storageBucket: 'instagram-cleanarcth.firebasestorage.app',
    iosBundleId: 'com.example.instagramClean',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAOmmr_jNabAKkCt0h_haGsA8GkS977Rdk',
    appId: '1:578862938675:ios:ae74479849114631048146',
    messagingSenderId: '578862938675',
    projectId: 'instagram-cleanarcth',
    storageBucket: 'instagram-cleanarcth.firebasestorage.app',
    iosBundleId: 'com.example.instagramClean',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCCNghvMrWOUBgbdPzgUEcA0XSm3g-kyu4',
    appId: '1:578862938675:web:2fc18b1649901a25048146',
    messagingSenderId: '578862938675',
    projectId: 'instagram-cleanarcth',
    authDomain: 'instagram-cleanarcth.firebaseapp.com',
    storageBucket: 'instagram-cleanarcth.firebasestorage.app',
    measurementId: 'G-FJZS0RTJ8Y',
  );
}
