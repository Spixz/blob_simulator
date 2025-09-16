import 'package:flutter/material.dart';

class ParameterTitle extends StatelessWidget {
  const ParameterTitle(this.title, {double fontSize = 20}) : fontSize = fontSize;
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
        SizedBox(height: 10),
      ],
    );
  }
}
