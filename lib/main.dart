import 'dart:io';

import 'package:flutter/material.dart';
import 'package:surveying_app/components/menu_card_template.dart';
import 'package:surveying_app/database_init.dart';
import 'package:surveying_app/surveying_list.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surveying Napa',
      theme: ThemeData(
        textTheme: GoogleFonts.murechoTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'Surveying App ver.dev1.0'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbInit = DatabaseInit.instance;

  File? image;

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 32),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: _width * 0.4,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SurveyingList()),
                      );
                    },
                    child: const MenuCardTemplate(
                        icon: Icon(
                          Icons.note_alt_outlined,
                          size: 100,
                        ),
                        mainTitle: 'Surveying',
                        explain: '水準測量'),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: _width * 0.4, // カードの横幅（最大値）
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SurveyingList()),
                      );
                    },
                    child: const MenuCardTemplate(
                        icon: Icon(
                          Icons.collections,
                          size: 100,
                        ),
                        mainTitle: 'Picture on Mapping',
                        explain: '地図上に写真を配置'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: _height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: _width * 0.4, // カードの横幅（最大値）
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SurveyingList()),
                      );
                    },
                    child: const MenuCardTemplate(
                        icon: Icon(
                          Icons.payments,
                          size: 100,
                        ),
                        mainTitle: 'Expense',
                        explain: '経費精算アプリ'),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: _width * 0.4, // カードの横幅（最大値）
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SurveyingList()),
                      );
                    },
                    child: const MenuCardTemplate(
                        icon: Icon(
                          Icons.collections,
                          size: 100,
                        ),
                        mainTitle: 'Setting',
                        explain: '各種設定'),
                  ),
                ),
              ],
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: _width * 0.4, // カードの横幅（最大値）
              ),
              child: GestureDetector(
                onTap: () {
                  dbInit.dropDatabase();
                },
                child: const MenuCardTemplate(
                    icon: Icon(
                      Icons.adb,
                      size: 100,
                    ),
                    mainTitle: 'Debug',
                    explain: '開発用 DBを削除します'),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: _width * 0.4, // カードの横幅（最大値）
              ),
              child: GestureDetector(
                onTap: () {
                  dbInit.initDatabase();
                },
                child: const MenuCardTemplate(
                    icon: Icon(
                      Icons.adb,
                      size: 100,
                    ),
                    mainTitle: 'Debug',
                    explain: '開発用 DBを新規作成します'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
