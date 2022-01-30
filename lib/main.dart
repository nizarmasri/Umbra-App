import 'package:events/views/authentication/authentication_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:events/views/authentication/authentication_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Geolocator.requestPermission();
  runApp(MultiProvider(
    providers: [
      Provider<AuthenticationService>(
        create: (_) => AuthenticationService(FirebaseAuth.instance),
      ),
      StreamProvider(
        create: (context) =>
            context.read<AuthenticationService>().authStateChanges,
        initialData: null,
      )
    ],
    child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: true,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        canvasColor: Colors.black,
      ),
      home: AuthenticationWrapper(),
    ),
  ));
}
