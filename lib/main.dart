
import 'package:flutter/material.dart';
import 'package:stemro_app/auth/login_screen.dart';
import 'auth/home_page.dart';
import 'auth/register_screen.dart';
import 'auth/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'form/visit_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'stemro_app',
      theme: ThemeData(
        primarySwatch: Colors.teal,
         visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // initialRoute: 'SplashScreen',
      // routes: {
      //   'SplashScreen': (context) => SplashScreen(),
      //   'SignIn': (context) => LoginPage(),
      //   'SignUp': (context) => RegistrationPage(),
      //   'Home': (context) => MyHomePage(),
      //   'Form': (context) => FormPage(),
      // },
       home: SplashScreen(),
    );
  }
}
