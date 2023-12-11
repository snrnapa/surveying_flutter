import 'package:flutter/material.dart';
import 'package:surveying_app/components/card_template.dart';
import 'package:surveying_app/components/utils.dart';
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
  List<Map<String, dynamic>> resultTrn = [];

  @override
  void initState() {
    super.initState();
    // 受け取ったデータを状態を管理する変数に格納
    state = widget.result;
    getAllNumber();
  }

  Future getAllNumber() async {
    setState(() => isLoading = true);
    resultTrn = await dbInit.readTrn(state['id'], state['scene_seq']);

    for (var i = 0; i < resultTrn.length; i++) {
      _bsControllers[i].text = resultTrn[i]['bs_number'].toString();
      _fsControllers[i].text = resultTrn[i]['fs_number'].toString();
      _ihControllers[i].text = resultTrn[i]['ih_number'].toString();
      _ghControllers[i].text = resultTrn[i]['gh_number'].toString();
      _bmCheckList[i] = resultTrn[i]['bm_flg'] == '0' ? false : true;
    }

    print(resultTrn);

    setState(() => isLoading = false);
  }

  final dbInit = DatabaseInit.instance;
  double textWidth = 60;
  double textSize = 15;
  double fieldTextSize = 13;
  double iconFieldSize = 100;
  double elementHeight = 600;
  int itemCount = 20;

  // 題名部分の変数など
  var utils = Utils();

  // BSの値をコントロールする
  late final List<TextEditingController> _bsControllers =
      List.generate(itemCount, (i) => TextEditingController());
  // FSの値をコントロールする
  late final List<TextEditingController> _fsControllers =
      List.generate(itemCount, (i) => TextEditingController());
  // IHの値をコントロールする
  late final List<TextEditingController> _ihControllers =
      List.generate(itemCount, (i) => TextEditingController());
  // GHの値をコントロールする
  late final List<TextEditingController> _ghControllers =
      List.generate(itemCount, (i) => TextEditingController());

  // 測点を連番で作成する
  late final List<String> _pointList = List.generate(itemCount, (i) => "No.$i");
  late final List<bool> _bmCheckList =
      List<bool>.generate(itemCount, (i) => false);

  void AllCalclate() {
    for (var j = 0; j < _pointList.length; j++) {
      if (_bmCheckList[j]) {
        IhCalclate(
          j,
          _ghControllers[j].text,
          _bsControllers[j].text,
        );
        print("IHの計算を行いました${j}番目");
      } else {
        GhCalclate(j, _ghControllers[j - 1].text, _fsControllers[j].text,
            _fsControllers[j - 1].text);
        print("GHの計算を行いました${j}番目");
      }
    }
  }

  void GhCalclate(int index, String gh, String fs, String lastFs) {
    double targetGh = 0;
    double targetFs = 0;

    if (gh != "" && fs != "") {
      targetGh = double.parse(gh);
      targetFs = double.parse(fs);
    } else {
      return;
    }
    double targetLastFs = 0;
    if (!lastFs.isEmpty) {
      targetLastFs = double.parse(lastFs);
    }
    _ghControllers[index].text =
        (targetGh + targetFs - targetLastFs).toString();
  }

  void IhCalclate(int index, String baesGh, String bs) {
    double targetBaseGh = 0;
    double targetBs = 0;

    if (baesGh != "" && bs != "") {
      targetBaseGh = double.parse(baesGh);
      targetBs = double.parse(bs);
    } else {
      return;
    }
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
        "bm_flg": _bmCheckList[i] ? 1 : 0,
        "list_index": i,
        "bs_number": _bsControllers[i].text,
        "fs_number": _fsControllers[i].text,
        "ih_number": _ihControllers[i].text,
        "gh_number": _ghControllers[i].text,
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
              body: Column(
                children: [
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
                      IconButton(
                        onPressed: () => {getAllNumber()},
                        icon: const Icon(Icons.published_with_changes),
                      ),
                    ],
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: DataTable(
                      dividerThickness: 2,
                      horizontalMargin: 10,
                      columnSpacing: 10.0,
                      columns: const [
                        DataColumn(
                            label: Text(
                          'BM',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )),
                        DataColumn(
                            label: Text(
                          'No',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )),
                        DataColumn(
                            label: Text(
                          'BS',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )),
                        DataColumn(
                            label: Text(
                          'Ih',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )),
                        DataColumn(
                            label: Text(
                          'FS',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )),
                        DataColumn(
                            label: Text(
                          'Gh',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )),
                      ],
                      rows: [
                        for (int index = 0; index < itemCount; index++)
                          //BMちぇっくりすと
                          DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                // All rows will have the same selected color.
                                if (states.contains(MaterialState.selected)) {
                                  return Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.08);
                                }
                                // Even rows will have a grey color.
                                if (index.isEven) {
                                  return Colors.blue[100];
                                }
                                return null; // Use default value for other states and odd rows.
                              }),
                              cells: [
                                DataCell(Checkbox(
                                  value: _bmCheckList[index],
                                  onChanged: (bool? checkedValue) {
                                    setState(() {
                                      _bmCheckList[index] = checkedValue!;
                                    });
                                  },
                                )),
                                //PointListちぇっくりすと
                                DataCell(
                                  TextFormField(
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      // controller: _pointControllers[index]);
                                      initialValue: _pointList[index]),
                                ),
                                //BS
                                DataCell(Container(
                                  child: TextFormField(
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                    enabled: _bmCheckList[index],
                                    controller: _bsControllers[index],
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        filled: !_bmCheckList[index],
                                        fillColor: Colors.black26),
                                  ),
                                )),
                                //Ih
                                DataCell(
                                  TextFormField(
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                    enabled: false,
                                    controller: _ihControllers[index],
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        filled: true,
                                        fillColor: Colors.black26),
                                  ),
                                ),
                                //FS
                                DataCell(
                                  TextFormField(
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                    enabled: !_bmCheckList[index],
                                    controller: _fsControllers[index],
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        filled: _bmCheckList[index],
                                        fillColor: Colors.black26),
                                  ),
                                ),

                                //GH
                                DataCell(
                                  TextFormField(
                                    style: TextStyle(
                                      fontSize: fieldTextSize,
                                    ),
                                    controller: _ghControllers[index],
                                    readOnly: !_bmCheckList[index],
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ]),
                      ],
                    ),
                  ))
                ],
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
