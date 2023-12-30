//setup for Form Field
import 'package:flutter/material.dart';

class MyFormField extends StatelessWidget {
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  const MyFormField({
    this.validator,
    Key? key,
    required this.controller,
    required this.hintText,
    required this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: TextFormField(
        controller: controller,
        validator: validator,
        minLines: 1,
        maxLines: maxLines,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
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
