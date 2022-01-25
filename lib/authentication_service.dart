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
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await _firebaseAuth.signInWithCredential(credential).then((value) async {
        String uid = value.user.uid;
        String email = value.user.email;
        bool isNewUser;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get()
            .then((value) {
          if (value.exists)
            isNewUser = false;
          else
            isNewUser = true;
        });

        if (isNewUser)
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'email': email,
            'new': isNewUser,
            'organizer': false,
          });
      });
      return "Signed in";
    } catch (e) {
      return "Error signing in";
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      await _googleSignIn.disconnect();
    }
  }

  Future<List<String>> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return ["Signed in", "NO"];
    } on FirebaseAuthException catch (e) {
      return ["Invalid email", e.message];
    }
  }

  Future<String> signUp({String email, String password, bool organizer}) async {
    try {
      print(organizer);
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      String user = result.user.uid;
      await FirebaseFirestore.instance.collection('users').doc(user).set({
        'email': email,
        'new': true,
        'organizer': organizer,
      });
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return "Invalid email";
    }
  }
}
