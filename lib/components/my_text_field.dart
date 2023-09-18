import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    Key? key, // Add the key parameter here
    required this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key); // Specify the key parameter in the constructor

  @override
  Widget build(BuildContext context) {
    return TextField(
          controller: controller,
          obscureText: obscureText,
          minLines: 1,
          maxLines: 5,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0), // Circular edge
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0), // Circular edge
              borderSide: BorderSide(color: Colors.white),
            ),
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 140, 138, 138),
            ),
          ),
    );
  }
}
