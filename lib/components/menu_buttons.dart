import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final String imagePath;

  const MenuButton({
    super.key, 
    required this.buttonText,
    required this.onPressed,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 110, // Set a fixed width
          height: 120, // Set a fixed height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1.5,
                blurRadius: 5,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.zero, // Remove default button padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 48, // Set a fixed height for the image
                    child: Image(
                      image: Image.asset(imagePath).image,
                      fit: BoxFit.contain, // Adjust the image fit
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
