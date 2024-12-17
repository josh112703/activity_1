import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

enum TextFieldVariant {
  normal,
  number,
  password,
  email,
  confirmPassword,
  birthday,
  datePicker, // New datePicker variant
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextFieldVariant variant;
  final String? Function(String?)? validator;
  final bool obscureText;
  final IconButton? suffixIcon;
  final AutovalidateMode autovalidateMode;
  final VoidCallback?
      onTap; // Optional onTap for additional handling like date picker.

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.variant = TextFieldVariant.normal,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    TextFormField textFormFieldVariant;

    switch (variant) {
      case TextFieldVariant.normal:
        textFormFieldVariant = TextFormField(
          controller: controller,
          obscureText: false,
          keyboardType: TextInputType.text,
          validator: validator,
          autovalidateMode: autovalidateMode,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        );
        break;
      case TextFieldVariant.number:
        textFormFieldVariant = TextFormField(
          controller: controller,
          obscureText: false,
          keyboardType: TextInputType.number,
          validator: validator,
          autovalidateMode: autovalidateMode,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        );
        break;
      case TextFieldVariant.password:
        textFormFieldVariant = TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: TextInputType.visiblePassword,
          autovalidateMode: autovalidateMode,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            suffixIcon: suffixIcon,
          ),
        );
        break;
      case TextFieldVariant.email:
        textFormFieldVariant = TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: autovalidateMode,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        );
        break;
      case TextFieldVariant.confirmPassword:
        textFormFieldVariant = TextFormField(
          controller: controller,
          obscureText: obscureText,
          autovalidateMode: autovalidateMode,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            suffixIcon: suffixIcon,
          ),
        );
        break;
      case TextFieldVariant.birthday:
        textFormFieldVariant = TextFormField(
          controller: controller,
          keyboardType: TextInputType.datetime,
          validator: validator,
          autovalidateMode: autovalidateMode,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            suffixIcon: suffixIcon,
          ),
        );
        break;
      case TextFieldVariant.datePicker: // Handle the datePicker variant
        textFormFieldVariant = TextFormField(
          controller: controller,
          keyboardType: TextInputType.datetime,
          readOnly: true, // Prevent keyboard from showing
          validator: validator,
          autovalidateMode: autovalidateMode,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () =>
                  _selectDate(context), // Trigger the date and time picker
            ),
          ),
        );
        break;
    }

    // Wrapping the TextFormField with GestureDetector to handle onTap for datePicker
    return GestureDetector(
      onTap: () =>
          _selectDate(context), // Trigger the onTap callback for date picker
      child: textFormFieldVariant,
    );
  }

  // Function to handle date and time picking
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        controller.text =
            DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
      }
    }
  }
}
