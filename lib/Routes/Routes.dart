import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/Routes/RouteConstant.dart';
import 'package:project/Screens/SplashScreen.dart';
import 'package:project/Screens/fulscreenImagePage.dart';
import 'package:project/Screens/page1.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var arguments = settings.arguments;
  switch (settings.name) {
    case splashScreenRoute:
      return MaterialPageRoute(builder: (context) => Splash());
    case homeRoute:
      return MaterialPageRoute(builder: (context) => QuestionPage());
    case fullscreenImagePageRoute:
      return MaterialPageRoute(
          builder: (context) => FullScreenPage(
                sas: arguments,
              ));
  }
}
