import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stemro_app/view/home_screen.dart';

import 'package:velocity_x/velocity_x.dart';

import 'login_screen.dart';

import 'package:firebase_database/firebase_database.dart';
import '../auth/AuthService.dart';
import 'dart:developer';

class RegistrationPage extends StatelessWidget {
  late String _email, _password;
  bool _passwordVisible = false;
  var authHandler = AuthService();

  final nameController = TextEditingController();
  final schoolController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade300,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/unsplash.jpg"),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,40 , 20, 0),
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
                      HeightBox(
                          20
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TextField(

                          controller: nameController,
                          decoration: InputDecoration(
                            hintText:  "Engineer's Name",
                            labelText: "Engineer's Name",
                            // hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Colors.white
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: Colors.black
                                )
                            ),
                            isDense: true,                      // Added this
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          ),
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      HeightBox(
                          20
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TextField(

                          controller: schoolController,
                          decoration: InputDecoration(
                            hintText: 'School Name',
                             labelText: 'School Name',
                             enabledBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Colors.white
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )
                            ),
                            isDense: true,                      // Added this
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          ),
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      HeightBox(
                          20
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TextFormField(

                          controller: emailController,
                          validator: (val) => val!.contains("@") ? "Email Id is not Valid" : null ,
                          onSaved: (val) => _email = val!,
                          decoration: InputDecoration(
                            hintText: 'Email',
                             labelText:'Email' ,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Colors.white
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: Colors.black
                                )
                            ),
                            isDense: true,                      // Added this
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          ),
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      HeightBox(
                          20
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TextFormField(

                          controller: passController,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            labelText: "Password",

                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Colors.white
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: Colors.black
                                )
                            ),
                            isDense: true,

                            // Added this
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          ),
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          obscureText: true,

                          validator: (val)=>val!.length <6 ? 'Password too short.':null,
                          onSaved: (val) =>_password = val!,

                        ),
                      ),
                      HeightBox(20),
                      GestureDetector(
                          onTap: (){
                            print("Register Clicked Event");
                            authHandler.handleSignUp(emailController.text, passController.text).then((user) {
                              if (!user.uid.endsWith("null")) {
                                FirebaseDatabase.instance.reference().child(user.uid)
                                    .child('email').set(emailController.text);
                                FirebaseDatabase.instance.reference().child(user.uid)
                                    .child('password').set(passController.text);
                                FirebaseDatabase.instance.reference().child(user.uid)
                                    .child('name').set(nameController.text);
                                FirebaseDatabase.instance.reference().child(user.uid)
                                    .child('school').set(schoolController.text);
                                print("Registration success");
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                              }else{
                                print("Registration failed");
                                //Show error message to user
                              }
                            }).catchError((e) => print(e));
                          },
                          child: "Sign-Up".text.white.light.xl.makeCentered().box.white.shadowOutline(outlineColor: Colors.grey).
                          color(Colors.teal).roundedLg.make().w(200).h(55)),
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
          onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
          },
          child: RichText(text: TextSpan(
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
          )
          ).pLTRB(20, 0, 0, 15),
        ),
    );
  }
}