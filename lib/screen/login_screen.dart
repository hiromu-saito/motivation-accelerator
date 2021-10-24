import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:motivation_accelerator/constants.dart';
import 'package:motivation_accelerator/utility.dart';

import 'habit_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Motivation Accelerator',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'example@email.com',
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            SizedBox(
              width: 300,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  icon: Icon(Icons.password),
                  hintText: 'password',
                ),
                onChanged: (value) {
                  password = value;
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextButton(
              child: const Text(
                'Log In',
                style: ktButtonTextStyle,
              ),
              style: ktButtonStyle,
              onPressed: () async {
                EasyLoading.show(status: 'login...');
                try {
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  )
                      .then((userCredential) async {
                    String? token = await _firebaseMessaging.getToken();
                    await FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      await usersRef
                          .where('uid', isEqualTo: userCredential.user!.uid)
                          .get()
                          .then((snapshot) {
                        String docId = snapshot.docs[0].id;
                        usersRef.doc(docId).update({'token': token});
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HabitScreen(user: userCredential.user),
                          ),
                        );
                      });
                    });
                  });
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    showErrorDialog(context, '未登録のメールアドレスです。');
                  } else if (e.code == 'wrong-password') {
                    showErrorDialog(context, 'パスワードが間違っています。');
                  }
                } catch (e) {
                  showErrorDialog(context, 'エラーが発生しました。');
                } finally {
                  EasyLoading.dismiss();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
