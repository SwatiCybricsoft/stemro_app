import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //1
  Future<Object> handleSignIn(String email, String password) async {
    try{
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      if (user != null) {
        return "Success";
      }else{
        return "Failed";
      }
    }catch (error){
      return error;
    }
  }
  //2
  Future<String> handleSignUp(email, password) async {
    try{
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      if (user != null) {
        return "Success";
      }else{
        return "Failed";
      }
    }catch (error){
      return error.toString();
    }
  }
  //3
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return Future<bool>.value(true);
    } on FirebaseAuthException {
      return Future<bool>.value(false);
    }
  }
  //4
  User? getUser() {
    try {
      User? user = _firebaseAuth.currentUser;
      return user;
    } on FirebaseAuthException {
      return null;
    }
  }
  //5
  String getUID() {
    try {
      return _firebaseAuth.currentUser!.uid;
    } on FirebaseAuthException {
      return "Default";
    }
  }
}
