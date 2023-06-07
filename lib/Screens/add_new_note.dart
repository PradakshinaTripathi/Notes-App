import 'package:flutter/material.dart';
import 'package:notes_poc/Screens/home_screen.dart';
import 'package:notes_poc/db/database_provider.dart';
import 'package:notes_poc/models/note_model.dart';

class AddNewNote extends StatefulWidget {
  final NoteModel? note;
  const AddNewNote({Key? key,this.note}) : super(key: key);

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {

  late String title;
  late String body;
  late DateTime date;

  late bool isEditing;
  late int? noteId;

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    isEditing = widget.note != null;
    noteId = widget.note?.id;
    if (isEditing) {
      titleController.text = widget.note!.title;
      bodyController.text = widget.note!.body;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add your Note"),),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
        child: Column(
          children:  [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title"
              ),
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
            ),
            const SizedBox(),
            Expanded(
              child: TextField(
                controller: bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type"
                ),

              ),
            )

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        isEditing?updateNote():
        // NoteModel note = NoteModel( title: title, body: body, dateTime: date);
        addNote();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      }, label: const Text("Save"), icon: const Icon(Icons.save_alt)),
    );
  }

  Future<void>updateNote() async{
    setState(() {
      title = titleController.text;
      body = bodyController.text;
      date = DateTime.now();
    });
    NoteModel note = NoteModel(
      title: title,
      body: body,
      dateTime: date,
      id: noteId,
    );
    await DatabaseProvider.db.updateNoteInDatabase(note);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
    );
  }



  void addNote() {
    setState(() {
      title = titleController.text;
      body = bodyController.text;
      date = DateTime.now();
    });
    NoteModel note = NoteModel(title: title, body: body, dateTime: date);
    DatabaseProvider.db.addNewNote(note);
    print("Note Added Successfully");
  }


}
