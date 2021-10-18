import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:test_stress/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _state = true;

  void _showList() {
    setState(() {
      _state = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) async {
    //   await _getAllData();
    // });
  }

  Future<void> _getAllData() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    print(DateTime.now());
    var dbPath = join(dir.path, 'my_database.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var myData = json.decode(await getJson());
    var resultParsed =
        (myData as List).map((dynamic json) => Model.fromMap(json)).toList();
    var store = intMapStoreFactory.store('animals');
    resultParsed.forEach((element) {
      store.add(db, element.toMap());
    });
    print(DateTime.now());
    int value = await store.count(db);
    print('Aqui tem: $value');
    await db.close();
  }

  Future<List<Model>> _getAllDataFromDb() async {
    var dir = await getApplicationDocumentsDirectory();
    print(DateTime.now());
    var dbPath = join(dir.path, 'my_database.db');
    await dir.create(recursive: true);
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('animals');
    var recordSnapshot = await store.find(db);
    print(DateTime.now());
    final result = recordSnapshot.map((snapshot) {
      final forecastResult = Model.fromMap(snapshot.value);
      return forecastResult;
    }).toList();
    return result;
  }

  Future<String> getJson() {
    return rootBundle.loadString('assets/data.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _state
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  ElevatedButton(
                    onPressed: () => _showList(),
                    child: const Text('Aparecer'),
                  ),
                ],
              ),
            )
          : FutureBuilder<List<Model>>(
              future: _getAllDataFromDb(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Model>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          children: [
                            Text(
                              '${snapshot.data![index].id}',
                            ),
                            Text(
                              snapshot.data![index].column1,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Column(
                    children: const <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      )
                    ],
                  );
                }
              },
            ),
    );
  }
}
