class NoteModel{
  int? id;
  String title;
  String body;
  DateTime dateTime;


  NoteModel({
    required this.title,
    required this.body,
    required this.dateTime,
    this.id
});

  factory NoteModel.fromMap(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String,dynamic> toMap(){
    return({
      "id":id,
      "title":title,
      "body":body,
      "dateTime":dateTime.toString()
    });


  }


}