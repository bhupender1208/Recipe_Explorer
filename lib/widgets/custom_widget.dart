import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget
{
  final String hintText;
  final String labelText;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextFieldWidget({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.icon,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(

        hintText: hintText,
        prefixIcon: Icon(icon),
        labelText: labelText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color:
          Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color:
          Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color:
          Colors.red),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color:
          Colors.red),
        ),
      ),
    );
  }
}
