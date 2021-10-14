import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:motivation_accelerator/constants.dart';
import 'package:motivation_accelerator/utility.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  FirebaseAuth auth = FirebaseAuth.instance;

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
                  UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
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
