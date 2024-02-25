import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:malabar_mess_app/screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyAi40gGaqxkIkiYNLkkgnC-H-F-ZhjVr6o',
    appId: '1:477309575160:android:c67a5ed073a609718b800d',
    messagingSenderId: '477309575160',
    projectId: 'malabarmessapp',
  ));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}
