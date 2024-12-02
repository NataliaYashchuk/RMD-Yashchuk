import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? errorText;
  final IconData? icon; // Додано іконку

  const CustomTextField({super.key, 
    required this.labelText,
    this.obscureText = false,
    this.controller,
    this.errorText, // Додано для повідомлень про помилки
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.teal,
            ),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.teal,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal.shade700),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          errorText: errorText, // Додано для відображення помилки
          prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null, // Додаємо іконку, якщо є
        ),
      ),
    );
  }
}

