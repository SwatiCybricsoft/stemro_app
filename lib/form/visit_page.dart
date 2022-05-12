import 'package:flutter/material.dart';
import 'package:stemro_app/auth/login_screen.dart';
import 'package:stemro_app/form/submitpage.dart';
import 'package:stemro_app/view/Lab_picture.dart';
import 'package:stemro_app/view/component_verification.dart';
import 'package:stemro_app/view/home_screen.dart';
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
bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,
      appBar: AppBar(

        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.teal,
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home ()));
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
  bool isLoading = false;
  final dateController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final schoolController = TextEditingController();
  final typeController = TextEditingController();
  final noteController = TextEditingController();

  late int typeIndex;

  var options = <String>['ComponentVerification',
    'TeachersTraining', 'RegularVisit', 'PreSalesDemo/Meeting','Technical/DocumentationSupport'];

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
                items: options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    typeIndex = options.indexOf(value!);
                    print(options[typeIndex]);
                  });
                },
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
                child: Container(
                    padding: const EdgeInsets.only(top: 30),
                   child: RaisedButton.icon(onPressed:(){
                     setState(() {
                       isLoading = true;
                     });
                     Future.delayed(const Duration(seconds: 3),(){
                       setState(() {
                         isLoading = false;
                       });
                     }
                     );
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
                         .child('type').set(options[typeIndex]);
                     FirebaseDatabase.instance.reference().child("School Visit").child(requestID)
                         .child('note').set(noteController.text);
                     FirebaseDatabase.instance.reference().child("School Visit").child(requestID)
                         .child('uid').set(AuthService().getUID());
                   },
                       icon: GestureDetector(
                         onTap: (){
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SubmitPage(title: 'SubmitPage')));
                         },
                           child: Icon(Icons.login)), label:Text("SAVE",style: TextStyle(color: Colors.teal),))
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