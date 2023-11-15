import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'todo_item.dart';
import 'todo_add_page.dart';

class Surveying extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<Surveying> {
  List<double> bsList = [2.333, 2.11, 3.11];
  List<double> fsList = [];

  double bs = 0;
  double fs = 0;
  double gh = 0;
  final TextEditingController _pointController = TextEditingController();
  final TextEditingController _backSightController = TextEditingController();
  final TextEditingController _frontSightController = TextEditingController();

  //FSとBSを合計しGHを算出する
  double CalculateGroundHeight() {
    gh = bs + fs;
    return gh;
  }

  final selectedIndex = <int>[];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text("Surveying v1.0.0"),
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("地点"),
                    Text("BackSight"),
                    Text("FrontSight"),
                    Text("GroundHeight"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(1),
                      margin: EdgeInsets.all(10.0),
                      height: 500,
                      width: 100,
                      color: Colors.blue,
                      // padding: EdgeInsets.all(4),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(5.0),
                        itemCount: bsList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('${bsList[index]}'),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(1),
                      margin: EdgeInsets.all(10.0),
                      height: 500,
                      width: 100,
                      color: Colors.blue,
                      // padding: EdgeInsets.all(4),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(5.0),
                        itemCount: bsList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('${bsList[index]}'),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(1),
                      margin: EdgeInsets.all(10.0),
                      height: 500,
                      width: 100,
                      color: Colors.blue,
                      // padding: EdgeInsets.all(4),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(5.0),
                        itemCount: bsList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('${bsList[index]}'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ])),
    );
  }
}
