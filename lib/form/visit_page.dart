import 'package:flutter/material.dart';
import 'package:stemro_app/auth/login_screen.dart';
import 'package:stemro_app/view/Lab_picture.dart';
import 'package:stemro_app/view/component_verification.dart';
import 'package:stemro_app/view/teachers_traing.dart';

import 'package:firebase_database/firebase_database.dart';
import '../auth/AuthService.dart';
import 'dart:developer';
import 'package:intl/intl.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}
class _FormPageState extends State<FormPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.teal,
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage ()));
        },
            icon:Icon(Icons.arrow_back_ios,size: 20,color: Colors.white,)),
        title: Text('School Visit Form',maxLines: 1,style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),),
      ),
      body:MyCustomForm() ,
    );
  }
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
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>LoginPage()), (route) => false);
        break;
    }
  }
}
// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}
// Create a corresponding State class. This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  int dropDownValue = 0;

  final dateController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final schoolController = TextEditingController();
  final typeController = TextEditingController();
  final noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
           child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5,bottom: 10,left: 0),
                child: Text('School Visit Form',style: TextStyle(
                    decoration: TextDecoration.underline,fontSize: 20,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold
                ),),
              ),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                    filled: true,
                    hintText:"Today's Date",
                    labelText: "Today's Date"
                ),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                    filled: true,
                    hintText: "Engineer's Name",
                    labelText: "Engineer's Name"
                ),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    filled: true,
                    hintText: "Engineer's EmailID",
                    labelText: "Engineer's EmailID"
                ),
              ),
              TextFormField(
                controller: schoolController,
                decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Enter School Name',
                    labelText: "Enter School Name"
                ),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true
                  // prefixIcon: Icon(Icons.person),
                ),
                hint: Text('Select Visit Purpose',style: TextStyle(
                  letterSpacing: 1.0
                ),),
                items: <String>['ComponentVerification',
                  'TeachersTraining', 'RegularVisit', 'PreSalesDemo/Meeting','Technical/DocumentationSupport'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Add a note',
                    labelText: " Add a note"
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Center(
                child: new Container(
                    padding: const EdgeInsets.only(top: 30),
                   child: RaisedButton.icon(onPressed:(){

                     var now = DateTime.now();
                     String requestID = DateFormat('yyyyMMddhhmmss').format(now);
                     
                     FirebaseDatabase.instance.reference().child("School Visit").child(requestID)
                         .child('date').set(dateController.text);
                     FirebaseDatabase.instance.reference().child("School Visit").child(requestID)
                         .child('name').set(nameController.text);
                     FirebaseDatabase.instance.reference().child("School Visit").child(requestID)
                         .child('email').set(emailController.text);
                     FirebaseDatabase.instance.reference().child("School Visit").child(requestID)
                         .child('school').set(schoolController.text);
                     FirebaseDatabase.instance.reference().child("School Visit").child(requestID)
                         .child('note').set(noteController.text);
                     FirebaseDatabase.instance.reference().child("School Visit").child(requestID)
                         .child('uid').set(AuthService().getUID());
                   },
                       icon: Icon(Icons.login), label:Text("SAVE",style: TextStyle(color: Colors.teal),))
                ),
              ),
            ],
          ),
        ),
        ),
      )
    );
  }
}