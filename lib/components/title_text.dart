import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  TitleText({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
        style: TextStyle(
          fontSize: 20,
          fontStyle: FontStyle.italic,
          letterSpacing: 2.0,
        ),
        text);
  }
}
