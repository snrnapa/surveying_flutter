import 'package:flutter/material.dart';

var devlist = [
      "Taro",
    "Hanako",
    "Eri",
    "Koji",
]

class Surveying extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Surveying'),
        ),
        body: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(''),
            ),
            DataColumn(
              label: Text('BS/後視'),
            ),
            DataColumn(
              label: Text('FS/前視'),
            ),
            DataColumn(
              label: Text('Calc'),
            ),
          ],
          rows: const <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text('1')),
                DataCell(Text('5.677')),
                DataCell(Text('5.777')),
                DataCell(Text('Result')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('2')),
                DataCell(Text('5.677')),
                DataCell(Text('5.777')),
                DataCell(Text('Result')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('2')),
                DataCell(Text('5.677')),
                DataCell(Text('5.777')),
                DataCell(Text('Result')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('2')),
                DataCell(Text('5.677')),
                DataCell(Text('5.777')),
                DataCell(Text('Result')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('2')),
                DataCell(Text('5.677')),
                DataCell(Text('5.777')),
                DataCell(Text('Result')),
              ],
            ),
          ],
        ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => print(devlist),
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      );

        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => print(devlist),
        //   child: const Icon(Icons.add),
        // ),
      // );
  }
}
