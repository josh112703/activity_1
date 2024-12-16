import 'button.dart';
import 'textfield.dart';
import 'dashboard.dart';
import 'package:flutter/material.dart';

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

  void _handleSignUp(BuildContext context) {
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
