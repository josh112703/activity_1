import 'package:flutter/material.dart';
import 'button.dart';
import 'textfield.dart';

final emailController = TextEditingController();
final passwordController = TextEditingController();
final confirmPasswordController = TextEditingController();
final firstNameController = TextEditingController();
final lastNameController = TextEditingController();
final ageController = TextEditingController();
final birthdayController = TextEditingController();

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
          child: SingleChildScrollView(
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
                    color: Color.fromRGBO(94, 117, 45, 1),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: 'Enter First Name',
                        controller: firstNameController,
                        variant: TextFieldVariant.normal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        hintText: 'Enter Last Name',
                        controller: lastNameController,
                        variant: TextFieldVariant.normal,
                      ),
                    ),
                  ],
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
                  obscureText: !_showPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 9) {
                      return 'Password must be at least 9 characters';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Confirm Password',
                  controller: confirmPasswordController,
                  variant: TextFieldVariant.confirmPassword,
                  obscureText: !_showConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Enter Age',
                  controller: ageController,
                  variant: TextFieldVariant.number,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Enter Birthday',
                  controller: birthdayController,
                  variant: TextFieldVariant.birthday,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  label: 'Sign Up',
                  onPressed: () => _handleSignUp(context),
                  variant: ButtonVariant.primary,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to the login page
                  },
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        birthdayController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _handleSignUp(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      _showMessage(context, 'Passwords do not match');
      return;
    }

    try {
      // Add Firebase sign-up logic here, e.g., FirebaseAuth.createUserWithEmailAndPassword
      _showMessage(context, 'Sign Up Successful');
    } catch (e) {
      _showMessage(context, 'Sign Up failed: ${e.toString()}');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
