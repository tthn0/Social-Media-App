// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool obscure;

  const Input({
    required this.label,
    required this.icon,
    required this.controller,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        obscureText: this.obscure,
        controller: this.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: this.label,
          prefixIcon: Icon(
            icon,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String label;
  final ThemeData theme;
  final VoidCallback onPressed;

  const Button({
    required this.label,
    required this.theme,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: this.theme.primaryColor.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: FlatButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: this.onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              this.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        color: this.theme.primaryColor,
      ),
    );
  }
}
