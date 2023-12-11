import 'package:flutter/material.dart';
import 'package:surveying_app/components/menu_card_template.dart';
import 'package:surveying_app/database_init.dart';
import 'package:surveying_app/surveying_list.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 32),
              child: Text('Function List'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        MediaQuery.of(context).size.width * 0.4, // カードの横幅（最大値）
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SurveyingList()),
                      );
                    },
                    child: MenuCardTemplate(
                        icon: Icon(
                          Icons.note_alt_outlined,
                          size: 100,
                        ),
                        mainTitle: 'Surveying',
                        explain: '水準測量です'),
                  ),
                ),

                // ElevatedButton.icon(
                //   label: Text('Expenses'),
                //   onPressed: () {},
                //   icon: Icon(Icons.payment),
                // ),
                // ElevatedButton.icon(
                //   label: Text('Setting'),
                //   onPressed: () {},
                //   icon: Icon(Icons.settings),
                // ),
                // Container(
                //   width: double.infinity,
                //   child: TextField(),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}
