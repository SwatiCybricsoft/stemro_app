import 'package:flutter/material.dart';
import 'package:stemro_app/auth/login_screen.dart';
import 'package:stemro_app/form/visit_page.dart';

import 'package:firebase_database/firebase_database.dart';
import '../auth/AuthService.dart';
import 'dart:developer';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.teal,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.white,
              )),
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => FormPage()));
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

  void userDetails() {
    if (AuthService().getUser() != null) {
      var uid = AuthService().getUser()!.uid;
      FirebaseDatabase.instance
          .reference()
          .child(uid)
          .once()
          .then((snapshot) {
        log('Server response: ${snapshot}');
      });
    }
  }
}
