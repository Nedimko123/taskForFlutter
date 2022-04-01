class Note {
  final int? id;
  final int number;
  final String title;
  final String desc;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.number,
    required this.title,
    required this.desc,
    required this.createdTime,
  });
  Note copy({
    int? id,
    int? number,
    String? title,
    String? desc,
    DateTime? createdTime,
  }) =>
      Note(
          number: this.number,
          title: this.title,
          desc: this.desc,
          createdTime: this.createdTime);
  Map<String, Object?> toJson() => {
        NoteFiels.id: id,
        NoteFiels.number: number,
        NoteFiels.title: title,
        NoteFiels.desc: desc,
        NoteFiels.time: createdTime.toIso8601String(),
      };

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFiels.id] as int?,
        number: json[NoteFiels.number] as int,
        title: json[NoteFiels.title] as String,
        desc: json[NoteFiels.desc] as String,
        createdTime: DateTime.parse(json[NoteFiels.time] as String),
      );
}

final String tableNotes = 'notes';

class NoteFiels {
  static final String id = '_id';
  static final String number = 'number';
  static final String title = 'title';
  static final String desc = 'desc';
  static final String time = 'time';

  static final List<String> values = [id, number, title, desc, time];
}
