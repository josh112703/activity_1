import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'textfield.dart';
import 'button.dart';
import 'appbar.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each field
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fetch user data from Firestore
  Future<void> _loadUserData() async {
    if (_currentUser != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _firstNameController.text = data['firstName'] ?? '';
          _lastNameController.text = data['lastName'] ?? '';
          _birthdayController.text = data['birthday'] ?? '';
          _ageController.text = data['age']?.toString() ?? '';
        });
      }
    }
  }

  // Function to select date and calculate age
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _birthdayController.text = "${pickedDate.toLocal()}".split(' ')[0];
        _calculateAndSetAge(pickedDate);
      });
    }
  }

  // Helper to calculate and set age
  void _calculateAndSetAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    if (birthDate.month > today.month ||
        (birthDate.month == today.month && birthDate.day > today.day)) {
      age--;
    }

    _ageController.text = age.toString();
  }

  // Save updated user data
  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .set({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'birthday': _birthdayController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Profile',
        titleStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        onLogout: () => Navigator.pushReplacementNamed(context, '/login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Edit Profile',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // First Name
              CustomTextField(
                controller: _firstNameController,
                hintText: 'Enter First Name',
              ),
              const SizedBox(height: 16),

              // Last Name
              CustomTextField(
                controller: _lastNameController,
                hintText: 'Enter Last Name',
              ),
              const SizedBox(height: 16),

              // Birthday
              CustomTextField(
                hintText: 'Enter Birthday',
                controller: _birthdayController,
                variant: TextFieldVariant.birthday,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
              ),
              const SizedBox(height: 16),

              // Age
              CustomTextField(
                hintText: 'Enter Age',
                controller: _ageController,
                variant: TextFieldVariant.number,
              ),
              const SizedBox(height: 32),

              // Save Button
              CustomButton(
                label: 'Save Profile',
                onPressed: _saveProfile,
                variant: ButtonVariant.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
