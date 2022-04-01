import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//Global variables
var categoryList = [];
var noteList = [];
var doneList = [];
var archiveList = [];
late String categoryColor;
var noteEdit = [];
//Nova baza podataka
Future createdatabase() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, importance INTEGER, category TEXT, dates TEXT, color TEXT)');
    await db.execute(
        'CREATE TABLE Archive (id INTEGER PRIMARY KEY, name TEXT, importance INTEGER, category TEXT, dates TEXT)');
    await db.execute(
        'CREATE TABLE Done (id INTEGER PRIMARY KEY, name TEXT, importance INTEGER, category TEXT, dates TEXT)');
    await db.execute(
        'CREATE TABLE Category (id INTEGER PRIMARY KEY, name TEXT, color TEXT)');
  });
}

//Prikazi taskove
Future<Object> selector() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  List<Map> list =
      await database.rawQuery('SELECT * FROM Test ORDER BY importance');
  noteList = list;
  return noteList;
}

//Sortiraj po datumu
Future<Object> selectorbyDate() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  List<Map> list =
      await database.rawQuery('SELECT * FROM Test ORDER BY dates desc');
  noteList = list;
  return noteList;
}

//Ubaci novi task
Future noteInsertor(
    {required String name,
    required int importance,
    required String category,
    required String date,
    required String color}) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  await database.rawInsert(
      'INSERT INTO Test(name, importance, category, dates, color) VALUES("$name", $importance, "$category", "$date", "$color")');
}

//Pokazi arhivu
Future<Object> archiveSelector() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  List<Map> list =
      await database.rawQuery('SELECT * FROM Archive ORDER BY importance');
  archiveList = list;
  return archiveList;
}

//Pokazi sve zavrsene taskove
Future<Object> doneSelector() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  List<Map> list =
      await database.rawQuery('SELECT * FROM Done ORDER BY importance');
  doneList = list;
  return doneList;
}

//Ubaci u arhivu
Future archiveInsertor(
    {required String name,
    required int importance,
    required String category,
    required String date}) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  await database.rawInsert(
      'INSERT INTO Archive(name, importance, category, dates) VALUES("$name", $importance, "$category", "$date")');
}

//Ubaci u listu zavrsenih
Future doneInsertor(
    {required String name,
    required int importance,
    required String category,
    required String date}) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  await database.rawInsert(
      'INSERT INTO Done(name, importance, category, dates) VALUES("$name", $importance, "$category", "$date")');
}

//Uredi task
//Kako treba sakrivat argumente protiv sql injekcija, ovdje je prava verzija ostale su normala
Future noteEditor(
    {required int index,
    required String name,
    required int importance,
    required String category,
    required String date,
    required String color}) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  await database.rawUpdate('''UPDATE Test 
      SET name = ?, importance = ?,  category = ?, dates = ?, color = ?
      WHERE id = ?
      ''', ["$name", importance, "$category", "$date", "$color", index]);
}

//Izbrisi task
Future noteDelete({
  required int index,
}) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  await database.rawDelete('DELETE FROM Test WHERE id = ?', [index]);
}

//Izbrisi iz liste zavrsenih
Future doneDelete({
  required int index,
}) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  await database.rawDelete('DELETE FROM Done WHERE id = ?', [index]);
}

//Izbrisi iz arhive
Future archiveDelete({
  required int index,
}) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  await database.rawDelete('DELETE FROM Archive WHERE id = ?', [index]);
}

//Ubaci kategoriju
Future categoryInsertor({required String name, required String color}) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  await database
      .rawInsert('INSERT INTO Category(name, color) VALUES("$name", "$color")');
}

//Izbaci sve kategorije
Future<List> categorySelector() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  List<Map> list =
      await database.rawQuery('SELECT name FROM Category ORDER BY id DESC');
  categoryList = list.map((value) => value['name']).toList();
  try {
    selectedCategoryExport = categoryList.first;
  } catch (e) {
    selectedCategoryExport = '';
  }

  return categoryList;
}

late String selectedCategoryExport;

//Boja preko kategorije
Future<String> colorFromCategory({required String category}) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  List<Map> list = await database
      .rawQuery('SELECT color FROM Category WHERE name LIKE "$category"');

  try {
    categoryColor = list.first['color'].toString();
  } catch (e) {
    categoryColor = 'red';
  }

  return categoryColor;
}

//Pokusaj boje kategorije bez ubacivanja u taskove
// Future colorCategory({required String category}) async {
//   var databasesPath = await getDatabasesPath();
//   String path = join(databasesPath, 'bazamoja.db');
//   Database database = await openDatabase(path);
//   List<Map> list = await database
//       .rawQuery('SELECT color FROM Category WHERE name LIKE "${category}"');
//   return list;
// }

//Selektuj po idu
Future<List> selectorbyId({required int index}) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  List<Map> list =
      await database.rawQuery('SELECT * FROM Test WHERE id LIKE $index');
  noteEdit = list;
  print(noteEdit);
  return noteEdit;
}

//Filtirranje kategorije
Future<Object> selectorbyCategory({required String category}) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bazamoja.db');
  Database database = await openDatabase(path);
  List<Map> list = await database.rawQuery(
      'SELECT * FROM Test WHERE category LIKE "$category" ORDER BY dates desc');
  noteList = list;
  print(noteEdit);
  return noteList;
}
