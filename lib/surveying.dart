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
  FontStyle headerStyle = FontStyle.italic;
  bool _pictureFlg = false;

  String validateErrorMsg = "入力値にエラーがあるため、実行できませんでした";

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
  late final List<String> _pointList = List.generate(itemCount, (i) => "$i");
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

  bool validateAllFormField() {
    bool validateResult = true;

    for (var i = 0; i < itemCount; i++) {
      validateResult = utils.doubleValidate(_bsControllers[i].text);
      if (!validateResult) {
        break;
      }
      validateResult = utils.doubleValidate(_fsControllers[i].text);
      if (!validateResult) {
        break;
      }
      validateResult = utils.doubleValidate(_ihControllers[i].text);
      if (!validateResult) {
        break;
      }
      validateResult = utils.doubleValidate(_ghControllers[i].text);
      if (!validateResult) {
        break;
      }
    }
    return validateResult;
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
        (targetGh + targetFs - targetLastFs).toStringAsFixed(3);
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
    _ihControllers[index].text = (targetBaseGh + targetBs).toStringAsFixed(3);
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

  Widget buildHeaderText(String dispText) {
    return Text(
      dispText,
      style: TextStyle(fontStyle: headerStyle),
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(), //読み込み中の画面表示
          )
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text("Surveying"),
              ),
              body: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CardTemplate(result: state),
                    const Divider(
                      height: 20,
                      endIndent: 0,
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.calculate),
                          onPressed: () {
                            if (validateAllFormField()) {
                              AllCalclate();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  utils.makeSnackBar(validateErrorMsg));
                            }
                          },
                          label: const Text('計算'),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.save_alt),
                          onPressed: () {
                            if (validateAllFormField()) {
                              SaveList();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  utils.makeSnackBar(validateErrorMsg));
                            }
                          },
                          label: const Text('保存'),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.email),
                          onPressed: () {
                            if (validateAllFormField()) {
                              SaveList();
                              utils.createCSV(resultTrn, state, _pictureFlg);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  utils.makeSnackBar(validateErrorMsg));
                            }
                          },
                          label: const Text('メール'),
                        ),
                        Checkbox(
                          value: _pictureFlg,
                          onChanged: (value) {
                            setState(() {
                              _pictureFlg = value!;
                            });
                          },
                        ),
                        Text("写真添付")
                      ],
                    ),
                    const Divider(
                      height: 20,
                      endIndent: 0,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: _width * 0.9,
                          child: DataTable(
                            dividerThickness: 2,
                            horizontalMargin: 10,
                            columnSpacing: 10.0,
                            columns: [
                              DataColumn(label: buildHeaderText('BM')),
                              DataColumn(label: buildHeaderText('No')),
                              DataColumn(label: buildHeaderText('BS')),
                              DataColumn(label: buildHeaderText('IH')),
                              DataColumn(label: buildHeaderText('FS')),
                              DataColumn(label: buildHeaderText('GH')),
                            ],
                            rows: [
                              for (int index = 0; index < itemCount; index++)
                                //BMちぇっくりすと
                                DataRow(
                                    color: MaterialStateProperty.resolveWith<
                                        Color?>((Set<MaterialState> states) {
                                      // All rows will have the same selected color.
                                      if (states
                                          .contains(MaterialState.selected)) {
                                        return Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.08);
                                      }
                                      // Even rows will have a grey color.
                                      if (index.isEven) {
                                        return Color.fromARGB(
                                            223, 234, 156, 67);
                                      }
                                      return null; // Use default value for other states and odd rows.
                                    }),
                                    cells: [
                                      DataCell(Container(
                                          width: _width * 0.05,
                                          child: Checkbox(
                                            fillColor: MaterialStateProperty
                                                .resolveWith((states) =>
                                                    Colors.transparent),
                                            value: _bmCheckList[index],
                                            onChanged: (bool? checkedValue) {
                                              setState(() {
                                                _bmCheckList[index] =
                                                    checkedValue!;
                                              });
                                            },
                                          ))),
                                      //PointListちぇっくりすと
                                      DataCell(Container(
                                        width: _width * 0.05,
                                        height: _height * 0.2,
                                        child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              fontSize: fieldTextSize,
                                            ),
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            initialValue: _pointList[index]),
                                      )),
                                      //BS
                                      DataCell(Container(
                                        width: _width * 0.1,
                                        height: _height * 0.2,
                                        child: TextFormField(
                                          keyboardType: TextInputType.phone,
                                          style: TextStyle(
                                            fontSize: fieldTextSize,
                                          ),
                                          enabled: _bmCheckList[index],
                                          controller: _bsControllers[index],
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: _bmCheckList[index]
                                                ? null
                                                : "ー",
                                          ),
                                        ),
                                      )),
                                      //Ih
                                      DataCell(Container(
                                        width: _width * 0.15,
                                        height: _height * 0.2,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            fontSize: fieldTextSize,
                                          ),
                                          enabled: false,
                                          controller: _ihControllers[index],
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "ー",
                                          ),
                                        ),
                                      )),
                                      //FS
                                      DataCell(Container(
                                        width: _width * 0.1,
                                        height: _height * 0.2,
                                        child: TextFormField(
                                          keyboardType: TextInputType.phone,
                                          style: TextStyle(
                                            fontSize: fieldTextSize,
                                          ),
                                          enabled: !_bmCheckList[index],
                                          controller: _fsControllers[index],
                                          decoration: InputDecoration(
                                            hintText: _bmCheckList[index]
                                                ? "ー"
                                                : null,
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      )),
                                      //GH
                                      DataCell(Container(
                                        width: _width * 0.15,
                                        height: _height * 0.2,
                                        child: TextFormField(
                                          keyboardType: TextInputType.phone,
                                          style: TextStyle(
                                            fontSize: fieldTextSize,
                                          ),
                                          controller: _ghControllers[index],
                                          readOnly: !_bmCheckList[index],
                                          decoration: !_bmCheckList[index]
                                              ? const InputDecoration(
                                                  hintText: "Auto",
                                                  border: InputBorder.none,
                                                )
                                              : const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                        ),
                                      )),
                                    ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
