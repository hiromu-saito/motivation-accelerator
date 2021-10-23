import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:motivation_accelerator/model/habit.dart';
import 'package:motivation_accelerator/model/habit_data.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({required this.userMail});

  final String? userMail;

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  late String newHabitName;
  late int frequency = 1;

  CollectionReference habitsRef =
      FirebaseFirestore.instance.collection('habits');

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('What do you want to accelerate your motivation?'),
        SizedBox(
          width: 300,
          child: TextField(
            textAlign: TextAlign.center,
            onChanged: (value) {
              setState(() {
                newHabitName = value;
              });
            },
          ),
        ),
        const SizedBox(
          height: 100,
        ),
        const Text('How many days a week do you commit?'),
        SizedBox(
          width: 300,
          child: DropdownButton<int>(
            isExpanded: true,
            value: frequency,
            alignment: Alignment.centerRight,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 20,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
            onChanged: (int? newValue) {
              setState(() {
                frequency = newValue!;
              });
            },
            items: <int>[1, 2, 3, 4, 5, 6, 7]
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                alignment: Alignment.centerRight,
                child: Text(
                  value.toString(),
                ),
              );
            }).toList(),
          ),
        ),
        Consumer<HabitData>(builder: (context, habitData, child) {
          return TextButton(
            child: const Text(
              'start!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            style: ktButtonStyle.copyWith(
              fixedSize: MaterialStateProperty.all(const Size.fromWidth(100)),
            ),
            onPressed: () async {
              if (newHabitName == '') {
                return;
              }
              EasyLoading.show(status: 'login...');
              FirebaseFirestore.instance.runTransaction((transaction) async {
                QuerySnapshot list = await habitsRef
                    .orderBy('id', descending: true)
                    .limit(1)
                    .get();
                int newId = list.docs.isEmpty ? 1 : list.docs[0]['id'] + 1;
                var newHabit = Habit(
                  id: newId,
                  habitName: newHabitName,
                  userMail: widget.userMail!,
                  startDate: Timestamp.now(),
                  frequency: frequency,
                  commits: {},
                );
                await habitsRef
                    .add(newHabit.toMap())
                    .then((value) => {habitData.addHabit(newHabit)});
              });
              EasyLoading.dismiss();
              Navigator.pop(context);
            },
          );
        }),
      ],
    );
  }
}
