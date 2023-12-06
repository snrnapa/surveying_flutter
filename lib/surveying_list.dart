import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_init.dart';

class SurveyingList extends StatefulWidget {
  @override
  _SurveyingListPageState createState() => _SurveyingListPageState();
}

class _SurveyingListPageState extends State<SurveyingList> {
  List<Map<String, dynamic>> resultCardList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAllSceneList();
  }

  Future getAllSceneList() async {
    setState(() => isLoading = true);
    resultCardList = await dbInit.queryAllRows();
    setState(() => isLoading = false);
  }

  void insertScene() async {
    int targetId = 1;
    final maxId = await dbInit.queryMaxId();
    if (maxId != null) {
      targetId = maxId + 1;
    }

    var targetRow = <String, dynamic>{
      'id': targetId,
      'scene_name': sceneNameController.text,
      'scene_seq': 1,
      'scene_note': sceneNoteController.text,
      'upd_date': formatTimeStamp.format(now),
    };

    dbInit.insert(targetRow);
    getAllSceneList();

    // print(targetRow);
  }

  final dbInit = DatabaseInit.instance;

  TextEditingController sceneNameController = TextEditingController();
  TextEditingController sceneNoteController = TextEditingController();

  DateTime now = DateTime.now();
  DateFormat formatTimeStamp = DateFormat('yyyy-MM-dd hh:mm:ss');

  Future<int?> deleteAll() async {
    final allRows = await dbInit.delete();
    print(allRows);
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
                title: Text("SurveyinList"),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: TextField(
                              controller: sceneNameController,
                              decoration:
                                  InputDecoration(labelText: "Scene Name"),
                            ),
                            subtitle: TextField(
                              controller: sceneNoteController,
                              decoration: InputDecoration(labelText: "Note"),
                            ),
                            leading: Icon(Icons.post_add),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true, //追加
                      physics: NeverScrollableScrollPhysics(), //追加
                      itemCount: resultCardList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                    "No.${resultCardList[index]['id']}\n${resultCardList[index]['scene_name']}"),
                                subtitle: Text(
                                    "${resultCardList[index]['scene_note']}"),
                                leading: Icon(Icons.engineering),
                              ),
                              Text(resultCardList[index]['upd_date'])
                            ],
                          ),
                        );
                      },
                    ),
                    Column(
                      children: [
                        TextButton(
                            onPressed: () => {dbInit.delete()},
                            child: Text("削除")),
                      ],
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  insertScene();
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.add_circle),
              ),
            ),
          );
  }
}
