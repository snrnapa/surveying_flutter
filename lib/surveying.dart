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
  final List<TextEditingController> _resultControllers =
      List.generate(5, (i) => TextEditingController());
  // final TextEditingController _pointController = TextEditingController();
  // final TextEditingController _backSightController = TextEditingController();
  // final TextEditingController _frontSightController = TextEditingController();

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
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return TextField(controller: _bsControllers[index]);
                  },
                  // itemBuilder: (BuildContext context, int index) {
                  //   Text("[index]");
                  // },
                ),
              ),
              Container(
                width: 50,
                height: 500,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return TextField(controller: _fsControllers[index]);
                  },
                ),
              ),
              Container(
                width: 50,
                height: 500,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return TextField(controller: _fsControllers[index]);
                  },
                ),
              ),
            ],
          )),
    );
  }
}
