import 'package:flutter/material.dart';

class MyDropdownButton extends StatelessWidget {
  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;
  final String hintText;

  const MyDropdownButton({
    Key? key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> dropdownItems = items.map<DropdownMenuItem<String>>(
      (String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      },
    ).toList();

    if (hintText.isNotEmpty) {
      dropdownItems.insert(
        0,
        DropdownMenuItem<String>(
          value: '',
          child: Text(
            hintText,
            style: const TextStyle(
              color: Colors.grey, // Customize hint text color if needed
            ),
          ),
        ),
      );
    }

    return DropdownButtonFormField<String>(
      value: value,
      items: dropdownItems,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0, // Adjust the vertical padding to match MyTextField
          horizontal: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
