import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveying_app/components/card_template.dart';
import 'package:surveying_app/components/utils.dart';
import 'package:surveying_app/surveying.dart';
import 'package:surveying_app/surveying_list_edit.dart';
import 'database_init.dart';

class SurveyingList extends StatefulWidget {
  @override
  _SurveyingListPageState createState() => _SurveyingListPageState();
}

class _SurveyingListPageState extends State<SurveyingList> {
  List<Map<String, dynamic>> resultCardList = [];
  bool isLoading = false;
  var utils = Utils();

  deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("id : ${resultCardList[index]['id']} の内容を削除しようとしています"),
        content: const Text("削除する場合はOKをタップしてください"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deleteMstAndTrn(index);
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getAllSceneList();
  }

  //すべてのシーンを取得する
  Future getAllSceneList() async {
    setState(() => isLoading = true);
    List<Map<String, dynamic>> result = await dbInit.queryAllRows();
    setState(() => resultCardList = result);
    setState(() => isLoading = false);
  }

  //　指定した現場データの削除
  void deleteMstAndTrn(int resultIndex) async {
    int deleteTargetId = resultCardList[resultIndex]['id'];
    int deleteTargetSeq = resultCardList[resultIndex]['scene_seq'];

    String massage =
        "次の現場データを削除しました。 id = ${deleteTargetId} seq = ${deleteTargetSeq}";

    int dummy1 = await dbInit.deleteMst(deleteTargetId);
    int dummy2 = await dbInit.deleteTrn(deleteTargetId, deleteTargetSeq);

    Utils.deleteImage(resultCardList[resultIndex]['file_name']);

    ScaffoldMessenger.of(context).showSnackBar(utils.makeSnackBar(massage));

    getAllSceneList();
  }

  //　シーンを追加する
  void insertScene(String method) async {
    int targetId = 1;
    final maxId = await dbInit.queryMaxId();
    if (maxId != null) {
      targetId = maxId + 1;
    }

    String file_path = await Utils.execImage(method);

    var targetRow = <String, dynamic>{
      'id': targetId,
      'scene_name': sceneNameController.text,
      'scene_seq': 1,
      'scene_note': sceneNoteController.text,
      'upd_date': utils.time2Str(),
      'file_name': file_path,
      'person_in_charge': scenePersonController.text,
      'place': scenePlaceController.text,
    };

    dbInit.insert(targetRow);

    getAllSceneList();

    String massage = "";

    massage += "下記データの保存が完了しました\n";
    massage += "ID:${targetId} \n ${sceneNameController.text} ";

    ScaffoldMessenger.of(context).showSnackBar(utils.makeSnackBar(massage));
    sceneNameController.text = "";
    sceneNoteController.text = "";
    scenePersonController.text = "";
    scenePlaceController.text = "";
  }

  // 保存済みのシーンを編集する画面へ遷移する
  void navigatorEdit(int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute<bool>(
          builder: (context) =>
              SurveyingListEdit(result: resultCardList[index])),
    );

    getAllSceneList();
  }

  final dbInit = DatabaseInit.instance;

  TextEditingController sceneNameController = TextEditingController();
  TextEditingController sceneNoteController = TextEditingController();
  TextEditingController scenePersonController = TextEditingController();
  TextEditingController scenePlaceController = TextEditingController();

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
                title: const Text("SceneList"),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: _width * 0.9,
                      child: Card(
                        elevation: 10,
                        margin: const EdgeInsets.all(7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.blue[100],
                        child: Column(
                          children: <Widget>[
                            const ListTile(
                              title: Text("新規追加"),
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
                                    decoration: const InputDecoration(
                                        labelText: "Note"),
                                  ),
                                  TextField(
                                    controller: scenePersonController,
                                    decoration:
                                        const InputDecoration(labelText: "担当"),
                                  ),
                                  TextField(
                                    controller: scenePlaceController,
                                    decoration: const InputDecoration(
                                        labelText: "Place"),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          insertScene("camera");
                                        },
                                        icon: const Icon(
                                          Icons.add_a_photo,
                                          size: 32,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          insertScene("album");
                                        },
                                        icon: const Icon(
                                          Icons.photo_library,
                                          size: 32,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          insertScene("none");
                                        },
                                        icon: const Icon(
                                          Icons.no_sim,
                                          size: 32,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    ListView.builder(
                      shrinkWrap: true, //追加
                      physics: const NeverScrollableScrollPhysics(), //追加
                      itemCount: resultCardList.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Surveying(
                                          result: resultCardList[index])),
                                );
                              },
                              onLongPress: () {},
                              child:
                                  CardTemplate(result: resultCardList[index]),
                            ),
                            SizedBox(
                              width: _width * 0.1,
                              child: Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      deleteDialog(index);
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      navigatorEdit(index);
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
