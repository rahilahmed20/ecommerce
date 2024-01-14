import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:macstore/views/screens/authentication_screens/login_screen.dart';
import 'package:macstore/views/screens/home_Screen.dart';
import 'package:macstore/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static const String KEYLOGIN = "login";
  late Widget nextScreen;

  @override
  void initState() {
    super.initState();
    loadNextScreen();
  }

  Future<void> loadNextScreen() async {
    nextScreen = await whereToGo();
    setState(() {}); // Update the state to trigger a rebuild with the new nextScreen
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/app_logo.jpeg'),
        ],
      ),
      splashIconSize: 400,
      duration: 500,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(milliseconds: 1000),
      nextScreen: nextScreen,
    );
  }
}

Future<Widget> whereToGo() async {
  var sharedPref = await SharedPreferences.getInstance();
  var loginValue = sharedPref.getBool(SplashScreenState.KEYLOGIN);

  if (loginValue == null) {
    return LoginScreen();
  }

  return loginValue ? MainScreen() : LoginScreen();
}
