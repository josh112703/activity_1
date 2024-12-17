import 'package:activity_1/history.dart';
import 'package:flutter/material.dart';
import 'navbar.dart';
import 'appbar.dart';
import 'login.dart';
import 'forecast.dart'; // Import the CommentPage
import 'history.dart';
import 'user.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to the CommentPage when the "Add" button is tapped
    if (index == 1) {
      // Assuming "Add" is the second tab (index 1)
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const ForecastPage()), // Navigate to the comment page
      );
    }
    if (index == 2) {
      // Assuming "Add" is the second tab (index 1)
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const HistoryPage()), // Navigate to the comment page
      );
    }
    if (index == 3) {
      // Assuming "Add" is the second tab (index 1)
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const UserPage()), // Navigate to the comment page
      );
    }
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'P.A.R.O.T',
        titleStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        logoPath: '../assets/images/parot_logo.png',
        onLogout: () => _logout(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Region V - Albay',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildForecastCard('10 Day Projected Forecast'),
            const SizedBox(height: 16),
            _buildForecastCard('Annual Projected Forecast'),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildForecastCard(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 150,
          width: double.infinity,
          color: Colors.grey.shade300,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
