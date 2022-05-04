import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //1
  Future<User> handleSignIn(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user!;
    return user;
  }

  //2
  Future<User> handleSignUp(email, password) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user!;
    return user;
  }

  //3
  Future<String?> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return "Failed";
    }
  }

  //4
  User? getUser() {
    try {
      return _firebaseAuth.currentUser;
    } on FirebaseAuthException {
      return null;
    }
  }
}
