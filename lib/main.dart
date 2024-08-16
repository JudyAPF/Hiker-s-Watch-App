import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flores_hikers_watch_app/screens/home.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const HikersWatch());
}

class HikersWatch extends StatelessWidget {
  const HikersWatch({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(
          primary: Color(0xff273ea5), // Primary color
          secondary: Color(0xffa3c3e7), // Secondary color
        ),
      ),
      home: AnimatedSplashScreen(
        
        splashIconSize: 500,
        duration: 3000,
        splashTransition: SplashTransition.fadeTransition,
        splash: Center(child: Image.asset('assets/images/logo.png')),
     nextScreen: const HomeScreen(),),
      debugShowCheckedModeBanner: false,
    );
  }
}
 