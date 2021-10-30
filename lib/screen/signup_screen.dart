import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:motivation_accelerator/constants.dart';
import 'package:motivation_accelerator/utility.dart';

import 'habit_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late String email;
  late String password;
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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
                'Sign Up',
                style: ktButtonTextStyle,
              ),
              style: ktButtonStyle,
              onPressed: () async {
                EasyLoading.show(status: 'signup...');
                try {
                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password)
                      .then((userCredential) async {
                    String? token = await _firebaseMessaging.getToken();
                    await usersRef
                        .add({'token': token, 'uid': userCredential.user!.uid});
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HabitScreen(user: userCredential.user),
                      ),
                    );
                  });
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    showErrorDialog(context, 'パスワードは8文字以上で入力してください。');
                  } else if (e.code == 'email-already-in-use') {
                    showErrorDialog(context, '登録済みのメールアドレスです');
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
