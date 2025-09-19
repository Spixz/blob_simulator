import 'package:flutter/material.dart';

class ParameterTitle extends StatelessWidget {
  const ParameterTitle(this.title, {this.fontSize = 20});
  final String title;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
