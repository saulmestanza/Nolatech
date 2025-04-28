class CourtModel {
  final int id;
  final String? title;
  final String? type;
  final String? imageUrl;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool? isAvailable;
  final bool? isFavorite;
  final String? address;
  final int? price;

  CourtModel({
    required this.id,
    this.title,
    this.type,
    this.imageUrl,
    this.startTime,
    this.endTime,
    this.isAvailable,
    this.isFavorite,
    this.address,
    this.price,
  });

  factory CourtModel.fromMap(Map<String, dynamic> map) {
    return CourtModel(
      id: map['id'],
      title: map['title'],
      address: map['address'],
      price: map['price'] ?? 0,
      type: map['type'],
      imageUrl: map['imageUrl'],
      isFavorite: map['is_favorite'] == 1 ? true : false,
      isAvailable: map['is_available'] == 1 ? true : false,
      startTime: DateTime.parse(
        '${map['date']} ${map['time_start']}',
      ), // 1974-03-20 00:00:00.000,
      endTime: DateTime.parse(
        '${map['date']} ${map['time_end']}',
      ), // 1974-03-20 00:00:00.000,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'imageUrl': imageUrl,
      'address': address,
      'price': price,
      'is_favorite': isFavorite! ? 1 : 0,
      'is_available': isAvailable! ? 1 : 0,
      'date': startTime!.toIso8601String().split('T')[0],
      'time_start': startTime!.toIso8601String().split('T')[1],
      'time_end': endTime!.toIso8601String().split('T')[1],
    };
  }

  CourtModel copyWith({
    int? id,
    String? title,
    String? type,
    String? imageUrl,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAvailable,
    String? address,
    int? price,
    bool? isFavorite,
  }) {
    return CourtModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      isFavorite: isFavorite ?? this.isFavorite,
      imageUrl: imageUrl ?? this.imageUrl,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      address: address ?? this.address,
      price: price ?? this.price,
    );
  }
}
