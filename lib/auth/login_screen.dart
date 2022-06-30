import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stemro_app/auth/register_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import '../auth/AuthService.dart';
import 'home_page.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
   var authHandler = AuthService();
   bool isLoading = false;
   late String email, pass;
   final emailController = TextEditingController();
   final passController = TextEditingController();
   final scaffoldKey = GlobalKey<ScaffoldState>();
   final formKey = GlobalKey<FormState>();
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
            child: SingleChildScrollView(
              child: SafeArea(
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/path.png"),
                              fit: BoxFit.cover,
                          ),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20,0 , 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              // height: 80,
                              // width: 70,
                             child:   Image.asset(
                              'assets/stemrobo.png',
                              fit: BoxFit.cover,
                              height: 74,
                            ),
                              // child: SvgPicture.asset("assets/xing.svg")
                          ),
                          const HeightBox(10),
                          "Login".text.color(Colors.white).size(20).make(),
                          const HeightBox(
                              20
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              validator: (val) => !val!.contains("@") ? "Please enter EmailId" : null ,
                              onSaved: (val) => email = val!,
                              decoration: InputDecoration(
                                hintText: 'Enter Email',
                                labelText: ' Email',
                                hintStyle: const TextStyle(color: Colors.white),
                                labelStyle: const TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colors.white
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white
                                    )
                                ),
                                isDense: true,                      // Added this
                                contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              ),
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const HeightBox(
                              20
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: passController,
                              onSaved: (val) => pass = val!,
                              validator: (value) {
                                // add your custom validation here.
                                if (value!.isEmpty) {
                                  return 'Please enter Password';
                                }
                                if (value.length < 3) {
                                  return 'Must be more than 2 charater';
                                }
                                return null;
                              },
                              // validator: (val) => val!.length < 26  ? "Password length too much large" : null ,
                              decoration: InputDecoration(
                                  labelText: "Password",
                                  hintText: "Enter Password",

                                hintStyle: const TextStyle(color: Colors.white),
                                labelStyle: const TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colors.white
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white,
                                    )
                                ),
                                isDense: true,                      // Added this
                                contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              ),
                              cursorColor: Colors.white,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const HeightBox(20),
                          GestureDetector(
                              onTap: (){
                                // Fluttertoast.showToast(msg: "Invalid email and/or password. Please try again",
                                //     toastLength: Toast.LENGTH_LONG,
                                //     gravity: ToastGravity.BOTTOM_LEFT,
                                //
                                //     backgroundColor: Colors.teal.shade200,
                                //     textColor: Colors.white,
                                //     fontSize: 16.0
                                // );

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
                                    var snackBar = const SnackBar(content: Text("Login success"));
                                    scaffoldKey.currentState?.showSnackBar(snackBar);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
                                  }else{
                                    var snackBar = SnackBar(content: Text(response.toString()));
                                    // scaffoldKey.currentState?.showSnackBar(snackBar);
                                  }
                                }).catchError((e) => print(e));
                              },
                            child:isLoading?Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
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
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ) :Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 150,
                              color: Colors.teal,
                              child: const Text('LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ),
                        ], //
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: (){
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegistrationPage()));
          },
          child: RichText(text: const TextSpan(
            text: 'New User?',
            style: TextStyle(fontSize: 18.0, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: ' Register Now',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                ),
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
    content: Row(
      children: [
        const CircularProgressIndicator(color: Colors.white,),
        Container(margin: const EdgeInsets.only(left: 7),child:const Text("Loading..." )),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}