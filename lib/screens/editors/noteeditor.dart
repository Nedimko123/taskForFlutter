import 'package:flutter/material.dart';
import '../../logic/db.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:jiffy/jiffy.dart';
import '../../main.dart';
//Provider trening
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({Key? key}) : super(key: key);

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late Future listofCategoriestherightway;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    listofCategoriestherightway = _getCategories();
  }

  _getCategories() async {
    return await categorySelector();
  }

  String selectedDate = Jiffy().format("yyyy-MM-dd HH:mm");

  String selectedCategory = '';

  List<int> importance = [1, 2, 3];
  int selectedImportance = 1;
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final int indexfornote = ModalRoute.of(context)!.settings.arguments as int;

    final noteThatNeedsToBeEdited = FutureProvider<List>((_) {
      return selectorbyId(index: indexfornote);
    });

    return Scaffold(
        floatingActionButton: ElevatedButton(
            onPressed: () async {
              categoryColor =
                  await colorFromCategory(category: selectedCategoryExport);
              setState(() {
                noteEditor(
                    index: indexfornote,
                    name: _textEditingController.text.toString(),
                    importance: selectedImportance,
                    category: selectedCategoryExport,
                    date: selectedDate,
                    color: categoryColor);
              });
              Navigator.of(context).pop();
            },
            child: Text('Save')),
        appBar: AppBar(
          title: Consumer(
            builder: ((context, ref, child) {
              AsyncValue<List> whatever = ref.watch(noteThatNeedsToBeEdited);

              return whatever.when(
                  data: (name) {
                    return Text('Editing: ' + name.first['name'].toString());
                  },
                  error: (e, stackTrace) => const Text('Error happened !!'),
                  loading: () => const Text('Editing a note...'));
            }),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  noteDelete(index: indexfornote);
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => const MyApp())))
                    ..then(((value) {
                      setState(() {});
                    }));
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.delete))
          ],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: selectorbyId(index: indexfornote),
              builder: (context, snapshot) {
                return Center(
                  child: Consumer(builder: ((context, ref, child) {
                    AsyncValue<List> thisNote =
                        ref.watch(noteThatNeedsToBeEdited);
                    return thisNote.when(
                        data: ((data) {
                          _textEditingController.text = data.first['name'];
                          return Column(
                            children: [
                              TextField(
                                onChanged: (value) {},
                                controller: _textEditingController,
                              ),
                              //Big problems here
                              Text('Select category'),
                              FutureBuilder(
                                  future: listofCategoriestherightway,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        return DropdownButton(
                                          value: data.first['category'],
                                          items: categoryList
                                              .map((item) => DropdownMenuItem(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  )))
                                              .toList(),
                                          onChanged: (item) => setState(() {
                                            selectedCategoryExport =
                                                item.toString();
                                            selectedCategory =
                                                selectedCategoryExport;
                                            print(selectedCategory);
                                          }),
                                        );
                                      } else {
                                        return const Text('Nothing here');
                                      }
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  }),
                              Text('Select importance'),
                              DropdownButton(
                                value: data.first['importance'],
                                items: importance
                                    .map((item) => DropdownMenuItem<int>(
                                        value: item,
                                        child: Text(
                                          item.toString(),
                                          style: TextStyle(fontSize: 18),
                                        )))
                                    .toList(),
                                onChanged: (item) => setState(() {
                                  selectedImportance = item as int;

                                  print(selectedImportance);
                                }),
                              ),
                              Text('Select date and time'),
                              DateTimePicker(
                                type: DateTimePickerType.dateTimeSeparate,
                                dateMask: 'd MMM, yyyy',
                                initialValue: data.first['dates'],
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                icon: Icon(Icons.event),
                                dateLabelText: 'Date',
                                timeLabelText: "Hour",
                                selectableDayPredicate: (date) {
                                  // Disable weekend days to select from the calendar
                                  if (date.weekday == 6 || date.weekday == 7) {
                                    return false;
                                  }

                                  return true;
                                },
                                onChanged: (val) {
                                  selectedDate = val;
                                },
                                validator: (val) {
                                  print(val);
                                  return null;
                                },
                                onSaved: (val) => print(val),
                              ),
                            ],
                          );
                        }),
                        error: (e, stackTrace) => Text('Error happened'),
                        loading: () => Text('Loading...'));
                  })),
                );
              }),
        ));
  }
}
