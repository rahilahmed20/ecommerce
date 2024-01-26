import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:macstore/controllers/auth_controller.dart';
import 'package:macstore/controllers/banners_controller.dart';
import 'package:macstore/controllers/category_controller.dart';
// import 'package:macstore/views/screens/authentication_screens/login_screen.dart';
import 'package:macstore/views/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
          apiKey: "AIzaSyCH6udt3Uej6avks-Qt5lIBj5tZSBmDa88",
          appId: '1:680431886179:android:77d88f72b0b9315303bd56',
          messagingSenderId: '680431886179',
          projectId: 'store-ba3d8',
          storageBucket: "gs://store-ba3d8.appspot.com",
        )).then((value) {
          Get.put(AuthController());
        //    Stripe.publishableKey =
        // "pk_test_51Nv0TYLcpVDSklU4eoI285cQsT6Lr0w0YuHR5Aaj2Tx8hhLtkBJS6adO2yC0kcAesDO9jfN0PK4sfcs6oelLXowX006uEcO1Dw";
        })
      : await Firebase.initializeApp();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      initialBinding: BindingsBuilder(() {
        Get.put<CategoryController>(
          CategoryController(),
        );

        Get.put<BannerController>(
          BannerController(),
        );
      }),
    );
  }
}
