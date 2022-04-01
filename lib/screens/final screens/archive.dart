import 'package:flutter/material.dart';
import '../../logic/db.dart';

class Archive extends StatefulWidget {
  const Archive({Key? key}) : super(key: key);

  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
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
          title: Text('Archive of tasks'),
          centerTitle: true,
        ),
        body: StreamBuilder<Object>(
            stream: Stream.fromFuture(archiveSelector()),
            builder: (context, snapshot) {
              return ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                setState(() {});
                              },
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    archiveDelete(
                                        index: archiveList[index]['id']);
                                  });
                                },
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                              ),
                              leading: pussintheboots(
                                  importance: archiveList[index]['importance']),
                              title: Text(
                                archiveList[index]['name'],
                              ),
                              subtitle:
                                  Text(archiveList[index]['dates'].toString()),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: archiveList.length);
            }));
  }
}
