
class Task{
  int id;
  String title;
  DateTime date;
  String priority;
  String note;
  int status; // 0 - incomplete, 1- complete

  Task({this.title, this.date, this.priority, this.status,this.note});
  Task.withId({this.id, this.title, this.date, this.priority, this.status,this.note});

  Map<String, dynamic>toMap(){
    final map = Map<String, dynamic>();
    if(id != null){
      map ['id'] = id;
    }
    map ['title'] = title;
    map ['note'] = note;
    map ['date'] = date.toIso8601String();
    map ['priority'] = priority;
    map ['status'] = status;
    return map;
  }


  factory Task.fromMap(Map<String, dynamic> map){
    return Task.withId(
      id: map['id'],
      note: map['note'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      priority: map['priority'],
      status: map['status']
    );
  }
}