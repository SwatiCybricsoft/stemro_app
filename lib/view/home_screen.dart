import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stemro_app/auth/login_screen.dart';
import 'package:stemro_app/form/Upload_Manager.dart';
import 'package:stemro_app/form/visit_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:stemro_app/view/Lab_picture.dart';
import 'package:stemro_app/view/component_verification.dart';
import 'package:stemro_app/view/teachers_traing.dart';
import 'package:stemro_app/form/old_visit_form.dart';
import '../auth/AuthService.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

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
              onSelected: (item) =>onSelected(context,item),
              itemBuilder: (context) =>[
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text('Lab Picture',style: TextStyle(
                    color: Colors.teal,fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text('Component Verification Docs',style: TextStyle(
                    color: Colors.teal,fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Teacher's Training Report",style: TextStyle(
                    color: Colors.teal,fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),),
                ),
                const PopupMenuItem<int>(
                  value: 3,
                  child: Text("Logout",style: TextStyle(
                    color: Colors.teal,fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),),
                ),

              ],
            ),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/stemrobo.png',
                fit: BoxFit.contain,
                height: 32,
              ),
              Container(
                  padding: const EdgeInsets.all(10.0), child: const Text('User Dashboard',style: TextStyle(
                fontSize:15,
              ),),
              )
            ],
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

        body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if(isLogin()){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const FormPage()));
                }else{
                  var snackBar = const SnackBar(content: Text("Login required !"));
                  scaffoldKey.currentState?.showSnackBar(snackBar);
                }
              },
              child: Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(width: 3.0, color: Colors.black26),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    )),
                child: Column(
                  children: const [
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
                  var snackBar = const SnackBar(content: Text("Login required !"));
                  scaffoldKey.currentState?.showSnackBar(snackBar);
                }
              },
              child: GestureDetector(
                onTap: (){
                  if(isLogin()){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const OldVisits()));
                  }else{
                    var snackBar = const SnackBar(content: Text("Login required !"));
                    scaffoldKey.currentState?.showSnackBar(snackBar);
                  }

                },
                child: Container(
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(width: 3.0, color: Colors.black26),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      )),
                  child: Column(
                    children: const [
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
            Container(
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(width: 3.0, color: Colors.black26),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  )),

              child: GestureDetector(
                onTap: (){
                  if(isLogin()){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const UploadManager()));
                  }else{
                    var snackBar = const SnackBar(content: Text("Login required !"));
                    scaffoldKey.currentState?.showSnackBar(snackBar);
                  }
                },
                child: Column(
                  children: const [
                    Icon(
                      Icons.add_to_photos_rounded,
                      size: 40,
                      color: Colors.black54,
                    ),
                    Text(
                      "Uploaded Images",
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
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(
                children: const [
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
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(
                children: const [
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
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(
                children: const [
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
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(
                children: const [
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
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(
                children: const [
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
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(
                children: const [
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
        // )
    );
  }

  var authHandler = AuthService();

  void onSelected(BuildContext context ,int item){
    switch (item){
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const LabPicture()));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const ComponentVerify()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const TeachersTraining()));
        break;
      case 3:
        _signOut();
        break;
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>const LoginPage()), (route) => false);
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
