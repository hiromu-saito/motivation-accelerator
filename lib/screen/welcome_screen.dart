import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:motivation_accelerator/screen/signup_screen.dart';

import '../constants.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DefaultTextStyle(
              style: const TextStyle(fontSize: 20.0),
              child: AnimatedTextKit(
                totalRepeatCount: 1,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'motivation accelerator',
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextButton(
              style: ktButtonStyle,
              child: const Text(
                'Log In',
                style: ktButtonTextStyle,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextButton(
              style: ktButtonStyle,
              child: const Text(
                'Sign Up',
                style: ktButtonTextStyle,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
