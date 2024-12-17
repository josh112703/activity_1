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
  final VoidCallback? onTap; // Added onTap callback for datePicker

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.variant = TextFieldVariant.normal,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onTap, // Accepting onTap callback for datePicker
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
            suffixIcon: suffixIcon,
          ),
        );
        break;
    }

    // Wrapping the TextFormField with GestureDetector to handle onTap for datePicker
    return GestureDetector(
      onTap: onTap, // Trigger the onTap callback for date picker
      child: textFormFieldVariant,
    );
  }
}
