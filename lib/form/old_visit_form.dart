import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
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
      appBar: new AppBar(title: new Text("Listviews"), backgroundColor: Colors.blue),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return new Card(
            child: new Text(data[index]["uid"]),
          );
        },
      ),
    );
  }

}