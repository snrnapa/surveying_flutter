import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_init.dart';

class SurveyingList extends StatefulWidget {
  @override
  _SurveyingListPageState createState() => _SurveyingListPageState();
}

class _SurveyingListPageState extends State<SurveyingList> {
  final dbInit = DatabaseInit.instance;
  List<String> elementList = ["test1", "test2222"];
  List<String> datetimeList = ["2023/12/11", "2023/12/23"];

  TextEditingController sceneNameController = TextEditingController();
  TextEditingController sceneNoticeController = TextEditingController();

  DateTime now = DateTime.now();
  DateFormat format = DateFormat('yyyy-MM-dd hh:mm:ss');

  void _insert() async {
    final maxId = await dbInit.queryMaxId();

    int targetId = 0;

    if (maxId != null) {
      targetId = maxId + 1;
    }

    Map<String, dynamic> row = {
      "id": targetId,
      "scene_name": sceneNameController.text,
      "scene_seq": 1,
      "upd_date": format.format(now),
    };
    final id = await dbInit.insert(row);
    print('登録しました。id: $id');
  }

  void _query() async {
    final allRows = await dbInit.queryAllRows();
    print('全てのデータを照会しました。');
    allRows.forEach(print);
  }

  Future<int?> getMaxId() async {
    final allRows = await dbInit.queryMaxId();
    print(allRows);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("SurveyinList"),
        ),
        body: Column(
          children: [
            ListView.builder(
              shrinkWrap: true, //追加
              physics: NeverScrollableScrollPhysics(), //追加
              itemCount: elementList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("SceneName:${elementList[index]}"),
                        subtitle: Text("LastUpdDate:${datetimeList[index]}"),
                        leading: Icon(Icons.done),
                      ),
                    ],
                  ),
                );
              },
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: TextField(
                      controller: sceneNameController,
                      decoration: InputDecoration(labelText: "Scene Name"),
                    ),
                    subtitle: TextField(
                      decoration: InputDecoration(labelText: "Notice"),
                    ),
                    leading: Icon(Icons.post_add),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                TextButton(onPressed: () => {getMaxId()}, child: Text("最大ID")),
                TextButton(onPressed: () => {_query()}, child: Text("全検索")),
              ],
            )
          ],
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
