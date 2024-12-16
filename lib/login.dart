import 'package:flutter/material.dart';
import 'button.dart';
import 'textfield.dart';
import 'dashboard.dart';
import 'signup.dart';

final emailController = TextEditingController();
final passwordController = TextEditingController();

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('../assets/images/parot_logo.png', height: 100),
              const SizedBox(height: 10),
              const Text(
                'P.A.R.O.T',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5E752D),
                ),
              ),
              const SizedBox(height: 18),
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
                label: 'Login',
                onPressed: () => _handleLogin(context),
                variant: ButtonVariant.primary,
              ),
              const SizedBox(height: 16),
              CustomButton(
                label: 'Sign Up',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpPage()),
                ),
                variant: ButtonVariant.secondary,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Forgot password action
                  _showMessage(
                      context, "Forgot Password functionality coming soon!");
                },
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      _showMessage(context, 'Please enter a valid email');
    } else if (password.isEmpty || password.length < 6) {
      _showMessage(context, 'Password must be at least 6 characters');
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
