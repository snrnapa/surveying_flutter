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
      color: Colors.blue[400],
      child: Column(
        children: [
          ListTile(
            title: Text(
                style: TextStyle(color: Colors.white),
                "No.${result['id']}\n${result['scene_name']}"),
            subtitle: Text(
                style: TextStyle(color: Colors.white),
                "${result['scene_note']}"),
            leading: Icon(Icons.engineering),
          ),
          Text(result['upd_date'])
        ],
      ),
    );
  }
}
