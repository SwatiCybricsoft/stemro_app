import 'package:flutter/material.dart';
import 'package:stemro_app/form/submitpage.dart';
import 'package:stemro_app/view/home_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_database/firebase_database.dart';
import '../auth/AuthService.dart';
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
      padding: const EdgeInsets.only(left: 20,right: 20,top: 0),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 1,bottom: 10,left: 0),
                  child: Text('School Visit Form',style: TextStyle(
                      decoration: TextDecoration.underline,fontSize: 20,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold
                  ),),
                ),
                TextFormField(
                  readOnly:  true,
                  // onSaved: (val) => _date = val!,
                  // validator: (val) => val!.length < 1  ? "Enter Date" : null ,
                  controller: dateController,
                  decoration: InputDecoration(
                    hintText: "Today Date",
                    labelText: 'Date',
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  onTap: ()async{
                    await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2031),
                    ).then((selectedDate) {
                      if(selectedDate !=null){
                        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                      }
                    });
                  },
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter date.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: nameController,
                   onSaved: (val) => _name = val!,
                  // validator: (val) => val!.length < 1  ? "Enter Name" : null ,
                  decoration: InputDecoration(
                    hintText: "Enter Engineer Name",
                    labelText: "Engineer Name",
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black),

                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter Engineer\s name.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,

                  // validator: (val) => !val!.contains("@") ? "Email Id is not Valid" : null ,
                  // onSaved: (val) => _email = val!,
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    fillColor: Colors.black,
                    labelText: ' Email',
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter  EmailId.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: schoolController,
                   onSaved: (val) => _school = val!,
                  decoration: InputDecoration(
                    hintText: 'Enter  School Name',
                    labelText: 'School Name',
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter  School Name.';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                      filled: false
                    // prefixIcon: Icon(Icons.person),
                  ),
                  hint: Text('Select Visit Purpose',style: TextStyle(
                    color: Colors.black,
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
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter Visit Of Purpose.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                   onSaved: (val) => _note = val!,
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText: 'Enter Note',
                    labelText: ' Note',
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black),
                    isDense: true,                      // Added this
                    contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter  Note.';
                    }
                    return null;
                  },
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