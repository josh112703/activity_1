import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard.dart';
import 'button.dart';
import 'textfield.dart';

final firstnameController = TextEditingController();
final lastnameController = TextEditingController();
final emailController = TextEditingController();
final passwordController = TextEditingController();

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 18),
                CustomTextField(
                  hintText: 'Enter First Name',
                  controller: firstnameController,
                  variant: TextFieldVariant.normal,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Enter Last Name',
                  controller: lastnameController,
                  variant: TextFieldVariant.normal,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Enter Email',
                  controller: emailController,
                  variant: TextFieldVariant.email,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Enter Password',
                  controller: passwordController,
                  variant: TextFieldVariant.password,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  label: 'Sign Up',
                  onPressed: () => _handleSignUp(context),
                  variant: ButtonVariant.primary,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  label: 'Back to Login',
                  onPressed: () => Navigator.pop(context),
                  variant: ButtonVariant.outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignUp(BuildContext context) async {
    final firstname = firstnameController.text.trim();
    final lastname = lastnameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (firstname.isEmpty) {
      _showMessage(context, 'Please enter your first name');
    } else if (lastname.isEmpty) {
      _showMessage(context, 'Please enter your last name');
    } else if (email.isEmpty || !email.contains('@')) {
      _showMessage(context, 'Please enter a valid email');
    } else if (password.isEmpty || password.length < 9) {
      _showMessage(context, 'Password must be at least 9 characters');
    } else {
      try {
        // Firebase Authentication sign-up
        final auth = FirebaseAuth.instance;
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Save user details to Firestore
        final user = userCredential.user;
        if (user != null) {
          final firestore = FirebaseFirestore.instance;
          await firestore.collection('users').doc(user.uid).set({
            'firstName': firstname,
            'lastName': lastname,
            'email': email,
          });
        }

        // Navigate to the Dashboard after successful sign-up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        );
      } catch (e) {
        // Show error message if sign-up or Firestore save fails
        _showMessage(context, 'Sign up failed: ${e.toString()}');
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
