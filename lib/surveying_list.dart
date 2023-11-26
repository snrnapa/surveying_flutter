import 'package:flutter/material.dart';

class SurveyingList extends StatefulWidget {
  @override
  _SurveyingListPageState createState() => _SurveyingListPageState();
}

class _SurveyingListPageState extends State<SurveyingList> {
  List<String> elementList = ["test1", "test2222"];
  List<String> datetimeList = ["2023/12/11", "2023/12/23"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("SurveyinList"),
        ),
        body: ListView.builder(
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.green,
          child: const Icon(Icons.add_circle),
        ),
      ),
    );
  }
}
