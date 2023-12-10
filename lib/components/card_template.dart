import 'package:flutter/material.dart';

class CardTemplate extends StatelessWidget {
  const CardTemplate({
    Key? key,
    required this.result,
  }) : super(key: key);
  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.blue[400],
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Text(
                    style: TextStyle(color: Colors.white),
                    "No.${result['id']}\n${result['scene_name']}"),
                Text(
                    style: TextStyle(color: Colors.white),
                    "${result['scene_note']}"),
                Text(result['upd_date']),
              ],
            ),
          ),
          Container(
            width: 100,
            child: Image.asset('appImage/kushima.jpg'),
          )
        ],
      ),
    );
  }
}
