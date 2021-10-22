import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    _habitList = snapShot.docs.map((e) {
      return Habit(
        id: e['id'],
        habitName: e['habitName'],
        startDate: e['startDate'],
        userMail: e['userMail'],
        commits: e['commits'],
      );
    }).toList();

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

  void removeHabit(int index) {
    _habitList.removeAt(index);
    notifyListeners();
  }

  Habit getById(int id) {
    final index = _habitList.indexWhere((element) => element.id == id);
    return _habitList[index];
  }

  commit(int id, DateTime dateTime) async {
    final habit = getById(id);
    Map<String, dynamic> processedCommits = {...habit.commits};

    String day = DateFormat('yyyy/MM/dd').format(dateTime);
    if (processedCommits.containsKey(day)) {
      processedCommits[day]++;
    } else {
      processedCommits[day] = 1;
    }

    FirebaseFirestore.instance.runTransaction((transaction) async {
      QuerySnapshot snapshot = await habitsRef.where('id', isEqualTo: id).get();
      String docId = snapshot.docs[0].id;
      await habitsRef.doc(docId).update({'commits': processedCommits});
    }).then((value) {
      habit.commits = processedCommits;
    });

    notifyListeners();
  }
}
