class CourtModel {
  final int id;
  final String title;
  final String type;
  final String imageUrl;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;

  CourtModel({
    required this.id,
    required this.title,
    required this.type,
    required this.imageUrl,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  factory CourtModel.fromMap(Map<String, dynamic> map) {
    return CourtModel(
      id: map['id'],
      title: map['title'],
      type: map['type'],
      imageUrl: map['imageUrl'],
      isAvailable: map['is_available'] == 1 ? true : false,
      startTime: DateTime.parse(
        '${map['date']} ${map['time_start']}',
      ), // 1974-03-20 00:00:00.000,
      endTime: DateTime.parse(
        '${map['date']} ${map['time_end']}',
      ), // 1974-03-20 00:00:00.000,
    );
  }
}
