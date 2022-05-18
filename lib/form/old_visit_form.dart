import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:stemro_app/view/home_screen.dart';
import '../auth/AuthService.dart';
import 'dart:async';

class OldVisits extends StatefulWidget {
  @override
  State<OldVisits> createState() => _FormPageState();
}
class _FormPageState extends State<OldVisits> {

  List data = [];

  Future<String> getData() async {
    var uid = AuthService().getUser()!.uid;//Show only items who have the same uid
    DatabaseReference reference = FirebaseDatabase.instance.ref("School Visits");
    reference.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        data = event.snapshot as List;
        print(data);
      } else {
        print('No data available.');
      }
    });
    print(data[1]["uid"]);

    return "Success!";
  }
  @override
  void initState(){
    this.getData();
  }
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.teal,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) =>Home()));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            )),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/stemrobo.png',
              fit: BoxFit.contain,
              height: 32,
            ),
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
      body: new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 10,
        // itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return makeCard;
        },
      ),
    );
  }
  final makeCard = Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color:Colors.teal.shade300),
      child: makeListTile,
    ),
  );

}
final makeListTile = ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: CircleAvatar(
      child:  Icon(
        Icons.add_to_photos_rounded,
        size: 20,
        color: Colors.black54,
      ),
      backgroundColor: Colors.white,
    ),
    title: Text(
      "Name of Engineer ",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

    subtitle: Row(
      children: <Widget>[
        Icon(Icons.linear_scale, color: Colors.yellowAccent),
        Text(" Email", style: TextStyle(color: Colors.white))
      ],
    ),
    trailing:
    Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));