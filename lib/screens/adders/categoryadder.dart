import 'package:amygdal/logic/db.dart';
import 'package:flutter/material.dart';

class CategoryAdder extends StatefulWidget {
  const CategoryAdder({Key? key}) : super(key: key);

  @override
  State<CategoryAdder> createState() => _CategoryAdderState();
}

class _CategoryAdderState extends State<CategoryAdder> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> colors = ['red', 'yellow', 'green', 'black', 'blue'];
  String selectedColor = 'red';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add new category'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: 250,
                child: TextField(
                  onChanged: (value) {},
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Input category name'),
                ),
              ),
              DropdownButton<String>(
                value: selectedColor,
                items: colors
                    .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(fontSize: 23),
                        )))
                    .toList(),
                onChanged: (item) => setState(() {
                  selectedColor = item.toString();
                }),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      categoryInsertor(
                          name: _textEditingController.text,
                          color: selectedColor);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Added new category'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 1),
                    ));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add!'))
            ],
          ),
        ),
      ),
    );
  }
}
