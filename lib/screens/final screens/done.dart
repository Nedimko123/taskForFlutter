import 'package:flutter/material.dart';
import '../../logic/db.dart';

class Done extends StatefulWidget {
  const Done({Key? key}) : super(key: key);

  @override
  State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
  Widget pussintheboots({required int importance}) {
    if (importance == 1) {
      return const Icon(Icons.flag, color: Colors.red);
    } else if (importance == 2) {
      return const Icon(Icons.flag, color: Colors.orange);
    } else {
      return const Icon(Icons.flag, color: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tasks done...'),
          centerTitle: true,
        ),
        body: StreamBuilder<Object>(
            stream: Stream.fromFuture(doneSelector()),
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
                                                          name: doneList[index]
                                                              ['name'],
                                                          importance: doneList[
                                                                  index]
                                                              ['importance'],
                                                          category:
                                                              doneList[index]
                                                                  ['category'],
                                                          date: doneList[index]
                                                              ['dates']);
                                                      Navigator.of(context)
                                                          .pop();
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
                                                          index: doneList[index]
                                                              ['id']);
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  },
                                                  child: const Text(
                                                      'Delete the task!!')),
                                            )
                                          ],
                                        ));
                              },
                              onTap: () {
                                setState(() {});
                              },
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    doneDelete(index: doneList[index]['id']);
                                  });
                                },
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                              ),
                              leading: pussintheboots(
                                  importance: doneList[index]['importance']),
                              title: Text(
                                doneList[index]['name'],
                                style: TextStyle(color: Colors.green),
                              ),
                              subtitle:
                                  Text(doneList[index]['dates'].toString()),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: doneList.length);
            }));
  }
}
