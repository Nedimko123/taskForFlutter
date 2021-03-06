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
  bool changeInitSelectedCategory = true;
  List<int> importance = [1, 2, 3];
  bool changeInitImportance = true;
  int selectedImportance = 1;
  late int initialImportance;
  late String initialCategory;
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
                  importance: changeInitImportance
                      ? initialImportance
                      : selectedImportance,
                  category: changeInitSelectedCategory
                      ? initialCategory
                      : selectedCategoryExport,
                  date: selectedDate,
                  color: categoryColor);
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Saved'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ));
            Navigator.of(context).pop();
          },
          child: const Text('Save')),
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
      body: SingleChildScrollView(child: Center(
        child: Consumer(builder: ((context, ref, child) {
          AsyncValue<List> thisNote = ref.watch(noteThatNeedsToBeEdited);

          return thisNote.when(
              data: ((data) {
                _textEditingController.text = data.first['name'];
                initialCategory = data.first['category'];
                initialImportance = data.first['importance'];

                selectedDate = data.first['dates'];
                return Column(
                  children: [
                    TextField(
                      onChanged: (value) {},
                      controller: _textEditingController,
                    ),
                    //Big problems here
                    const Text('Select category'),
                    DropdownButton(
                      value: changeInitSelectedCategory
                          ? initialCategory
                          : selectedCategoryExport,
                      items: categoryList
                          .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 18),
                              )))
                          .toList(),
                      onChanged: (item) => setState(() {
                        selectedCategoryExport = item.toString();
                        selectedCategory = selectedCategoryExport;
                        changeInitSelectedCategory = false;
                        print(selectedCategory);
                      }),
                    ),

                    const Text('Select importance'),
                    DropdownButton(
                      value: changeInitImportance
                          ? initialImportance
                          : selectedImportance,
                      items: importance
                          .map((item) => DropdownMenuItem<int>(
                              value: item,
                              child: Text(
                                item.toString(),
                                style: const TextStyle(fontSize: 18),
                              )))
                          .toList(),
                      onChanged: (item) {
                        setState(() {
                          selectedImportance = item as int;
                          changeInitImportance = false;
                          print(selectedImportance);
                        });
                      },
                    ),
                    const Text('Select date and time'),
                    DateTimePicker(
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'd MMM, yyyy',
                      initialValue: data.first['dates'],
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      icon: const Icon(Icons.event),
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
              error: (e, stackTrace) => const Text('Error happened'),
              loading: () => const Text('Loading...'));
        })),
      )),
    );
  }
}
