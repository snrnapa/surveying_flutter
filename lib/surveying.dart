import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'todo_item.dart';
import 'todo_add_page.dart';

class Surveying extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<Surveying> {
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
          children: <Widget>[
            // Headerを実装している
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  alignment: Alignment.center, // 子Widgetの配置
                  margin: const EdgeInsets.all(10.0), // 外側余白
                  padding: const EdgeInsets.all(10.0), // 内側余白
                  width: 80,
                  child: Text("地点"),
                ),
                Container(
                  alignment: Alignment.center, // 子Widgetの配置
                  margin: const EdgeInsets.all(10.0), // 外側余白
                  padding: const EdgeInsets.all(10.0), // 内側余白
                  width: 80,
                  child: Text("BS"),
                ),
                Container(
                  alignment: Alignment.center, // 子Widgetの配置
                  margin: const EdgeInsets.all(10.0), // 外側余白
                  padding: const EdgeInsets.all(10.0), // 内側余白
                  width: 80,
                  child: Text("FS"),
                ),
                Container(
                  alignment: Alignment.center, // 子Widgetの配置
                  margin: const EdgeInsets.all(10.0), // 外側余白
                  padding: const EdgeInsets.all(10.0), // 内側余白
                  width: 80,
                  child: Text("GH"),
                )
              ],
            ),
            // 表を実装している。
            for (int i = 0; i < 1; i++) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 50,
                    child: TextField(
                      controller: _pointController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    child: TextField(
                      controller: _backSightController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    child: TextField(
                      controller: _frontSightController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  Text("${gh}")
                ],
              ),
            ],
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _pointController.clear();
                  _backSightController.clear();
                  _frontSightController.clear();
                });
              },
              child: const Text('クリア'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  bs = double.parse(_backSightController.text);
                  fs = double.parse(_frontSightController.text);
                  CalculateGroundHeight();
                });
              },
              child: const Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }
}
