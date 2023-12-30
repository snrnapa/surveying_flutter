import 'dart:io';

import 'package:flutter/material.dart';
import 'package:surveying_app/components/utils.dart';
import 'package:surveying_app/database_init.dart';

class SurveyingListEdit extends StatefulWidget {
  final Map<String, dynamic> result;

  // コンストラクタ
  const SurveyingListEdit({Key? key, required this.result}) : super(key: key);

  @override
  _SurveyingListEditPageState createState() => _SurveyingListEditPageState();
}

class _SurveyingListEditPageState extends State<SurveyingListEdit> {
  late TextEditingController sceneNameController =
      TextEditingController(text: state['scene_name']);
  late TextEditingController sceneNoteController =
      TextEditingController(text: state['scene_note']);
  late TextEditingController scenePersonController =
      TextEditingController(text: state['person_in_charge']);
  late TextEditingController scenePlaceController =
      TextEditingController(text: state['place']);

  late Map<String, dynamic> state;
  bool isLoading = false;
  var utils = Utils();
  final dbInit = DatabaseInit.instance;
  // 現場情報の更新を行う
  void updateSceneInfo(String method) async {
    var _targetRow = <String, dynamic>{};
    _targetRow.addAll(state);

    _targetRow['scene_name'] = sceneNameController.text;
    _targetRow['scene_note'] = sceneNoteController.text;
    _targetRow['person_in_charge'] = scenePersonController.text;
    _targetRow['place'] = scenePlaceController.text;
    _targetRow['upd_date'] = utils.time2Str();

    final beforePicture = File(_targetRow['file_name']);

    String savedFileName = await Utils.execImage(method);

    if (savedFileName != null && savedFileName != "") {
      _targetRow['file_name'] = savedFileName;
      beforePicture.delete();
    }

    dbInit.update(_targetRow);

    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    // 受け取ったデータを状態を管理する変数に格納
    state = widget.result;
  }

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
                title: const Text("Edit"),
              ),
              body: SizedBox(
                height: _height * 0.8,
                child: Card(
                  elevation: 10,
                  margin: const EdgeInsets.all(7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("編集"),
                      ),
                      SizedBox(
                        width: _width * 0.7,
                        child: Column(
                          children: [
                            TextField(
                              controller: sceneNameController,
                              decoration: const InputDecoration(
                                  labelText: "Scene Name"),
                            ),
                            TextField(
                              controller: sceneNoteController,
                              decoration:
                                  const InputDecoration(labelText: "Note"),
                            ),
                            TextField(
                              controller: scenePersonController,
                              decoration:
                                  const InputDecoration(labelText: "担当"),
                            ),
                            TextField(
                              controller: scenePlaceController,
                              decoration:
                                  const InputDecoration(labelText: "Place"),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              width: _width * 0.35,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: (state['file_name'] != "" &&
                                          state['file_name'] != null)
                                      ? Image.file(File(state['file_name']))
                                      : const Icon(
                                          Icons.no_sim,
                                          size: 100,
                                        )),
                            ),
                            Text("更新種類"),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        updateSceneInfo("camera");
                                      },
                                      icon: const Icon(
                                        Icons.add_a_photo,
                                        size: 32,
                                      ),
                                    ),
                                    Text("カメラ"),
                                    IconButton(
                                      onPressed: () {
                                        updateSceneInfo("album");
                                      },
                                      icon: const Icon(
                                        Icons.photo_library,
                                        size: 32,
                                      ),
                                    ),
                                    Text("ギャラリー"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        updateSceneInfo("none");
                                      },
                                      icon: const Icon(
                                        Icons.no_sim,
                                        size: 32,
                                      ),
                                    ),
                                    Text("変更なし/写真なし"),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
