import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'auth/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

bool isAdminStatus = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await checkAdmin();
  runApp(const MyApp());
}

checkAdmin() {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  DatabaseReference reference = FirebaseDatabase.instance.ref("/Users/$uid/");
  reference.onValue.listen((DatabaseEvent event) {
    if (event.snapshot.child("accountType").exists) {
      final data = event.snapshot.child("accountType").value;
      if (data.toString() == 'Admin') {
        isAdminStatus = true;
      } else {
        isAdminStatus = false;
      }
    }
  });
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
      home: SplashScreen(),
    );
  }
}
