import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:motivation_accelerator/model/habit.dart';
import 'package:motivation_accelerator/model/habit_data.dart';
import 'package:motivation_accelerator/screen/welcome_screen.dart';
import 'package:provider/provider.dart';

class GrassScreen extends StatelessWidget {
  GrassScreen({required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final habitData = Provider.of<HabitData>(context);
    Habit habit = habitData.getById(id);

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    DateTime s = habit.startDate.toDate();
    DateTime startDate = DateTime(s.year, s.month, s.day);

    int elapsedDays = today.difference(startDate).inDays + 1;
    LinkedHashMap<String, int> commits = LinkedHashMap();

    for (int i = 0; i < elapsedDays; i++) {
      DateTime d = startDate.add(Duration(days: i));
      String day = DateFormat('yyyy/MM/dd').format(d);
      commits[day] = habit.commits.containsKey(day) ? habit.commits[day] : 0;
    }

    List<Widget> list = commits.entries
        .map((e) => Tooltip(
              message: '${e.value} commit on ${e.key}',
              child: Icon(
                e.value == 0 ? Icons.crop_square_sharp : Icons.stop,
                color: e.value == 0 ? Colors.white38 : Colors.greenAccent,
              ),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Motivation Accelerator',
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                side: const BorderSide(
                  color: Color(0x5FFFFFFF),
                ),
              ),
              child: const Text(
                'Log out',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                EasyLoading.show(status: 'Log out...');
                await FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                );
                EasyLoading.dismiss();
              },
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                habit.habitName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            Text('${habit.frequency} days a week'),
            const SizedBox(
              height: 75.0,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              height: 200,
              child: GridView.count(
                scrollDirection: Axis.horizontal,
                crossAxisCount: 7,
                children: list,
              ),
            ),
            const SizedBox(
              height: 100.0,
            ),
            TextButton(
              child: const Text(
                'commit!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              style: TextButton.styleFrom(
                fixedSize: const Size.fromWidth(100.0),
                backgroundColor: Colors.grey,
                side: const BorderSide(
                  color: Color(0x5FFFFFFF),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () async {
                EasyLoading.show(status: 'commit...');
                await habitData.commit(habit.id, today);
                EasyLoading.dismiss();
              },
            ),
          ],
        ),
      ),
    );
  }
}
