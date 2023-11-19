import 'package:flutter/material.dart';

class Surveying extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<Surveying> {
  double bs = 0;
  double fs = 0;
  double gh = 0;

  final List<TextEditingController> _bsControllers =
      List.generate(10, (i) => TextEditingController());
  final List<TextEditingController> _fsControllers =
      List.generate(10, (i) => TextEditingController());

  final List<TextEditingController> _resultsContollers =
      List.generate(10, (i) => TextEditingController());

  final List<String> _pointList = List.generate(10, (i) => "No * $i");

  final List<String> results = List<String>.generate(10, (i) => "Item $i");

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
          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 50,
                height: 500,
                child: ListView.builder(
                  itemCount: _pointList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TextFormField(
                        readOnly: true, initialValue: _pointList[index]);
                  },
                ),
              ),
              Container(
                width: 50,
                height: 500,
                child: ListView.builder(
                  itemCount: _bsControllers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TextFormField(controller: _bsControllers[index]);
                  },
                ),
              ),
              Container(
                width: 50,
                height: 500,
                child: ListView.builder(
                  itemCount: _fsControllers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TextFormField(controller: _fsControllers[index]);
                  },
                ),
              ),
              Container(
                width: 100,
                height: 500,
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TextFormField(
                      controller: _resultsContollers[index],
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              int targetBs =
                                  int.parse(_bsControllers[index].text);
                              int targetFs =
                                  int.parse(_fsControllers[index].text);
                              results[index] = (targetBs + targetFs).toString();
                              _resultsContollers[index].text = results[index];
                              print(results[index]);
                            });
                          },
                          icon: Icon(Icons.calculate),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
