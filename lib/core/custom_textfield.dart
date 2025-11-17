import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final Color? iconColor;
  final bool obscureText;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;

  const CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.iconColor,
    required this.obscureText,
    this.validator,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obscureText,
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        prefixIconColor: iconColor,
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(
          // fontWeight: FontWeight.bold,
          color: Colors.grey,
          fontFamily: 'Poppins',
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(width: 2, color: Color(0xFF5AD8CC)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
      ),
    );
  }
}
