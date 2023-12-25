import 'package:flutter/material.dart';
import 'package:surveying_app/components/drawer_helper.dart';
import 'package:surveying_app/components/title_text.dart';
import 'package:surveying_app/components/utils.dart';

class ReviewDevelopper extends StatefulWidget {
  @override
  _ReviewDevelopperPageState createState() => _ReviewDevelopperPageState();
}

class _ReviewDevelopperPageState extends State<ReviewDevelopper> {
  List<Map<String, dynamic>> resultCardList = [];
  bool isLoading = false;
  var utils = Utils();

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("ReviewDevelopper"),
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TitleText(text: '開発者へのレビュー'),
              IconButton(
                  onPressed: () => DrawerHelper.launchStoreReview(context),
                  icon: Icon(Icons.reviews)),
              const Card(
                // color: Color.fromARGB(207, 28, 225, 163),
                child: Column(children: [
                  ListTile(
                    leading: Icon(Icons.developer_board),
                    title: Text("Developper Info"),
                    subtitle: Text("Name : Napa \n Age : 27"),
                  ),
                  ListTile(
                    leading: Icon(Icons.adb),
                    title: Text("Technology"),
                    subtitle: Text("バックエンドエンジニア Java,GoLang,React,Flutter"),
                  ),
                  ListTile(
                    leading: Icon(Icons.work),
                    title: Text("Career"),
                    subtitle: Text(
                        "・大学で土木工学を４年間専攻\n・新卒で県庁へ入庁。3年間従事。\n・未経験からIT転職のため上京。\n・・客室乗務員アプリのバックエンドを担当。\n・都内ITコンサルタントへ転職。"),
                  ),
                  ListTile(
                    leading: Icon(Icons.contact_mail),
                    title: Text("Contact・SNS"),
                    subtitle: Text(
                        "mail:   shino.satoru@gmail.com\ngithub:   https://github.com/snrnapa"),
                  ),
                ]),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
