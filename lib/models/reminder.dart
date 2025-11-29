class Reminder {
  final int? id;
  final String title;
  final String link;
  final String time;
  final bool bukaOtomatis;

  Reminder({
    this.id,
    required this.title,
    required this.link,
    required this.time,
    required this.bukaOtomatis,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'link': link,
      'time': time,
      'buka_otomatis': bukaOtomatis ? 1 : 0,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      link: map['link'],
      time: map['time'],
      bukaOtomatis: (map['buka_otomatis'] ?? 0) == 1,
    );
  }
}
