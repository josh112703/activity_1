import 'package:activity_1/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDVHWIhgp7fupdEIxqs2RcrcWsbWNU8OaE",
          authDomain: "parot-977fa.firebaseapp.com",
          projectId: "parot-977fa",
          storageBucket: "parot-977fa.firebasestorage.app",
          messagingSenderId: "974905887063",
          appId: "1:974905887063:web:3603e18d340b619b0fd612"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromRGBO(240, 255, 173, 1)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
