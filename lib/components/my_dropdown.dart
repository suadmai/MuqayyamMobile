import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {
  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;
  final String hintText;

  const MyDropdownButton({
    required this.items,
    required this.value,
    required this.onChanged,
    required this.hintText,
  });

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButtonFormField(
          value: widget.value,
          onChanged: widget.onChanged,
          items: widget.items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none, // Remove the border
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 140, 138, 138),
            ),
          ),
        ),
      ),
    );
  }
}
