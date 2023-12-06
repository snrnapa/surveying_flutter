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
  bool existFlg = false;
  List<Map<String, dynamic>> bsTrn = [];
  List<Map<String, dynamic>> fsTrn = [];
  List<Map<String, dynamic>> ghTrn = [];
  List<Map<String, dynamic>> ihTrn = [];

  @override
  void initState() {
    super.initState();
    // 受け取ったデータを状態を管理する変数に格納
    state = widget.result;
    getAllNumber();
  }

  Future getAllNumber() async {
    setState(() => isLoading = true);
    bsTrn = await dbInit.readTrn(state['id'], state['scene_seq'], "bs");
    fsTrn = await dbInit.readTrn(state['id'], state['scene_seq'], "fs");
    ghTrn = await dbInit.readTrn(state['id'], state['scene_seq'], "gh");
    ihTrn = await dbInit.readTrn(state['id'], state['scene_seq'], "ih");
    for (var i = 0; i < bsTrn.length; i++) {
      _bsControllers[i].text = bsTrn[i]['number'].toString();
      _fsControllers[i].text = fsTrn[i]['number'].toString();
      _ghControllers[i].text = ghTrn[i]['number'].toString();
      _ihControllers[i].text = ihTrn[i]['number'].toString();
    }

    print(bsTrn);

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
  final List<bool> _bmCheckList = List<bool>.generate(10, (i) => false);

  void AllCalclate() {
    for (var j = 0; j < _pointList.length; j++) {
      if (_bmCheckList[j]) {
        IhCalclate(
          j,
          _ghControllers[j].text,
          _bsControllers[j].text,
        );
      } else {
        GhCalclate(j, _ghControllers[j - 1].text, _fsControllers[j].text,
            _fsControllers[j - 1].text);
      }
    }
  }

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

  void trnDeleteAndReload() async {
    await dbInit.trnDelte(state['id'], state['scene_seq']);
    await getAllNumber();
  }

  void SaveList() async {
    AllCalclate();
    String nowTime = utils.time2Str();
    List<Map<String, dynamic>> targetMapList = [];

    for (var i = 0; i < _bsControllers.length; i++) {
      Map<String, dynamic> row = {
        "id": state['id'],
        "scene_seq": state['scene_seq'],
        "category": "bs",
        "list_index": i,
        "number": _bsControllers[i].text.isEmpty == true
            ? ""
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

    dbInit.trnDelte(state['id'], state['scene_seq']);

    for (var j = 0; j < targetMapList.length; j++) {
      dbInit.insertTrn(targetMapList[j]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(), //読み込み中の画面表示
          )
        : SafeArea(
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
                      children: [
                        IconButton(
                          onPressed: () => {AllCalclate()},
                          icon: const Icon(Icons.calculate),
                        ),
                        IconButton(
                          onPressed: () => {trnDeleteAndReload()},
                          icon: const Icon(Icons.delete),
                        ),
                      ],
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                  eleList: _bsControllers,
                                  bmCheckList: _bmCheckList),
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
                                itemCount: _ghControllers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TextFormField(
                                    style: TextStyle(
                                      fontSize: fieldTextSize,
                                    ),
                                    controller: _ghControllers[index],
                                    readOnly: !_bmCheckList[index],
                                    decoration: InputDecoration(),
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
