import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:events/authentication_service.dart';
import 'package:events/globals.dart' as globals;
import 'package:events/outerLogin.dart';
import 'package:events/navigator.dart';
import 'package:events/libOrg/navigator.dart';
import 'package:events/libOrg/blocs/application_bloc.dart';
import 'package:events/newUserForm.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<void> main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges)
      ],
      child: ChangeNotifierProvider(
        create: (context) => ApplicationBloc(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Montserrat',
            canvasColor: Colors.black,
          ),
          home: AuthenticationWrapper(),
        ),
      ),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      if (globals.isOrg) {
        return NavigatorOrgPage(uid: firebaseUser.uid);
      } else {
        return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(firebaseUser.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SpinKitFadingCircle(
                  color: Colors.white,
                  size: 50.0,
                );
              }
              if (snapshot.data.data()["new"]) {
                return NewUserForm(uid: firebaseUser.uid);
              } else {
                if (snapshot.data.data()["organizer"]) {
                  return NavigatorOrgPage(uid: firebaseUser.uid);
                } else {
                  return NavigatorPage(uid: firebaseUser.uid);
                }
              }
            });
      }
    }

    return outerLogin();
  }
}

/*     final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;
      final uid = user.uid;
      bool newUser = true;
      FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get()
          .then((query) {
        newUser = query.data()["new"];
      });
      if (newUser) {
        return NewUserForm(function: increment);
      } else {
        return NavigatorPage(uid: uid);
      }
    }*/
