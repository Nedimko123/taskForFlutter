import 'package:amygdal/screens/final%20screens/archive.dart';
import 'package:amygdal/screens/final%20screens/done.dart';
import 'package:amygdal/screens/editors/noteeditor.dart';

import 'package:flutter/material.dart';

import 'logic/db.dart';
import 'screens/adders/noteadder.dart';
import 'screens/adders/categoryadder.dart';

//Malo trening providera riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Glavni screen
void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          brightness: Brightness.dark,
          useMaterial3: true),
      home: const MyHomePage(title: 'Notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    createdatabase();
    listofCategoriestherightway = _getCategories();
    super.initState();
  }

  //Filtriranje po kategoriji
  late Future listofCategoriestherightway;
  String selectedCategory = '';
  _getCategories() async {
    return await categorySelector();
  }

//Boja zastave
  Widget pussintheboots({required int importance}) {
    if (importance == 1) {
      return const Icon(Icons.flag, color: Colors.red);
    } else if (importance == 2) {
      return const Icon(Icons.flag, color: Colors.orange);
    } else {
      return const Icon(Icons.flag, color: Colors.green);
    }
  }

//Boja teksta
  Map<String, Color> nameToColor = {
    'red': Colors.red,
    'blue': Colors.blue,
    'black': Colors.black,
    'yellow': Colors.yellow,
    'green': Colors.green,
  };
//Checker for stream which one

  _streamChecker(String category) {
    if (truthChecker == 1) {
      return Stream.fromFuture(selectorbyDate());
    } else if (truthChecker == 2) {
      return Stream.fromFuture(selector());
    } else if (truthChecker == 3) {
      return Stream.fromFuture(selectorbyCategory(category: category));
    }
  }

  int truthChecker = 1;

  //Color for category

  @override
  Widget build(BuildContext context) {
    // Color color = Colors.red;
    // String _storeColorValue = color.value.toString();
    // int value = int.parse(_storeColorValue);

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.indigo,

        actions: [
          PopupMenuButton(
              onSelected: ((value) {
                if (value == 1) {
                  setState(() {
                    truthChecker = 1;
                    selector();
                    print(noteList);
                  });
                } else if (value == 2) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const CategoryAdder())))
                    ..then(((value) {
                      setState(() {
                        selector();
                      });
                    }));
                } else if (value == 3) {
                  setState(() {
                    truthChecker = 2;
                    selectorbyDate();
                  });
                } else if (value == 4) {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const Archive())))
                      ..then(((value) {
                        setState(() {
                          selector();
                        });
                      }));
                  });
                } else if (value == 5) {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => const Done())))
                      ..then(((value) {
                        setState(() {
                          selector();
                        });
                      }));
                  });
                } else if (value == 6) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            actions: [
                              Center(
                                child: FutureBuilder(
                                    future: listofCategoriestherightway,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.hasData) {
                                          return DropdownButton(
                                            value: selectedCategoryExport,
                                            items: categoryList
                                                .map((item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    )))
                                                .toList(),
                                            onChanged: (item) => setState(() {
                                              selectedCategory =
                                                  item.toString();

                                              truthChecker = 3;
                                              Navigator.of(context).pop();
                                            }),
                                          );
                                        } else {
                                          return const Text('Nothing here');
                                        }
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    }),
                              )
                            ],
                          ));
                }
              }),
              itemBuilder: ((context) => [
                    const PopupMenuItem(
                      child: Text('Sort values by importance'),
                      value: 1,
                    ),
                    const PopupMenuItem(
                      child: Text('Sort values by date'),
                      value: 3,
                    ),
                    const PopupMenuItem(
                      child: Text('Add new category'),
                      value: 2,
                    ),
                    const PopupMenuItem(
                      child: Text('Tasks archive'),
                      value: 4,
                    ),
                    const PopupMenuItem(
                      child: Text('Tasks done'),
                      value: 5,
                    ),
                    const PopupMenuItem(
                      child: Text('Filter by category'),
                      value: 6,
                    ),
                  ]))
        ],
      ),
      body: StreamBuilder<Object>(
          stream: _streamChecker(selectedCategory),
          builder: (context, snapshot) {
            return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        actions: [
                                          Center(
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    archiveInsertor(
                                                        name: noteList[index]
                                                            ['name'],
                                                        importance:
                                                            noteList[index]
                                                                ['importance'],
                                                        category:
                                                            noteList[index]
                                                                ['category'],
                                                        date: noteList[index]
                                                            ['dates']);
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                child: const Text(
                                                    'Send to archive')),
                                          ),
                                          Center(
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    noteDelete(
                                                        index: noteList[index]
                                                            ['id']);
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                child: const Text(
                                                    'Delete the task!!')),
                                          )
                                        ],
                                      ));
                            },
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          const NoteEditor()),
                                      settings: RouteSettings(
                                          arguments: noteList[index]['id']),
                                    ))
                                  ..then(((value) {
                                    setState(() {
                                      selector();
                                    });
                                  }));
                              });
                            },
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  doneInsertor(
                                      name: noteList[index]['name'],
                                      importance: noteList[index]['importance'],
                                      category: noteList[index]['category'],
                                      date: noteList[index]['dates']);
                                  noteDelete(index: noteList[index]['id']);
                                });
                              },
                              icon: const Icon(Icons.done),
                              color: Colors.green,
                            ),
                            leading: GestureDetector(
                              onTap: () {},
                              child: pussintheboots(
                                  importance: noteList[index]['importance']),
                            ),
                            title: Text(
                              noteList[index]['name'],
                              style: TextStyle(
                                  color: nameToColor[noteList[index]['color']]),
                            ),
                            subtitle: Text('Category:' +
                                noteList[index]['category'].toString() +
                                ' Date:' +
                                noteList[index]['dates'].toString()),
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: noteList.length);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const NoteAdder())))
            ..then(((value) {
              setState(() {
                selector();
              });
            }));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
