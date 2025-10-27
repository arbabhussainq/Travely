import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase for all platforms (web, mobile, desktop)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Helpful error surface so we never get a white screen in debug
  ErrorWidget.builder = (details) => MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Widget error:\n${details.exceptionAsString()}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    ),
  );

  runApp(const TravelyApp());
}
