import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key? key,
    required this.dispText,
  }) : super(key: key);
  final String dispText;

  @override
  Widget build(BuildContext context) {
    return Text(
      dispText,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    );
  }
}
