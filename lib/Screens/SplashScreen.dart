import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/Global/Global.dart';
import 'package:project/Routes/RouteConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> with TickerProviderStateMixin {
  AnimationController anim;
  String json =
      "{ \"total\": 2 ,\"1\": {\"index\": 1,\"imageUrl\": \"assets/images/minilik.jpg\",\"answer\": \"MinilikSquare\"},\"2\": {\"index\": 2,\"imageUrl\": \"assets/images/meskel.jpg\",\"answer\": \"MeskelSquare\"}}";
  @override
  void initState() {
    super.initState();
    anim = AnimationController(vsync: this, duration: Duration(seconds: 2))
      ..repeat();
    check().whenComplete(() {
      Navigator.pushReplacementNamed(context, homeRoute);
      anim.stop();
    });
  }

  Future<void> check() async {
    await new Future.delayed(const Duration(seconds: 4));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("loggedin") == null || prefs.getInt("loggedin") == 0) {
      prefs.setInt("loggedin", 1);
      prefs.setString("Challenges", json);
      prefs.setStringList("solved", []);
    }
  }

  @override
  void dispose() {
    anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Text(
              "Finding Sheger",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.amber,
                  shadows: [
                    Shadow(
                        blurRadius: 21,
                        color: Colors.amber,
                        offset: Offset(0, 10))
                  ]),
            )),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: MediaQuery.of(context).size.width - 80,
                  child: Image.asset(logoURl, fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotationTransition(
                    turns: anim,
                    alignment: Alignment.center,
                    child: Container(height: 70, child: Image.asset(adeyAbeba)),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RotationTransition(
                    turns: anim,
                    alignment: Alignment.center,
                    child: Container(height: 70, child: Image.asset(adeyAbeba)),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RotationTransition(
                    turns: anim,
                    alignment: Alignment.center,
                    child: Container(height: 70, child: Image.asset(adeyAbeba)),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            Center(
                child: Text(
              "Loading ...",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.amber,
                  shadows: [
                    Shadow(
                        blurRadius: 21,
                        color: Colors.amber,
                        offset: Offset(0, 10))
                  ]),
            )),
          ],
        ),
      ),
    ));
  }
}
