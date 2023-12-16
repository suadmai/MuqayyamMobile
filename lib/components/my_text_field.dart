import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final bool obscureText;
  final bool isVisible; // New property to control visibility

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.maxLines,
    required this.obscureText,
    this.isVisible = true, // Default value is true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        minLines: 1,
        maxLines: maxLines,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.white),
          ),
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 140, 138, 138),
          ),
        ),
      ),
    );
  }
}