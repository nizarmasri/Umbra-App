library events.globals;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:awesome_loader/awesome_loader.dart';

TextStyle style = TextStyle(
    fontSize: 35,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w300,
    color: Colors.white);

String montserrat = "Montserrat";
FontWeight fontWeight = FontWeight.w300;

Size size(BuildContext c) => MediaQuery.of(c).size;

double width(BuildContext c) => size(c).width;

double height(BuildContext c) => size(c).height;

TextStyle infoSectionStyle = TextStyle(
    fontSize: 17,
    fontFamily: montserrat,
    fontWeight: fontWeight,
    color: Colors.white);

bool isOrg = false;

String uid;

/*AwesomeLoader spinner = AwesomeLoader(
  loaderType: AwesomeLoader.AwesomeLoader2,
  color: Colors.white,
);*/

SpinKitFoldingCube spinner = SpinKitFoldingCube(
  color: Colors.white,
  size: 40.0,
);

AssetImage background = AssetImage('assets/login_background.jpg');

