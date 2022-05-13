import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stemro_app/auth/login_screen.dart';
import 'package:stemro_app/form/visit_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:stemro_app/view/Lab_picture.dart';
import 'package:stemro_app/view/component_verification.dart';
import 'package:stemro_app/view/teachers_traing.dart';
import '../auth/AuthService.dart';
import 'dart:developer';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {

  int i = 0;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.teal,
          centerTitle: true,
          actions: [
            PopupMenuButton<int>(
              onSelected: (item) =>onSelected(context,item),
              itemBuilder: (context) =>[
                PopupMenuItem<int>(
                  value: 0,
                  child: Text('Lab Picture',style: TextStyle(
                    color: Colors.teal,fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text('Component Verification Docs',style: TextStyle(
                    color: Colors.teal,fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text("Teacher's Training Report",style: TextStyle(
                    color: Colors.teal,fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: Text("Logout",style: TextStyle(
                    color: Colors.teal,fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),),
                ),

              ],
            ),
          ],
          title: Text(
            'User Dashboard',
            maxLines: 1,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body:
        GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if(isLogin()){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>FormPage()));
                }else{
                  var snackBar = new SnackBar(content: Text("Login required !"));
                  scaffoldKey.currentState?.showSnackBar(snackBar);
                }
              },
              child: Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(width: 3.0, color: Colors.black26),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    )),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder,
                      size: 40,
                      color: Colors.black54,
                    ),
                    Text(
                      "School Visit Form",
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if(isLogin()){
                  loadSchoolVisits();
                }else{
                  var snackBar = new SnackBar(content: Text("Login required !"));
                  scaffoldKey.currentState?.showSnackBar(snackBar);
                }
              },
              child: Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(width: 3.0, color: Colors.black26),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    )),
                child: Column(
                  children: [
                    Icon(
                      Icons.add_to_photos_rounded,
                      size: 40,
                      color: Colors.black54,
                    ),
                    Text(
                      "View Old Form",
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(width: 3.0, color: Colors.black26),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 40,
                    color: Colors.black54,
                  ),
                  Text(
                    "Album 3",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(width: 3.0, color: Colors.black26),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 40,
                    color: Colors.black54,
                  ),
                  Text(
                    "Album 4",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(width: 3.0, color: Colors.black26),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 40,
                    color: Colors.black54,
                  ),
                  Text(
                    "Album 5",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(width: 3.0, color: Colors.black26),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 40,
                    color: Colors.black54,
                  ),
                  Text(
                    "Album 6",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(width: 3.0, color: Colors.black26),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 40,
                    color: Colors.black54,
                  ),
                  Text(
                    "Album 7",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(width: 3.0, color: Colors.black26),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 40,
                    color: Colors.black54,
                  ),
                  Text(
                    "Album 8",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(width: 3.0, color: Colors.black26),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 40,
                    color: Colors.black54,
                  ),
                  Text(
                    "Album 9",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              // color: Colors.teal[300],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 20,
            color: Colors.red,
          ),
          backgroundColor: Colors.teal,
          onPressed: () {
            setState(() {
              i++;
            });
          },
        ));
  }

  var authHandler = AuthService();

  void onSelected(BuildContext context ,int item){
    switch (item){
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>LabPicture()));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>ComponentVerify()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>TeachersTraning()));
        break;
      case 3:
        _signOut();
        break;
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>LoginPage()), (route) => false);
  }

  bool isLogin() {
    var authService = AuthService();
    if (authService.getUser() != null) {
      return true;
    }else{
      return false;
    }
  }

  void loadSchoolVisits(){
    var uid = AuthService().getUser()!.uid;//Show only items who have the same uid
    DatabaseReference reference = FirebaseDatabase.instance.ref("School Visits");
    reference.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value;
        print(data);
      } else {
        print('No data available.');
      }
    });
  }
}
