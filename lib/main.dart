import 'package:flutter/material.dart';
import 'package:personal_assistant_app/settings%20page/theme_notifier.dart';
import 'package:personal_assistant_app/welcomepage.dart';
import 'package:personal_assistant_app/NotificationService.dart';
import 'package:provider/provider.dart';
import 'package:personal_assistant_app/firebase_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await initializeFirebase();

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
            debugShowCheckedModeBanner: false,
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
