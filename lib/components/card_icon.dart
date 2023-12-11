import 'package:flutter/material.dart';

class CardIcon extends StatelessWidget {
  const CardIcon({
    Key? key,
    required this.icon,
  }) : super(key: key);
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(child: icon);
  }
}
