import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // In debug / profile builds, render widget errors as visible text so
  // a white or grey screen never silently hides a crash.
  if (kDebugMode || kProfileMode) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Text(
              '⚠ Widget error:\n${details.exceptionAsString()}',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
      );
    };
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const VetBridgeApp());
}
