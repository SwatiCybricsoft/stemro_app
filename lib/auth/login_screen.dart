import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stemro_app/auth/register_screen.dart';
import 'package:stemro_app/view/home_screen.dart';
import 'package:stemro_app/widgets/validation.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../auth/AuthService.dart';
import 'dart:developer';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
   var authHandler = AuthService();
   bool isLoading = false;
   late String _email, _pass;
  final emailController = TextEditingController();
  final passController = TextEditingController();
   final scaffoldKey = new GlobalKey<ScaffoldState>();
   final formKey = new GlobalKey<FormState>();

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.teal.shade300,
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
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
                            validator: (val) => !val!.contains("@") ? "Email Id is not Valid" : null ,
                            onSaved: (val) => _email = val!,
                            decoration: InputDecoration(
                              hintText: 'Enter Email',
                              labelText: ' Email',

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
                            onSaved: (val) => _pass = val!,
                            validator: (val) => val!.length < 6  ? "Password length should be Greater than 6" : null ,
                            decoration: InputDecoration(
                                labelText: "Password",
                                hintText: "Enter Password",
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
                              authHandler.handleSignIn(emailController.text, passController.text).then((response) {
                                print(response.toString());
                                if(response.toString().endsWith("Success")){
                                  var snackBar = new SnackBar(content: Text("Login success"));
                                  scaffoldKey.currentState?.showSnackBar(snackBar);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
                                }else{
                                  var snackBar = new SnackBar(content: Text(response.toString()));
                                  scaffoldKey.currentState?.showSnackBar(snackBar);
                                }
                              }).catchError((e) => print(e));
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
                            child: Text('LOGIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          )

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