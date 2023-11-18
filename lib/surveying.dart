import 'package:flutter/material.dart';

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

  final List<TextEditingController> _bsControllers =
      List.generate(5, (i) => TextEditingController());
  final List<TextEditingController> _fsControllers =
      List.generate(5, (i) => TextEditingController());

  // final results = List<String>.generate(5, (i) => "Item $i");
  final List<String> results = List<String>.generate(5, (i) => "Item $i");

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
          body: Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Back"),
                        Text("Front"),
                        Text("Calc"),
                      ]),
                ),
                Container(
                  width: double.infinity,
                  height: 500,
                  child: ListView.builder(
                    itemCount: _bsControllers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TextField(
                        controller: _bsControllers[index],
                        keyboardType: TextInputType.number,
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 500,
                  child: ListView.builder(
                    itemCount: _fsControllers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TextField(
                        controller: _fsControllers[index],
                        keyboardType: TextInputType.number,
                      );
                    },
                  ),
                ),
                Container(
                  width: 100,
                  // height: 500,
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.teal),
                        ),
                        onPressed: () {
                          setState(() {
                            int targetBs =
                                int.parse(_bsControllers[index].text);
                            int targetFs =
                                int.parse(_fsControllers[index].text);
                            results[index] = (targetBs + targetFs).toString();
                          });
                        },
                        child: Text(
                          '${results[index]}',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
