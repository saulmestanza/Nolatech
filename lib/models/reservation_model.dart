import 'package:nolatech/models/court_model.dart';
import 'package:nolatech/models/user_model.dart';

class ReservationModel {
  final int? id;
  final int? time;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? instructor;
  final String? comment;
  final CourtModel? courtModel;
  final UserModel? userModel;

  ReservationModel({
    this.time,
    this.startTime,
    this.endTime,
    this.instructor,
    this.comment,
    this.courtModel,
    this.userModel,
    this.id,
  });

  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(
      id: map['id'],
      time: map['time'],
      instructor: map['instructor'],
      comment: map['comment'],
      courtModel: CourtModel(id: map['court_id']),
      userModel: UserModel(id: map['user_id']),
      startTime: DateTime.parse(
        '${map['date']} ${map['start_time']}',
      ), // 1974-03-20 00:00:00.000,
      endTime: DateTime.parse(
        '${map['date']} ${map['end_time']}',
      ), // 1974-03-20 00:00:00.000,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'instructor': instructor,
      'comment': comment,
      'court_id': courtModel?.id,
      'user_id': userModel?.id,
      'date': startTime!.toIso8601String().split('T')[0],
      'start_time': startTime!.toIso8601String().split('T')[1],
      'end_time': endTime!.toIso8601String().split('T')[1],
    };
  }

  ReservationModel copyWith({
    int? id,
    int? time,
    DateTime? startTime,
    DateTime? endTime,
    String? instructor,
    String? comment,
    CourtModel? courtModel,
    UserModel? userModel,
  }) {
    return ReservationModel(
      id: id ?? this.id,
      time: time ?? this.time,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      instructor: instructor ?? this.instructor,
      comment: comment ?? this.comment,
      courtModel: courtModel ?? this.courtModel,
      userModel: userModel ?? this.userModel,
    );
  }
}
