import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:macstore/controllers/auth_controller.dart';
import 'package:macstore/controllers/banners_controller.dart';
import 'package:macstore/controllers/category_controller.dart';
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
          ),
        ).then((value) {
          Get.put(AuthController());
        })
      : await Firebase.initializeApp();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize controllers here if needed
  }

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
