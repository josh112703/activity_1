import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
import 'appbar.dart';
import 'navbar.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  // Function to fetch user data from Firestore
  Future<Map<String, String>> _getUserData() async {
    // Get current user from FirebaseAuth
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Fetch user data from Firestore using the userId
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid) // Use the current user's UID to fetch data
          .get();

      if (userDoc.exists) {
        return {
          'firstName': userDoc['firstName'],
          'lastName': userDoc['lastName'],
        };
      } else {
        return {
          'firstName': 'John',
          'lastName': 'Doe'
        }; // Default if no data found
      }
    } else {
      throw Exception('No user is logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching user data'));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('No user data available'));
        }

        // Extract first name and last name from snapshot
        final firstName = snapshot.data?['firstName'] ?? 'John';
        final lastName = snapshot.data?['lastName'] ?? 'Doe';

        return Scaffold(
          appBar: CustomAppBar(
            title: 'User Profile',
            titleStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            onLogout: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Picture
                Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: const NetworkImage(
                        'https://via.placeholder.com/150'), // Placeholder image URL
                    // Replace with user's profile picture URL if available
                  ),
                ),
                const SizedBox(height: 20),

                // User Name (firstName and lastName)
                Text(
                  '$firstName $lastName', // Display dynamic first and last name
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                // Buttons Section
                Column(
                  children: [
                    // Edit Profile Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // Navigate to edit profile page
                          Navigator.pushNamed(context, '/editProfile');
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Profile'),
                      ),
                    ),

                    // Report Problem Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // Navigate to report problem page
                          Navigator.pushNamed(context, '/reportProblem');
                        },
                        icon: const Icon(Icons.report),
                        label: const Text('Report Problem'),
                      ),
                    ),

                    // Logout Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // Logout and navigate to login page
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: 3, // User Page
            onTap: (index) {
              if (index != 3) {
                Navigator.pop(context); // Return to the parent navigation
              }
            },
          ),
        );
      },
    );
  }
}
