import 'package:flutter/material.dart';
import 'package:flutter_svg_animations_with_rive_tutorial/splash_screen.dart';

void main() => runApp(AppWidget());

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter SVG Animations With Rive',
      home: SplashScreen(),
    );
  }
}
