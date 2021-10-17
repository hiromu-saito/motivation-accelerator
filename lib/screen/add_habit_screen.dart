import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({required this.userMail});

  final String? userMail;

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  late String newHabit;
  CollectionReference habits = FirebaseFirestore.instance.collection('habits');

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
                newHabit = value;
              });
            },
          ),
        ),
        TextButton(
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
            print(newHabit);
            if (newHabit == '') {
              return;
            }
            var list =
                await habits.orderBy('id', descending: true).limit(1).get();
            int newId = list.docs[0]['id'] + 1;
            await habits.add({
              'id': newId,
              'habitName': newHabit,
              'userMail': widget.userMail,
              'deleteFlag': 0,
              'startDate': Timestamp.now(),
            });
            Navigator.push(context, MaterialPageRoute(builder: builder));
          },
        )
      ],
    );
  }
}
