import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:myproject/screens/note_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple
      ),
      home:AnimatedSplashScreen(
        splash:"assets/notekeeper.png",
        duration: 3000,
        nextScreen: NoteList(),
        splashIconSize: 200,
        splashTransition: SplashTransition.slideTransition,
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}