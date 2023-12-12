import 'package:flutter/material.dart';
import 'package:surveying_app/database_init.dart';

class CardTemplate extends StatelessWidget {
  CardTemplate({
    Key? key,
    required this.result,
  }) : super(key: key);
  final Map<String, dynamic> result;

  final dbInit = DatabaseInit.instance;
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Card(
        elevation: 10,
        margin: const EdgeInsets.all(7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.green[100],
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              Container(
                width: _width * 0.45,
                // color: Colors.black,
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                        title: Text(
                            'No.${result['id']}   ${result['scene_name']}'),
                        subtitle: Text('Note:${result['scene_note']}')),
                    const Text(
                        style: TextStyle(fontSize: 13, color: Colors.black),
                        "担当者 : Napa"),
                    Text(
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black),
                        "Upd : ${result['upd_date']}"),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                width: _width * 0.35,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('appImage/kushima.jpg'),
                ),
              ),
            ],
          ),
        ));
  }
}
