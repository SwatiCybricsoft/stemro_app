import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stemro_app/auth/register_screen.dart';
import 'package:stemro_app/view/home_screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../auth/AuthService.dart';
import 'dart:developer';

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
   var authHandler = AuthService();
   bool isLoading = false;
   late String _email, _password;

  final emailController = TextEditingController();

  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade300,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Stack(
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
                        child: TextFormField(

                          controller: emailController,
                          validator: (val) => val!.contains("@") ? "Email Id is not Valid" : null ,
                          onSaved: (val) => _email = val!,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            labelText: 'Enter Email',
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
                                    color: Colors.white
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
                          validator: (val)=>val!.length <6 ? 'Password too short.':null,
                          onSaved: (val) =>_password = val!,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            labelText: 'Enter Password',

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
                                    color: Colors.white,
                                )
                            ),
                            isDense: true,                      // Added this
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          ),
                          cursorColor: Colors.white,
                          obscureText: true,

                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      HeightBox(20),
                      GestureDetector(
                          onTap: (){
                            setState(() {
                              isLoading = true;
                            });
                            Future.delayed(const Duration(seconds: 3),(){
                              setState(() {
                                isLoading = false;
                              });
                            }
                            );

                            print("Login Clicked Event");
                            authHandler.handleSignIn(emailController.text, passController.text).then((user) {
                              if(!user.uid.endsWith("null")){
                                print("Login success");
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
                              }else{
                                print("Login failed");
                                //Show some error to user
                              }
                            }).catchError((e) => print(e));
                          },
                        child:isLoading?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Loading...',style: TextStyle(
                              color: Colors.teal
                            ),),
                            SizedBox(
                              width: 10,
                            ),
                            CircularProgressIndicator(color: Colors.white,)
                          ],
                        ) :Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 150,
                          color: Colors.teal,
                          child: Text('Login'),
                        )

                          // child: "Login".text.white.light.xl.makeCentered().box.white.shadowOutline(outlineColor: Colors.white).
                          // color(Colors.teal).roundedLg.make().w(200).h(55)
                      ),
                      // HeightBox(30),
                      // "Login with".text.white.makeCentered(),
                      // // SocialSignWidgetRow()
                    ], // "L
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: (){
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegistrationPage()));
          },
          child: RichText(text: TextSpan(
            text: 'New User?',
            style: TextStyle(fontSize: 15.0, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: ' Register Now',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color:Colors.teal),
              ),
            ],
          )
          ).pLTRB(20, 0, 0, 15),
        )
    );
  }
}
showLoaderDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}