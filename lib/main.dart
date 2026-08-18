import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const VetBridgeApp());
}

class VetBridgeApp extends StatelessWidget {
  const VetBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VetBridge',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('VetBridge'),
        ),
        body: const Center(
          child: Text('VetBridge'),
        ),
      ),
    );
  }
}