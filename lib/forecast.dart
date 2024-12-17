// In ForecastPage.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'appbar.dart';
import 'navbar.dart';
import 'textfield.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weatherController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Save function to add the forecast data to Firestore
  void _saveForecast() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseFirestore.instance.collection('forecast').add({
          'date': Timestamp.fromDate(
              DateFormat('yyyy-MM-dd HH:mm').parse(_dateController.text)),
          'weather': _weatherController.text,
          'notes': _notesController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Forecast added successfully!')));
        // Clear the fields after saving
        _dateController.clear();
        _weatherController.clear();
        _notesController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Forecast',
        titleStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        onLogout: () => Navigator.pushReplacementNamed(context, '/login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Forecast Correction',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Date Picker Text Field (Reusable Component)
              CustomTextField(
                controller: _dateController,
                hintText: 'Select Date and Time',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date and time';
                  }
                  return null;
                },
                variant:
                    TextFieldVariant.datePicker, // Use the datePicker variant
              ),
              const SizedBox(height: 20),

              // Weather Text Field (Reusable Component)
              CustomTextField(
                controller: _weatherController,
                hintText: 'Actual Weather',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter actual weather';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Notes Text Field (Reusable Component)
              CustomTextField(
                controller: _notesController,
                hintText: 'Notes',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter notes';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveForecast,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1, // Assuming this is the "Add" tab
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/forecast');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/settings');
          }
        },
      ),
    );
  }
}
