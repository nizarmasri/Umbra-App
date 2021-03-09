import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount googleUser;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signInWithGoogle() async {
    googleUser = await GoogleSignIn().signIn();
      try {
        //final googleAuth = await user.authentication;
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken
        );
        await _firebaseAuth.signInWithCredential(credential);
        print("Signed in");
        return "Signed in";
      }
      catch (e){
        print("Error signing in: " + e.message);
        return "Error signing in";
      }
  }

  Future<void> signOut() async {
    try{
      await _firebaseAuth.signOut();

    }
    catch(e){
      await _googleSignIn.disconnect();
    }
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      e.message;
      return "Invalid email";
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      e.message;
      return "Invalid email";
    }
  }
}


