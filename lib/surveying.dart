import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:surveying_app/components/card_template.dart';
import 'package:surveying_app/components/utils.dart';
import 'components/bs_list_container.dart';
import 'components/fs_list_container.dart';
import 'components/ih_list_container.dart';
import 'components/header_text.dart';
import 'components/list_container.dart';
import 'database_init.dart';

class Surveying extends StatefulWidget {
  final Map<String, dynamic> result;

  // コンストラクタ
  const Surveying({Key? key, required this.result}) : super(key: key);

  @override
  _SurveyingPageState createState() => _SurveyingPageState();
}

class _SurveyingPageState extends State<Surveying> {
  // 状態を管理する変数
  late Map<String, dynamic> state;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // 受け取ったデータを状態を管理する変数に格納
    state = widget.result;

    getAllNumber();
  }

  Future getAllNumber() async {
    setState(() => isLoading = true);
    // resultCardList = await dbInit.queryAllRows();
    setState(() => isLoading = false);
  }

  final dbInit = DatabaseInit.instance;
  double textWidth = 60;
  double textSize = 15;
  double fieldTextSize = 13;
  double iconFieldSize = 100;
  double elementHeight = 600;

  // 題名部分の変数など
  var utils = Utils();

  DateTime now = DateTime.now();
  DateFormat format = DateFormat('yyyy-MM-dd hh:mm:ss');

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

  void SaveList() async {
    String nowTime = utils.time2Str();
    List<Map<String, dynamic>> targetMapList = [];

    for (var i = 0; i < _bsControllers.length; i++) {
      Map<String, dynamic> row = {
        "id": state['id'],
        "scene_seq": state['scene_seq'],
        "category": "bs",
        "list_index": i,
        "number": _bsControllers[i].text.isEmpty == true
            ? null
            : _bsControllers[i].text,
        "upd_date": nowTime,
      };

      targetMapList.add(row);
    }

    for (var i = 0; i < _ihControllers.length; i++) {
      Map<String, dynamic> row = {
        "id": state['id'],
        "scene_seq": state['scene_seq'],
        "category": "ih",
        "list_index": i,
        "number": _ihControllers[i].text.isEmpty == true
            ? null
            : _ihControllers[i].text,
        "upd_date": nowTime,
      };
      targetMapList.add(row);
    }

    for (var i = 0; i < _fsControllers.length; i++) {
      Map<String, dynamic> row = {
        "id": state['id'],
        "scene_seq": state['scene_seq'],
        "category": "fs",
        "list_index": i,
        "number": _fsControllers[i].text.isEmpty == true
            ? null
            : _fsControllers[i].text,
        "upd_date": nowTime,
      };
      targetMapList.add(row);
    }

    for (var i = 0; i < _ghControllers.length; i++) {
      Map<String, dynamic> row = {
        "id": state['id'],
        "scene_seq": state['scene_seq'],
        "category": "gh",
        "list_index": i,
        "number": _ghControllers[i].text.isEmpty == true
            ? null
            : _ghControllers[i].text,
        "upd_date": nowTime,
      };
      targetMapList.add(row);
    }

    // print(targetMapList);
    dbInit.readAllTrn().then((value) {
      // value.forEach((eleme) => {
      //   print(eleme);
      // });

      print("${value}\n");
    });

    dbInit.trnDelte(state['id'], state['scene_seq']);

    for (var j = 0; j < targetMapList.length; j++) {
      dbInit.insertTrn(targetMapList[j]);
    }
  }

  // 登録ボタンクリック
  void _insert(sceneId, name, seq) async {
    // Map<String, dynamic> row = {
    //   DatabaseInit.columnId: sceneId,
    //   DatabaseInit.columnSceneName: name,
    //   DatabaseInit.columnSceneSeq: seq
    // };
    // final id = await dbInit.insert(row);
    // print('登録しました。id: $sceneId');
  }

  // 照会ボタンクリック
  void _query() async {
    final allRows = await dbInit.queryAllRows();
    print('全てのデータを照会しました。');
    allRows.forEach(print);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CardTemplate(result: state),
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
                        ListContainer(eleList: _pointList),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        HeaderText(dispText: "BS"),
                        BSListContainer(
                            eleList: _bsControllers, bmCheckList: _bmCheckList),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        HeaderText(dispText: "IH"),
                        IHListContainer(eleList: _ihControllers),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        HeaderText(dispText: "FS"),
                        FSListContainer(
                          eleList: _fsControllers,
                          bmCheckList: _bmCheckList,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            SaveList();
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.save_alt),
        ),
      ),
    );
  }
}
