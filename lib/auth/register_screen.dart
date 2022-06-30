import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:velocity_x/velocity_x.dart';

import 'home_page.dart';
import 'login_screen.dart';

import 'package:firebase_database/firebase_database.dart';
import '../auth/AuthService.dart';


class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  late String _email, _pass,_name, _school  ;
  var authHandler = AuthService();
  bool isLoading = false;
  final nameController = TextEditingController();
  final schoolController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.teal.shade300,
    ));
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.teal.shade300,
      body: Center(
        child: Form(
          key: formKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    // Container(
                    //   decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //           image: AssetImage("assets/unsplash.jpg"),
                    //           fit: BoxFit.fill)),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(

                              child:   Image.asset(
                                'assets/stemrobo.png',
                                fit: BoxFit.contain,
                                height: 74,
                              ),
                              // child: SvgPicture.asset("assets/xing.svg")
                          ),
                          const HeightBox(10),
                          "Sign Up".text.color(Colors.white).size(20).make(),
                          const HeightBox(20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: TextFormField(
                              onSaved: (val) => _name = val!,
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return  "Please enter Engineer's Name";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: " Enter Engineer's Name",
                                labelText: "Engineer's Name",
                                labelStyle: const TextStyle(color: Colors.white),
                                hintStyle: const TextStyle(color: Colors.white),
                                // hintStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(color: Colors.white)),
                                isDense: true, // Added this
                                contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              ),
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const HeightBox(20),
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          //   child: TextFormField(
                          //     onSaved: (val) => _school = val!,
                          //     validator: (value){
                          //       if(value == null || value.isEmpty){
                          //         return 'Please enter School Name.';
                          //       }
                          //       return null;
                          //     },
                          //     controller: schoolController,
                          //     keyboardType: TextInputType.text,
                          //     decoration: InputDecoration(
                          //       hintText: " Enter School Name",
                          //       labelText: "School Name",
                          //       labelStyle: TextStyle(color: Colors.white),
                          //       hintStyle: TextStyle(color: Colors.white),
                          //       // hintStyle: TextStyle(color: Colors.black),
                          //       enabledBorder: OutlineInputBorder(
                          //         borderRadius: new BorderRadius.circular(10.0),
                          //         borderSide: BorderSide(color: Colors.white),
                          //       ),
                          //       focusedBorder: OutlineInputBorder(
                          //           borderRadius: new BorderRadius.circular(10.0),
                          //           borderSide: BorderSide(color: Colors.white)),
                          //       isDense: true, // Added this
                          //       contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          //     ),
                          //     cursorColor: Colors.white,
                          //     style: TextStyle(color: Colors.white),
                          //   ),
                          // ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: TextFormField(
                              controller: emailController,
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Please enter EmailId.';
                                }
                                return null;
                              },
                              onSaved: (val) => _email = val!,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: ' Enter Email',
                                labelText: ' Email',
                                labelStyle: const TextStyle(color: Colors.white),
                                hintStyle: const TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(color: Colors.white)),
                                isDense: true, // Added this
                                contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              ),
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const HeightBox(20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: passController,
                              decoration: InputDecoration(
                                hintText: 'Enter Password',
                                labelText: "  Password",
                                labelStyle: const TextStyle(color: Colors.white),
                                hintStyle: const TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(color: Colors.white)),
                                isDense: true,

                                // Added this
                                contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              ),
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              obscureText: true,
                              onSaved: (val) => _pass = val!,
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Please enter  Password .';
                                }
                                return null;
                              },
                            ),
                          ),

                          const HeightBox(20),
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

                                    final userData = {
                                      'email': emailController.text,
                                      'password': passController.text,
                                      'name': nameController.text,
                                      // 'school': schoolController.text,
                                      'accountType': "Engineer"
                                    };
                                    Fluttertoast.showToast(msg: "Please Enters all Details",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM_LEFT,
                                        backgroundColor: Colors.teal.shade200,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                    String uid = FirebaseAuth.instance.currentUser!.uid;
                                    final Map<String, Map> updates = {};
                                    updates['/Users/$uid'] = userData;

                                    FirebaseDatabase.instance.ref().update(updates);

                                    var snackBar = const SnackBar(content: Text("Registration successful"));
                                    scaffoldKey.currentState?.showSnackBar(snackBar);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>MyHomePage()));
                                  } else {
                                    //Show error message to user
                                    var snackBar = SnackBar(content: Text(response));
                                   // scaffoldKey.currentState?.showSnackBar(snackBar);
                                  }
                                }).catchError((e) => print(e));
                              },
                              child: isLoading
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
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
                                      child: const Text('SIGNUP',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),

                              ),
                        ],
                      ),

                    )
                  ],
                ),
              ),

            ),
          ),
        ),
      ),


      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: RichText(
            text: const TextSpan(
          text: 'New User?',
          style: TextStyle(fontSize: 18.0, color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              text: ' Login Now',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        )).pLTRB(20, 0, 0, 15),
      ),



    );
  }
}
