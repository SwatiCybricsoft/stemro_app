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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/stemrobo.png',
                fit: BoxFit.contain,
                height: 32,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('📝')
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
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  int dropDownValue = 0;
  bool isLoading = false;
  final dateController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final schoolController = TextEditingController();
  final typeController = TextEditingController();
  final noteController = TextEditingController();
  late String _date, _name,_email,_school,_note;
  late int typeIndex;

  var options = <String>['ComponentVerification',
    'TeachersTraining', 'RegularVisit', 'PreSalesDemo/Meeting','Technical/DocumentationSupport'];

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                  // onSaved: (val) => _date = val!,
                  // validator: (val) => val!.length < 1  ? "Enter Date" : null ,
                  controller: dateController,
                  decoration: const InputDecoration(
                      filled: true,
                      hintText:"Today's Date",
                      labelText: "Today's Date"
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  // onSaved: (val) => _name = val!,
                  // validator: (val) => val!.length < 1  ? "Enter Name" : null ,
                  decoration: const InputDecoration(
                      filled: true,
                      hintText: "Engineer's Name",
                      labelText: "Engineer's Name"
                  ),
                ),
                TextFormField(
                  controller: emailController,
                  // validator: (val) => !val!.contains("@") ? "Email Id is not Valid" : null ,
                  // onSaved: (val) => _email = val!,
                  decoration: const InputDecoration(
                      filled: true,
                      hintText: "Engineer's EmailID",
                      labelText: "Engineer's EmailID"
                  ),
                ),
                TextFormField(
                  controller: schoolController,
                  // onSaved: (val) => _school = val!,
                  // validator: (val) => val!.length < 2  ? "Enter School Name" : null ,
                  decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter School Name',
                      labelText: "Enter School Name"
                  ),
                ),
                DropdownButtonFormField<String>(
                  isExpanded: true,
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
                  // onSaved: (val) => _note = val!,
                  // validator: (val) => val!.length < 4  ? "Enter Notes" : null ,
                  controller: noteController,
                  decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Add a note',
                      labelText: " Add a note"
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                    onTap: (){
                      if(formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                      }

                      setState(() {
                        isLoading = true;
                      });
                      Future.delayed(const Duration(seconds: 3),(){
                        setState(() {
                          isLoading = false;
                        });
                      }
                      );
                      writeNewVisit();
                    },
                    child:isLoading?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Please Wait...',style: TextStyle(
                            color: Colors.teal
                        ),),
                        SizedBox(
                          width: 10,
                        ),
                        Center(
                          heightFactor: 1,
                          widthFactor: 1,
                          child: SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                            ),
                          ),
                        )

                      ],
                    ) :Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 150,
                      color: Colors.teal,
                      child: Text('SAVE',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )

                ),
                // Center(
                //   child: Container(
                //       padding: const EdgeInsets.only(top: 30),
                //      child: RaisedButton.icon(onPressed:(){
                //
                //        setState(() {
                //          isLoading = true;
                //        });
                //
                //        var now = DateTime.now();
                //        String requestID = DateFormat('yyyyMMddhhmmss').format(now);
                //        FirebaseDatabase.instance.reference().child("School Visit").child(requestID)
                //            .child('date').set(dateController.text);
                //        FirebaseDatabase.instance.reference().child("School Visit").child(requestID)
                //            .child('name').set(nameController.text);
                //        FirebaseDatabase.instance.reference().child("School Visit").child(requestID)
                //            .child('email').set(emailController.text);
                //        FirebaseDatabase.instance.reference().child("School Visit").child(requestID)
                //            .child('school').set(schoolController.text);
                //        FirebaseDatabase.instance.reference().child("School Visit").child(requestID)
                //            .child('type').set(options[typeIndex]);
                //        FirebaseDatabase.instance.reference().child("School Visit").child(requestID)
                //            .child('note').set(noteController.text);
                //        FirebaseDatabase.instance.reference().child("School Visit").child(requestID)
                //            .child('uid').set(AuthService().getUID());
                //      },
                //          icon: GestureDetector(
                //            onTap: (){
                //              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SubmitPage(title: 'SubmitPage')));
                //            },
                //              child:isLoading?Row(
                //                children: [
                //                  Text('Please Wait...',style: TextStyle(
                //                      color: Colors.teal
                //                  ),),
                //                  SizedBox(
                //                    width: 10,
                //                  ),
                //                  CircularProgressIndicator(color: Colors.teal,)
                //                ],
                //              ): Icon(Icons.login)), label:Text("SAVE",style: TextStyle(color: Colors.teal),))
                //   ),
                // ),
              ],
            ),
          ),
        ),
      )
    );
  }

  void writeNewVisit() async {

    var uid = AuthService().getUID();

    final visitData = {
      'date': dateController.text,
      'name': nameController.text,
      'email': emailController.text,
      'school': schoolController.text,
      'type': options[typeIndex],
      'note': noteController.text,
      'uid': uid,
    };

    final newVisitKey =
        FirebaseDatabase.instance.ref().push().key;

    final Map<String, Map> updates = {};
    updates['/Users/$uid/School Visits/$newVisitKey'] = visitData;
    updates['/School Visits/$newVisitKey'] = visitData;

    FirebaseDatabase.instance.ref().update(updates);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SubmitPage(title: 'SubmitPage',)));
  }
}