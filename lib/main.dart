// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:check_up/check_list.dart';
import 'package:check_up/themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Check Up',
        theme: Themes.lightTheme,
        darkTheme: Themes.darkTheme,
        home: CheckList());
  }
}
