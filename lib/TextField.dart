import 'package:flutter/material.dart';

enum TextFieldVariant { normal, password, email }

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextFieldVariant variant;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.variant = TextFieldVariant.normal,
    this.validator,
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
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value == '') {
              return 'Please enter your password';
            }
            if (value.length < 9) {
              return 'Password must be at least 9 characters';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        );
        break;
      case TextFieldVariant.email:
        textFormFieldVariant = TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value == '') {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Invalid email';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        );
    }
    return textFormFieldVariant;
  }
}
