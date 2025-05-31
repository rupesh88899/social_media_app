import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/post_controller.dart';
import 'package:social_media/screens/home_screen.dart';

void main() {
  Get.put(PostController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 189, 146, 238),
          foregroundColor: Colors.white, // Text color in AppBar
        ),
      ),
      home: HomeScreen(),
    );
  }
}
