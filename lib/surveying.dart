import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'todo_item.dart';
import 'todo_add_page.dart';

class Surveying extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<Surveying> {
  final selectedIndex = <int>[];

  var _tx1 = '';
  var _tf1 = TextEditingController();

  void _txchange() {
    setState(() {
      _tx1 = _tf1.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(children: <Widget>[
      DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              '地点',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              '距離',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              '後視',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              '前視',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              '基準高',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        // rows: [
        //   DataRow(
        //     cells: [
        //       DataCell(TextButton(onPressed: () {}, child: Text("KBM4"))),
        //       DataCell(Text('19')),
        //       DataCell(Text('19')),
        //       DataCell(Text('19')),
        //       DataCell(Text('19')),
        //     ],
        //   ),
        // ],
        rows: List<DataRow>.generate(
            5,
            (index) => DataRow(
                    selected: selectedIndex.contains(index),
                    onSelectChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedIndex.add(index);
                        } else {
                          selectedIndex.remove(index);
                        }
                      });
                    },
                    cells: <DataCell>[
                      // DataCell(Text('No ${index + 1}')),
                      // DataCell(Text('$index + 1}')),
                      // DataCell(Text('$index + 1}')),
                      // DataCell(Text('$index + 1}')),
                      // DataCell(Text('$index + 1}')),
                      DataCell(TextField()),
                      DataCell(TextField()),
                      DataCell(TextField()),
                      DataCell(TextField()),
                      DataCell(TextField()),
                    ])),
      ),
      const Divider(
        height: 50,
        thickness: 5,
        indent: 0,
        endIndent: 0,
        color: Colors.green,
      ),
      // Headerを実装している
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: 80,
            child: Text("地点"),
          ),
          Container(
            width: 80,
            child: Text("BS"),
          ),
          Container(
            width: 80,
            child: Text("FS"),
          ),
          Container(
            width: 80,
            child: Text("Result"),
          )
        ],
      ),
      // 表を実装している。
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: 80,
            child: TextField(
              controller: _tf1,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
            ),
          ),
          Container(
            width: 80,
            child: TextField(
              controller: _tf1,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
            ),
          ),
          Container(
            width: 80,
            child: TextField(
              controller: _tf1,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
            ),
          ),
          Container(
            width: 80,
            child: TextField(
              controller: _tf1,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    ])));
  }
}
