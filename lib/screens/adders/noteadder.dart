import 'package:amygdal/logic/db.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:jiffy/jiffy.dart';

class NoteAdder extends StatefulWidget {
  const NoteAdder({Key? key}) : super(key: key);

  @override
  State<NoteAdder> createState() => _NoteAdderState();
}

class _NoteAdderState extends State<NoteAdder> {
  String selectedDate = Jiffy().format("yyyy-MM-dd HH:mm");

  late Future listofCategoriestherightway;
  String selectedCategory = '';
  final TextEditingController _textEditingController = TextEditingController();
  List<int> importance = [1, 2, 3];
  int selectedImportance = 1;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    listofCategoriestherightway = _getCategories();
    _initCategoryColor();
  }

  _getCategories() async {
    return await categorySelector();
  }

  // var catlist = List<String>.from(categoryList);
  _initCategoryColor() async {
    categoryColor = await colorFromCategory(category: selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add new note'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('Enter task name'),
            ),
            SizedBox(
              width: 250,
              child: TextField(
                onChanged: (value) {},
                controller: _textEditingController,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Input task name'),
              ),
            ),

            //Big problems here
            Text('Select category'),
            FutureBuilder(
                future: listofCategoriestherightway,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return DropdownButton(
                        value: selectedCategoryExport,
                        items: categoryList
                            .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 18),
                                )))
                            .toList(),
                        onChanged: (item) => setState(() {
                          selectedCategoryExport = item.toString();
                          selectedCategory = selectedCategoryExport;
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
              value: selectedImportance,
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
              initialValue: DateTime.now().toString(),
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
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                  onPressed: () async {
                    categoryColor = await colorFromCategory(
                        category: selectedCategoryExport);
                    setState(() {
                      noteInsertor(
                          name: _textEditingController.text.toString(),
                          importance: selectedImportance,
                          category: selectedCategoryExport,
                          date: selectedDate,
                          color: categoryColor);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Added new task...'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 1),
                    ));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add new task')),
            )
          ],
        ),
      ),
    );
  }
}
