import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:events/authentication_service.dart';
import 'package:events/globals.dart' as globals;
import 'package:events/outerLogin.dart';
import 'package:events/navigator.dart';
import 'package:events/libOrg/navigator.dart';
import 'package:events/libOrg/blocs/application_bloc.dart';
import 'package:events/newUserForm.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['text'],
      NotificationDetails(
        android: AndroidNotificationDetails(
            channel.id, channel.name, channel.description,
            playSound: true,
            importance: Importance.max,
            priority: Priority.high),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      flutterLocalNotificationsPlugin.show(
          message.data.hashCode,
          message.data['title'],
          message.data['text'],
          NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                icon: android?.smallIcon,
                playSound: true,
                importance: Importance.max,
                priority: Priority.high
                // other properties...
                ),
          ));
    });
    super.initState();
  }

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
