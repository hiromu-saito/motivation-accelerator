import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  Habit({
    required this.id,
    required this.habitName,
    required this.userMail,
    required this.startDate,
    required this.frequency,
    required this.commits,
    required this.uid,
    this.deleteFlag = 0,
  });

  late int id;
  late String habitName;
  late String userMail;
  late Timestamp startDate;
  late int frequency;
  late String uid;
  late Map<String, dynamic> commits;
  late int deleteFlag;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitName': habitName,
      'userMail': userMail,
      'startDate': startDate,
      'frequency': frequency,
      'deleteFlag': deleteFlag,
      'uid': uid,
      'commits': commits,
      'uid': uid,
    };
  }
}

class Commit {
  Commit({required this.date, required this.commitCount});

  final DateTime date;
  final int commitCount;
}
