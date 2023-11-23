import 'package:flutter/material.dart';

class Surveying extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<Surveying> {
  double bs = 0;
  double fs = 0;
  double gh = 0;

  double textWidth = 60;
  double textSize = 15;
  double fieldTextSize = 13;
  double iconFieldSize = 100;
  double elementHeight = 600;

  // Pointの値をコントロールする
  final List<TextEditingController> _pointControllers =
      List.generate(10, (i) => TextEditingController());
  // BSの値をコントロールする
  final List<TextEditingController> _bsControllers =
      List.generate(10, (i) => TextEditingController());
  // FSの値をコントロールする
  final List<TextEditingController> _fsControllers =
      List.generate(10, (i) => TextEditingController());

  // IHの値をコントロールする
  final List<TextEditingController> _ihControllers =
      List.generate(10, (i) => TextEditingController());

  // GHの値をコントロールする
  final List<TextEditingController> _ghControllers =
      List.generate(10, (i) => TextEditingController());

  // 測点を連番で作成する
  final List<String> _pointList = List.generate(10, (i) => "No.$i");

  final List<String> results = List<String>.generate(10, (i) => "Item $i");

  final List<bool> _bmCheckList = List<bool>.generate(10, (i) => false);

  void GhCalclate(int index, String gh, String fs, String lastFs) {
    double targetGh = double.parse(gh);
    double targetFs = double.parse(fs);
    double targetLastFs = 0;
    if (!lastFs.isEmpty) {
      targetLastFs = double.parse(lastFs);
    }
    _ghControllers[index].text =
        (targetGh + targetFs - targetLastFs).toString();
  }

  void IhCalclate(int index, String baesGh, String bs) {
    double targetBaseGh = double.parse(baesGh);
    double targetBs = double.parse(bs);
    _ihControllers[index].text = (targetBaseGh + targetBs).toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text("Surveying v1.0.0"),
          ),
          body: SingleChildScrollView(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        "NoteBook",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: textSize,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.edit_note),
                    ],
                  ),
                  const Divider(
                    height: 20,
                    endIndent: 0,
                    color: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // bmのチェックボックスリストを作成する
                      Container(
                        child: Column(
                          children: [
                            HeaderText(dispText: "BM"),
                            Container(
                              width: 20,
                              height: elementHeight,
                              child: ListView.builder(
                                itemCount: _bmCheckList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Checkbox(
                                    value: _bmCheckList[index],
                                    onChanged: (bool? checkedValue) {
                                      setState(() {
                                        _bmCheckList[index] = checkedValue!;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            HeaderText(dispText: "Point"),
                            Container(
                              width: textWidth,
                              height: elementHeight,
                              child: ListView.builder(
                                itemCount: _pointList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TextFormField(
                                      style: TextStyle(
                                        fontSize: fieldTextSize,
                                      ),
                                      readOnly: true,
                                      // controller: _pointControllers[index]);
                                      initialValue: _pointList[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            HeaderText(dispText: "BS"),
                            Container(
                              width: textWidth,
                              height: elementHeight,
                              child: ListView.builder(
                                itemCount: _bsControllers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TextFormField(
                                    style: TextStyle(
                                      fontSize: fieldTextSize,
                                    ),
                                    enabled: _bmCheckList[index],
                                    controller: _bsControllers[index],
                                    decoration: InputDecoration(
                                        filled: !_bmCheckList[index],
                                        fillColor: Colors.black12),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            HeaderText(dispText: "IH"),
                            Container(
                              width: textWidth,
                              height: elementHeight,
                              child: ListView.builder(
                                itemCount: _bsControllers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TextFormField(
                                    style: TextStyle(
                                      fontSize: fieldTextSize,
                                    ),
                                    enabled: true,
                                    controller: _ihControllers[index],
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.black12),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            HeaderText(dispText: "FS"),
                            Container(
                              width: textWidth,
                              height: elementHeight,
                              child: ListView.builder(
                                itemCount: _bsControllers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TextFormField(
                                    style: TextStyle(
                                      fontSize: fieldTextSize,
                                    ),
                                    enabled: !_bmCheckList[index],
                                    controller: _fsControllers[index],
                                    decoration: InputDecoration(
                                        filled: _bmCheckList[index],
                                        fillColor: Colors.black12),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          child: Column(
                        children: [
                          Text(
                            "GH",
                            style: TextStyle(
                              fontSize: textSize,
                            ),
                          ),
                          Container(
                            width: iconFieldSize,
                            height: elementHeight,
                            child: ListView.builder(
                              itemCount: results.length,
                              itemBuilder: (BuildContext context, int index) {
                                return TextFormField(
                                  style: TextStyle(
                                    fontSize: fieldTextSize,
                                  ),
                                  controller: _ghControllers[index],
                                  readOnly: !_bmCheckList[index],
                                  decoration: InputDecoration(
                                    prefixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (_bmCheckList[index]) {
                                            IhCalclate(
                                              index,
                                              _ghControllers[index].text,
                                              _bsControllers[index].text,
                                            );
                                          } else {
                                            GhCalclate(
                                                index,
                                                _ghControllers[index - 1].text,
                                                _fsControllers[index].text,
                                                _fsControllers[index - 1].text);
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.calculate),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      )),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key? key,
    required this.dispText,
  }) : super(key: key);
  final String dispText;

  @override
  Widget build(BuildContext context) {
    return Text(
      dispText,
      style: TextStyle(
        fontSize: 15,
      ),
    );
  }
}
