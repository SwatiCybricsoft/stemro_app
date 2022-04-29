import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'auth/splash_screen.dart';
import 'form/school_visit_form.dart';
import 'form/visit_page.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
       home:SplashScreen(),
    );
  }
}

