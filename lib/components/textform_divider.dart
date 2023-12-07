import 'package:flutter/material.dart';

class TextformDivider extends StatelessWidget {
  const TextformDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: VerticalDivider(
          thickness: 1.0,
          color: Colors.black,
        ));
  }
}
