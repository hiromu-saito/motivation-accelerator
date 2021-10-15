import 'package:flutter/material.dart';

final ktButtonStyle = TextButton.styleFrom(
  fixedSize: const Size.fromWidth(200),
  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
  side: const BorderSide(
    color: Color(0x5FFFFFFF),
  ),
);

const ktButtonTextStyle = TextStyle(
  letterSpacing: 5.0,
  color: Colors.white,
  fontSize: 20.0,
  fontWeight: FontWeight.w300,
);
