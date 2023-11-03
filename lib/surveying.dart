import 'package:flutter/material.dart';

class Surveying extends StatelessWidget {
  final List<List<String>> data = [
    ['A1', 'B1'],
    ['A2', 'B2'],
    ['A3', 'B3'],
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surveying'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '野帳',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 30,
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Table(
              children: _buildTableRows(),
            ),
            Text(
              '野帳Dev',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 30,
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                    children: List.generate(100, (index) => index).map((no) {
                  return TableRow(
                    children: [Text('$no')],
                  );
                }).toList()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TableRowの動的生成
  List<TableRow> _buildTableRows() {
    return data.map((row) {
      return TableRow(
        children: row.map((cell) => Text(cell)).toList(),
      );
    }).toList();
  }
}
