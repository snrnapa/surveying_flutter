import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:surveying_app/components/card_template.dart';
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

  @override
  void initState() {
    super.initState();

    // 受け取ったデータを状態を管理する変数に格納
    state = widget.result;
  }

  final dbInit = DatabaseInit.instance;
  double textWidth = 60;
  double textSize = 15;
  double fieldTextSize = 13;
  double iconFieldSize = 100;
  double elementHeight = 600;

  // 題名部分の変数など
  DateTime now = DateTime.now();
  DateFormat format = DateFormat('yyyy-MM-dd hh:mm:ss');

  Map<String, List> saveTargetMap = {};

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
    // List pointResult = [];
    // List bsResult = [];
    // List fsResult = [];
    // List ihResult = [];
    // List ghResult = [];

    // for (var i = 0; i < _bsControllers.length; i++) {
    //   pointResult.add(_pointList[i]);
    //   bsResult.add(_bsControllers[i].text);
    //   ihResult.add(_ihControllers[i].text);
    //   fsResult.add(_fsControllers[i].text);
    //   ghResult.add(_ghControllers[i].text);
    // }

    // saveTargetMap['pointRes'] = pointResult;
    // saveTargetMap['bsRes'] = bsResult;
    // saveTargetMap['ifRes'] = ihResult;
    // saveTargetMap['fsRes'] = fsResult;
    // saveTargetMap['ghRes'] = ghResult;
    // print("-------------------計算結果出力開始-------------------");

    // saveTargetMap.forEach((key, value) {
    //   print('$key --- $value');
    // });

    // print("-------------------計算結果出力開始-------------------");

    // int sceneId = 35;
    // String sceneName = "テスト工事測量";
    // int sceneSeq = 1;

    // Map<String, dynamic> row = {
    //   "id": sceneId,
    //   "scene_name": sceneName,
    //   "snece_seq": sceneSeq
    // };

    // _query();

    // final resultId = await dbInit.insert(row);
    // print('登録しました。id: $resultId');
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
