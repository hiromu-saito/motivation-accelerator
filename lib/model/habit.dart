import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  Habit(
      {required this.id,
      required this.habitName,
      required this.userMail,
      required this.startDate,
      this.deleteFlag = 0});

  late int id;
  late String habitName;
  late String userMail;
  late int deleteFlag;
  late Timestamp startDate;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitName': habitName,
      'userMail': userMail,
      'deleteFlag': deleteFlag,
      'startDate': startDate,
    };
  }
}
