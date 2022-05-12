import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stemro_app/view/home_screen.dart';

import 'package:velocity_x/velocity_x.dart';

import 'login_screen.dart';

import 'package:firebase_database/firebase_database.dart';
import '../auth/AuthService.dart';
import 'dart:developer';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late String _email, _pass, _name, _school;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  var authHandler = AuthService();

  bool isLoading = false;

  final nameController = TextEditingController();

  final schoolController = TextEditingController();

  final emailController = TextEditingController();

  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.teal.shade300,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/unsplash.jpg"),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 100,
                        width: 100,
                        child: SvgPicture.asset("assets/xing.svg")),
                    HeightBox(10),
                    "Login".text.color(Colors.white).size(20).make(),
                    HeightBox(20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextFormField(
                        onSaved: (val) => _name = val!,
                        validator: (val) =>
                            val!.length < 2 ? "Enter Engineer's Name" : null,
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Engineer's Name",
                          labelText: " Enter Engineer's Name",
                          // hintStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.black)),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        ),
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    HeightBox(20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextFormField(
                        onSaved: (val) => _school = val!,
                        validator: (val) =>
                            val!.length < 2 ? "Enter School Name" : null,
                        controller: schoolController,
                        decoration: InputDecoration(
                          hintText: 'School Name',
                          labelText: ' Enter School Name',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.black,
                              )),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        ),
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    HeightBox(20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextFormField(
                        controller: emailController,
                        validator: (val) =>
                            val!.contains("@") ? "Email Id is not Valid" : null,
                        onSaved: (val) => _email = val!,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          labelText: ' Enter Email',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.black)),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        ),
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    HeightBox(20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextFormField(
                        controller: passController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: " Enter Password",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.black)),
                          isDense: true,

                          // Added this
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        ),
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        obscureText: true,
                        onSaved: (val) => _pass = val!,
                        validator: (val) => val!.length < 6
                            ? "Password length should be Greater than 6"
                            : null,
                      ),
                    ),
                    HeightBox(20),
                    GestureDetector(
                        onTap: () {
                          print("cliiked");
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                          }
                          setState(() {
                            isLoading = true;
                          });
                          Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              isLoading = false;
                            });
                          });
                          authHandler.handleSignUp(emailController.text, passController.text).then((response) {
                            print(response);
                            if (response.endsWith("Success")) {
                              String uid = FirebaseAuth.instance.currentUser!.uid;
                              FirebaseDatabase.instance.reference().child(uid).child('email').set(emailController.text);
                              FirebaseDatabase.instance.reference().child(uid).child('password').set(passController.text);
                              FirebaseDatabase.instance.reference().child(uid).child('name').set(nameController.text);
                              FirebaseDatabase.instance.reference().child(uid).child('school').set(schoolController.text);
                              var snackBar = new SnackBar(content: Text("Registration successful"));
                              scaffoldKey.currentState?.showSnackBar(snackBar);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                            } else {
                              //Show error message to user
                              var snackBar = new SnackBar(content: Text(response));scaffoldKey.currentState?.showSnackBar(snackBar);
                            }
                          }).catchError((e) => print(e));
                        },
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Please Wait...',
                                    style: TextStyle(color: Colors.teal),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                ],
                              )
                            : Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 150,
                                color: Colors.teal,
                                child: Text('SignUp'),
                              )

                        // child: "Login".text.white.light.xl.makeCentered().box.white.shadowOutline(outlineColor: Colors.white).
                        // color(Colors.teal).roundedLg.make().w(200).h(55)
                        ),
                    HeightBox(140),
                    "Login with".text.black.makeCentered(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: RichText(
            text: TextSpan(
          text: 'New User?',
          style: TextStyle(fontSize: 15.0, color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              text: ' Login Now',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.teal),
            ),
          ],
        )).pLTRB(20, 0, 0, 15),
      ),
    );
  }
}
