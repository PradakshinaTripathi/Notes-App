import 'package:notes_poc/models/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider{
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();
  static Database? _database;

  Future<Database?> get database async{
    if(_database!=null){
      return _database;
    }
    _database = await initDb();
    return _database;
  }

  initDb() async{
    return await openDatabase(join(await getDatabasesPath(),"notes_database.db"),
        onCreate: (db,version)async{
      await db.execute('''
      CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      body TEXT,
      dateTime DATETIME
      )
      ''');
        },version: 1);
  }

  // adding new note to the variable
  addNewNote(NoteModel note)async{
    final db = await database;
    db?.insert("notes", note.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // fetch the database and return all the element inside the notes table

  Future<List<NoteModel>> getNotes() async {
    final db = await database;
    var res = await db?.query("notes");
    if (res?.isEmpty == true) {
      return [];
    } else {
      var resMap = res?.map((noteMap) => NoteModel.fromMap(noteMap)).toList();
      print("Notes in the database:");
      for (var note in resMap!) {
        print("ID: ${note.id}");
        print("Title: ${note.title}");
        print("Body: ${note.body}");
        print("DateTime: ${note.dateTime}");
        print("-----------");
      }
      print(resMap);
      return resMap ?? [];
    }
  }

  Future<void> deleteNote(int? id) async {
    final db = await database;
    await (db as Database).delete("notes", where: 'id = ?', whereArgs: [id]);
  }


  Future<void> updateNoteInDatabase(NoteModel note) async {
    final db = await database;
    await db?.update(
      "notes",
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

}

