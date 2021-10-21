import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:motivation_accelerator/model/habit.dart';
import 'package:motivation_accelerator/screen/welcome_screen.dart';

class GrassScreen extends StatelessWidget {
  GrassScreen({required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    DateTime s = habit.startDate.toDate();
    DateTime startDate = DateTime(s.year, s.month, s.day);

    int elapsedDays = today.difference(startDate).inDays + 1;
    LinkedHashMap<String, int> commits = LinkedHashMap();

    for (int i = 0; i < elapsedDays; i++) {
      DateTime d = startDate.add(Duration(days: i));
      String day = DateFormat('yyyy/MM/dd').format(d);
      if (habit.commits.containsKey(day)) {
        commits[day] = habit.commits[day];
      } else {
        commits[day] = 0;
      }
      print('commits:$commits');
    }

    print("--------------------------");
    commits.entries.forEach((element) {
      print('day:${element.key}');
      print('day:${element.value}');
    });

    List<Widget> list = commits.entries
        .map((e) => Icon(
              Icons.stop,
              color: e.value == 0 ? Colors.white : Colors.greenAccent,
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
                EasyLoading.show(status: 'sign out...');
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextButton(
            child: Text('commit!'),
            onPressed: () {},
          ),
          Container(
              padding: EdgeInsets.all(20),
              height: 200,
              child: GridView.count(
                scrollDirection: Axis.horizontal,
                crossAxisCount: 7,
                children: list,
              )),
        ],
      ),
    );
  }
}
