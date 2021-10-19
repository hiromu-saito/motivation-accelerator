import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:motivation_accelerator/screen/welcome_screen.dart';

class GrassScreen extends StatelessWidget {
  GrassScreen({required this.habitId, required this.startTimeStamp});

  final int habitId;
  final Timestamp startTimeStamp;

  @override
  Widget build(BuildContext context) {
    DateTime startDate = startTimeStamp.toDate();
    DateTime today = DateTime.now();
    print('today $today');
    print('habitId ${habitId.toString()}');
    print('startDate ${startDate.toString()}');
    int elapsedDays = today.difference(startDate).inDays;
    int elapsedWeek = (elapsedDays / 7 + 1).toInt();

    var list = [
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
      Icon(
        Icons.stop,
        color: Colors.greenAccent,
      ),
    ];

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
