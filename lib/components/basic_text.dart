import 'package:flutter/material.dart';
import 'package:surveying_app/database_init.dart';

class BasicText extends StatelessWidget {
  BasicText({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Text(style: TextStyle(fontSize: 13, color: Colors.black), text);
  }
}
