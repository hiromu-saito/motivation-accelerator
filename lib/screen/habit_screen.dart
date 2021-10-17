import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:motivation_accelerator/screen/add_habit_screen.dart';
import 'package:motivation_accelerator/screen/welcome_screen.dart';

class HabitScreen extends StatefulWidget {
  const HabitScreen({Key? key, required this.user}) : super(key: key);

  final User? user;

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  CollectionReference habits = FirebaseFirestore.instance.collection('habits');

  List<DocumentSnapshot> documentList = [];

  @override
  void initState() {
    super.initState();
    getHabits();
  }

  void getHabits() async {
    EasyLoading.show(status: 'login...');
    String? mail = widget.user!.email;
    final snapShot = await habits
        .where('userMail', isEqualTo: mail)
        .where('deleteFlag', isEqualTo: 0)
        .get();
    setState(() {
      documentList = snapShot.docs;
    });
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddHabitScreen(userMail: widget.user!.email),
          );
        },
      ),
      body: ListView.separated(
        itemCount: documentList.length,
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 0.8,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(documentList[index]['habitName']),
            onTap: () {
              //TODO 次画面遷移
              print('次画面遷移');
            },
          );
        },
      ),
    );
  }
}
