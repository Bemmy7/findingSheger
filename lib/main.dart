import 'package:flutter/material.dart';
import 'package:project/Routes/RouteConstant.dart';
import 'package:project/Routes/Routes.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project',
      onGenerateRoute: (settings) => generateRoute(settings),
      initialRoute: splashScreenRoute,
    );
  }
}
