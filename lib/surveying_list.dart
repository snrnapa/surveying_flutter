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

  Future insertSceneList() async {
    setState(() => isLoading = true);
    resultCardList = await dbInit.queryAllRows();
    setState(() => isLoading = false);
  }

  final dbInit = DatabaseInit.instance;

  TextEditingController sceneNameController = TextEditingController();
  TextEditingController sceneNoticeController = TextEditingController();

  DateTime now = DateTime.now();
  DateFormat formatTimeStamp = DateFormat('yyyy-MM-dd hh:mm:ss');

  void _insert() async {
    final maxId = await dbInit.queryMaxId();

    int targetId = 0;

    if (maxId != null) {
      targetId = maxId + 1;
    }

    var targetRow = <String, dynamic>{
      'id': targetId,
      'scene_name': sceneNameController.text,
      'scene_seq': 1,
      'upd_date': formatTimeStamp.format(now),
    };

    dbInit.insert(targetRow);

    // print(targetRow);
  }

  Future<int?> getMaxId() async {
    final allRows = await dbInit.queryMaxId();
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
                              controller: sceneNoticeController,
                              decoration: InputDecoration(labelText: "Notice"),
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
                                    "${resultCardList[index]['upd_date']}"),
                                leading: Icon(Icons.engineering),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Column(
                      children: [
                        TextButton(
                            onPressed: () => {getMaxId()}, child: Text("最大ID")),
                      ],
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _insert();
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.add_circle),
              ),
            ),
          );
  }
}
