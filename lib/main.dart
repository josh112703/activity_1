import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart'; // Your login page
import 'navbar.dart';
import 'dashboard.dart'; // Your home page
import 'forecast.dart'; // Add page
// import 'library.dart'; // Library page
// import 'profile.dart'; // Profile page
// import 'custom_bottom_navigation.dart'; // Custom bottom nav bar

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDVHWIhgp7fupdEIxqs2RcrcWsbWNU8OaE",
      authDomain: "parot-977fa.firebaseapp.com",
      projectId: "parot-977fa",
      storageBucket: "parot-977fa.firebasestorage.app",
      messagingSenderId: "974905887063",
      appId: "1:974905887063:web:3603e18d340b619b0fd612",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(240, 255, 173, 1),
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(), // Start with LoginPage
    );
  }
}

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    ForecastPage(),
    // LibraryPage(),
    // ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
