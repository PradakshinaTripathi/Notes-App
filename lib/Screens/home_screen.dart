import 'package:flutter/material.dart';
import 'package:notes_poc/Screens/add_new_note.dart';
import 'package:notes_poc/db/database_provider.dart';
import 'package:notes_poc/models/note_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<NoteModel> notes = [];

  @override
  void initState() {
  getNotes();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes")),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewNote(),)).then((value){
          if(value!=null && value){
            getNotes();
          }
        });
      },),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context,index){
          final note = notes[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 200,
              child: Card(
                elevation: 2.0,
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note.title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(note.body),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20,bottom: 20),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:  [
                            GestureDetector(
                                onTap: (){
                                  editNote(note);
                                  print('edited');
                                },
                                child: Icon(Icons.edit)),
                            const SizedBox(width: 5),
                            GestureDetector(
                                onTap: (){
                                  deleteNote(note.id);
                                  print("deleted");
                                },
                                child: Icon(Icons.delete)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> getNotes() async {
    final fetchedNotes = await DatabaseProvider.db.getNotes();

    setState(() {
      notes = fetchedNotes;
    });
  }

  void deleteNote(int? noteId)async{
    await DatabaseProvider.db.deleteNote(noteId);
    getNotes();
  }

  void editNote(NoteModel note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNewNote(note: note)),
    ).then((value) {
      if (value != null && value) {
        getNotes();
      }
    });
  }




}
