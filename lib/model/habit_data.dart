import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motivation_accelerator/model/habit.dart';

class HabitData extends ChangeNotifier {
  CollectionReference habitsRef =
      FirebaseFirestore.instance.collection('habits');
  List<Habit> _habitList = [];

  Future<void> fetchHabit(String? userMail) async {
    final snapShot = await habitsRef
        .where('userMail', isEqualTo: userMail)
        .where('deleteFlag', isEqualTo: 0)
        .get();
    _habitList = snapShot.docs
        .map((e) => Habit(
            id: e['id'],
            habitName: e['habitName'],
            startDate: e['startDate'],
            userMail: e['userMail']))
        .toList();
    notifyListeners();
  }

  List<Habit> get habits {
    return _habitList;
  }

  int get length {
    return _habitList.length;
  }

  void addHabit(Habit habit) {
    _habitList.add(habit);
    notifyListeners();
  }
}
