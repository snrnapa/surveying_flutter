import 'package:flutter/material.dart';
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
                      maxWidth: MediaQuery.of(context).size.width *
                          0.4, // カードの横幅（最大値）
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SurveyingList()),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            // 画像
                            SizedBox(
                                width: double.infinity,
                                height: 128,
                                child: Container(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'appImage/kushima.jpg',
                                        fit: BoxFit.cover,
                                      )),
                                )),
                            // タイトル
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                'Surveying',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            // 説明文
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 4),
                              child: const Text(
                                '水準測量',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                ElevatedButton.icon(
                  focusNode: primaryFocus,
                  label: Text('Surveying'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SurveyingList()),
                    );
                  },
                  icon: Icon(Icons.reorder),
                ),
                ElevatedButton.icon(
                  label: Text('Picture on Mapping'),
                  onPressed: () => {},
                  icon: Icon(Icons.map),
                ),
                ElevatedButton.icon(
                  label: Text('Expenses'),
                  onPressed: () {},
                  icon: Icon(Icons.payment),
                ),
                ElevatedButton.icon(
                  label: Text('Setting'),
                  onPressed: () {},
                  icon: Icon(Icons.settings),
                ),
                Container(
                  width: double.infinity,
                  child: TextField(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
