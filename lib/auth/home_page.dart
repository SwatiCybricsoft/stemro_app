import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stemro_app/auth/AuthService.dart';
import 'package:stemro_app/auth/welcome_screen.dart';
import 'package:stemro_app/form/Upload_Manager.dart';
import 'package:stemro_app/form/old_visit_form.dart';
import 'package:stemro_app/form/visit_page.dart';
import 'package:stemro_app/view/Lab_picture.dart';
import 'package:stemro_app/view/component_verification.dart';
import '../view/teachers_traing.dart';

bool isAdminStatus = false;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
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

class _MyHomePageState extends State<MyHomePage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAdmin();
  }
  @override
  Widget build(BuildContext context) {
    final _screen =  MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.teal.shade300,
    ));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text(
                  'Logout',
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
        title: Text(
          'User Dashboard',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.tealAccent, Colors.teal]),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: MediaQuery.of(context).size.height/9,
          // color: Colors.teal.shade300,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                 topRight: Radius.circular(20.0),
                  // bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)
              ),
              gradient: LinearGradient(
                  colors: [Colors.teal,Colors.tealAccent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter
              )
          ),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            FaIcon(
              FontAwesomeIcons.dumbbell,
              color: Colors.teal,
            ),
              Text(
                'STEMROBO',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 25),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xfff8f8f8),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width,
                color: Colors.teal.shade300,
                child: Container(
                  margin: EdgeInsets.only(right: 40, top:10, bottom: 20),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/path.png'),
                          fit: BoxFit.contain)),
                ),
              )
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                padding: EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/stemrobo.png",
                    // height: 80.0,
                    // width: 300.0,
                  ),
                ),
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              //   decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.all(Radius.circular(40))),
              // ),
              // SizedBox(
              //   height: 100,
              // ),
              Row(
                 mainAxisAlignment: MainAxisAlignment.center,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder,
                                  size: 50,
                                  color: Colors.black54,
                                ),
                                Text(
                                  "School Visit Form",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_to_photos_rounded,
                                    size: 50,
                                    color: Colors.black54,
                                  ),
                                  Text(
                                    "View Old Form",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18
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
