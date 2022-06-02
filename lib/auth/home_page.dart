import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stemro_app/auth/AuthService.dart';
import 'package:stemro_app/auth/welcome_screen.dart';
import 'package:stemro_app/form/Upload_Manager.dart';
import 'package:stemro_app/form/old_visit_form.dart';
import 'package:stemro_app/form/visit_page.dart';
import 'package:stemro_app/view/Lab_picture.dart';
import 'package:stemro_app/view/component_verification.dart';
import '../view/teachers_traing.dart';
import 'login_screen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text(
                  'Lab Picture',
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text(
                  'Component Verification Docs',
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text(
                  "Teacher's Training Report",
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Text(
                  "Uploaded Documents",
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              PopupMenuItem<int>(
                value: 4,
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/stemrobo.png',
            //   fit: BoxFit.contain,
            //   height: 32,
            // ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'User Dashboard',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.teal, Colors.tealAccent]),
          ),
        ),
      ),
      backgroundColor: Color(0xfff8f8f8),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.40,
                width: MediaQuery.of(context).size.width,
                color: Colors.teal.shade300,
                child: Container(
                  margin: EdgeInsets.only(right: 40, top: 20, bottom: 20),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/path.png'),
                          fit: BoxFit.contain)),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  "assets/stemrobo.png",
                  height: 80.0,
                  width: 300.0,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40))),
              ),
              SizedBox(
                height: 80,
              ),
              Row(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      controller: new ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      // scrollDirection: Axis.vertical,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (isLogin()) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FormPage()));
                            } else {
                              var snackBar = new SnackBar(
                                  content: Text("Login required !"));
                              scaffoldKey.currentState?.showSnackBar(snackBar);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(30.0),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 3.0, color: Colors.black26),
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
                            if (isLogin()) {
                              // loadSchoolVisits();
                            } else {
                              var snackBar = new SnackBar(
                                  content: Text("Login required !"));
                              scaffoldKey.currentState?.showSnackBar(snackBar);
                            }
                          },
                          child: GestureDetector(
                            onTap: () {
                              if (isLogin()) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => OldVisits()));
                              } else {
                                var snackBar = new SnackBar(
                                    content: Text("Login required !"));
                                scaffoldKey.currentState
                                    ?.showSnackBar(snackBar);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(30.0),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 3.0, color: Colors.black26),
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.dumbbell,
                          color: Colors.teal,
                        ),
                        Text(
                          'STEMROBO',
                          style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  var authHandler = AuthService();

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LabPicture()));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ComponentVerify()));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TeachersTraining()));
        break;
      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UploadManager()));
        break;
      case 4:
        _signOut();
        break;
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
        (route) => false);
  }

  bool isLogin() {
    var authService = AuthService();
    if (authService.getUser() != null) {
      return true;
    } else {
      return false;
    }
  }
}
