import 'package:flutter/material.dart';

class CardText extends StatelessWidget {
  CardText({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
        style: TextStyle(
          fontSize: 13,
          color: Colors.black,
        ),
        text);
  }
}
