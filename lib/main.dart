import 'package:flutter/material.dart';
import 'package:jogo_velha/core/constants.dart';
import 'package:jogo_velha/core/theme_app.dart';
import 'package:jogo_velha/pages/game_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: GAME_TITLE,
      theme: themeApp,
      home: GamePage(),
    );
  }
}