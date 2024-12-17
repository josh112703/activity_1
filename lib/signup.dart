import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                  hintText: 'Enter Birthday',
                  controller: birthdayController,
                  variant: TextFieldVariant.birthday,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Enter Age',
                  controller: ageController,
                  variant: TextFieldVariant.number,
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
      _calculateAndSetAge(pickedDate); // Call age calculation
    });
  }
}

// Helper function to calculate and set age
void _calculateAndSetAge(DateTime birthDate) {
  DateTime today = DateTime.now();
  int age = today.year - birthDate.year;

  // Adjust age if the birthday has not occurred yet this year
  if (birthDate.month > today.month ||
      (birthDate.month == today.month && birthDate.day > today.day)) {
    age--;
  }

  ageController.text = age.toString();
}


  Future<void> _handleSignUp(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final age = ageController.text.trim();
    final birthday = birthdayController.text.trim();

    // Validate form fields
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        age.isEmpty ||
        birthday.isEmpty) {
      _showMessage(context, 'Please fill in all fields');
      return;
    }

    if (password != confirmPassword) {
      _showMessage(context, 'Passwords do not match');
      return;
    }

    try {
      // Firebase Authentication: Create user with email and password
      final auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      final userId = userCredential.user?.uid;
      if (userId != null) {
        final usersCollection = FirebaseFirestore.instance.collection('users');
        await usersCollection.doc(userId).set({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'age': int.parse(age), // Store age as integer
          'birthday': birthday, // Store birthday as string or DateTime
        });

        // Navigate to the login page after successful sign-up
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      _showMessage(context, 'Sign Up failed: ${e.message}');
    }
  }

  // Show messages to the user
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
