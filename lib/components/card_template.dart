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
      color: Colors.green[100],
      child: Row(
        children: [
          Container(
            width: 200,
            // color: Colors.black,
            alignment: Alignment.centerLeft,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('No.${result['id']}   ${result['scene_name']}'),
                  subtitle: Text('${result['scene_note']}'),
                ),
                Text(
                    style: TextStyle(fontSize: 13, color: Colors.black),
                    "${result['upd_date']}"),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(8),
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('appImage/kushima.jpg'),
              ))
        ],
      ),
    );
  }
}
