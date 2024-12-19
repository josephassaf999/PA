import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_assistant_app/settings%20page/theme_notifier.dart';
import 'package:personal_assistant_app/welcomepage.dart';
import 'package:personal_assistant_app/NotificationService.dart'; // Import the service
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDEh6Wq5PrP5jECYCPBbj1cQEEj2qvqP0U',
      appId: '1:591953709360:android:451b5dab8a50dc7646e0f5',
      projectId: 'personal-assistant-8eb7d',
      storageBucket: 'personal-assistant-8eb7d.appspot.com',
      messagingSenderId: '591953709360',
    ),
  );

  // Initialize Notification Service
  final notificationService = NotificationService(); // Create an instance
  await notificationService.initialize(); // Initialize notifications

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            themeMode: themeNotifier.currentTheme,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const WelcomePage(),
          );
        },
      ),
    );
  }
}
