import 'package:flutter/material.dart';

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 32),
            child: Text('Function List'),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton.icon(
                focusNode: primaryFocus,
                label: Text('Surveying'),
                onPressed: () {},
                icon: Icon(Icons.reorder),
              ),
              ElevatedButton.icon(
                label: Text('Picture on Mapping'),
                onPressed: () {},
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
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyHomePageBody extends StatelessWidget {
  MyHomePageBody({Key? key, this.counter}) : super(key: key);
  final int? counter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('You have pushed the button this many times:'),
          Text('$counter', style: Theme.of(context).textTheme.headline4),
        ],
      ),
    );
  }
}
