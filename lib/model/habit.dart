import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  Habit(
      {required this.id,
      required this.habitName,
      required this.userMail,
      required this.startDate,
      this.deleteFlag = 0,
      required this.commits});

  late int id;
  late String habitName;
  late String userMail;
  late int deleteFlag;
  late Timestamp startDate;
  late Map<String, dynamic> commits;

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

class Commit {
  Commit({required this.date, required this.commitCount});

  final DateTime date;
  final int commitCount;
}
