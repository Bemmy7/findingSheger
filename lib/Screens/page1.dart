import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/Global/Global.dart';
import 'package:project/Routes/RouteConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class QuestionPage extends StatefulWidget {
  @override
  _Page1 createState() => _Page1();
}

class TextBox {
  final int index;
  String elm = "";
  TextBox(this.index);
  final _textController = TextEditingController();
  Widget getBox() {
    return Container(
      padding: EdgeInsets.all(3),
      width: 50,
      height: 50,
      decoration: BoxDecoration(border: Border.all()),
      child: Center(
          child: TextField(
        onChanged: (value) => elm = value.length == 1 ? "" : value,
        decoration: InputDecoration(
          counterText: "",
          border: null,
        ),
        controller: _textController,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        textAlign: TextAlign.center,
        textCapitalization: TextCapitalization.characters,
        maxLength: 1,
      )),
    );
  }
}

class _Page1 extends State<QuestionPage> with TickerProviderStateMixin {
  //Dart variables
  String input = "";
  List<String> ans = new List();
  String answer, imageUrl;

  int currentIndex;
  int totalQuestions;
  bool reset = true;
  bool popup = false;
  bool nogames = false;
  bool game = false;

  //Flutter Variables
  final textController = TextEditingController();
  final inputController = TextEditingController();
  TextStyle style = TextStyle(fontWeight: FontWeight.bold, fontSize: 30);
  List<Widget> list = new List();
  AnimationController anim, anim1, animPositioned;
  Animation<Offset> _offsetAnimation;

  //Methods||Functions
  double aspect(double full, int decrasePercent) {
    return (full * decrasePercent) / 100;
  }

  List<Widget> getlist(String answer, List<String> ans) {
    if (reset) {
      reset = false;
      answer = answer.toUpperCase();
      ans.clear();
      list.clear();
      for (int i = 0; i < answer.length; i++) {
        ans.add("");
        list.add(textBox(i, ans));
      }
    }
    return list;
  }

  //Widgets
  Widget textBox(int index, List<String> ans) {
    TextEditingController _textController;
    return Container(
      padding: EdgeInsets.all(3),
      width: 40,
      height: 40,
      decoration: BoxDecoration(border: Border.all()),
      child: Center(
          child: TextField(
        onChanged: (value) {
          setState(() {
            ans.replaceRange(index, index + 1, [value]);

            print(ans[index]);
          });
        },
        decoration: InputDecoration(
          counterText: "",
          border: null,
        ),
        controller: _textController,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        textAlign: TextAlign.center,
        textCapitalization: TextCapitalization.characters,
        maxLength: 1,
      )),
    );
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = jsonDecode(prefs.getString("Challenges"));
    List<String> solved = prefs.getStringList("solved");
    print(json["1"]["index"]);
    setState(() {
      totalQuestions = json["total"];
    });
    int n = 0;
    for (int i = 0; i < solved.length; i++) {
      n = int.parse(solved[i]);
    }
    print(solved.length);
    n += 1;
    if (solved.length < 2) {
      answer = json[n.toString()]["answer"];
      currentIndex = json[n.toString()]["index"];
      imageUrl = json[n.toString()]["imageUrl"];
      setState(() {
        game = true;
      });
    } else {
      setState(() {
        nogames = true;
      });
    }
  }

  Future<void> addSolved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> solved = prefs.getStringList("solved");
    solved.add(currentIndex.toString());
    prefs.setStringList("solved", solved);
  }

  Future<void> resetPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> solved = [];
    prefs.setStringList("solved", solved);
  }

  void validateSubmision() async {
    String submitted = "";
    print(ans);
    // ans.replaceRange(0, 1, ["w"]);
    for (int i = 0; i < ans.length; i++) {
      submitted += ans[i];
    }
    if (answer.toUpperCase() == submitted.toUpperCase()) {
      addSolved();
      setState(() {
        popup = true;
      });
    } else {
      animPositioned.repeat(reverse: true);
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate();
      }
      await new Future.delayed(const Duration(milliseconds: 200))
          .whenComplete(() => animPositioned.stop());
      // ;
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    anim = AnimationController(vsync: this, duration: Duration(seconds: 2))
      ..repeat();
    anim1 = AnimationController(vsync: this, duration: Duration(seconds: 2))
      ..repeat();

    animPositioned = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0.0),
    ).animate(CurvedAnimation(
      parent: animPositioned,
      curve: Curves.elasticInOut,
    ));
  }

  @override
  void dispose() {
    anim.dispose();
    animPositioned.dispose();
    super.dispose();
  }

  Widget popupScreen() {
    if (popup) {
      anim..repeat();
      return Container(
        color: Colors.black54,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                elevation: 4,
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width - 30,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Column(children: [
                          Text(
                            "Congratulations!!",
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w800,
                                color: Color(0xff41444b)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "You Win!",
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w800,
                                color: Color(0xff52575d)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RotationTransition(
                            turns: anim1,
                            alignment: Alignment.center,
                            child: Container(
                                height: 70, child: Image.asset(adeyAbeba)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "You Have won 1Br",
                            style:
                                TextStyle(fontSize: 25, color: Colors.black54),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ]),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Material(
                color: Color(0xff52de97),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  splashColor: Color(0xfff6f4e6),
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      popup = false;
                      reset = true;
                    });
                    Navigator.pushReplacementNamed(context, homeRoute);
                  },
                  child: Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width - 80,
                    child: Center(
                      child: Text(
                        "Play More",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: Color(0xfff6f4e6)),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )),
      );
    } else {
      anim..stop();
      return Text("");
    }
  }

  Widget popupScreenStayTuned() {
    if (nogames) {
      anim..repeat();
      return Container(
        color: Color(0xfffddb3a),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                elevation: 4,
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width - 30,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Column(children: [
                          Text(
                            "Stay Tuned",
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w800,
                                color: Color(0xff41444b)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RotationTransition(
                            turns: anim,
                            alignment: Alignment.center,
                            child: Container(
                                height: 70, child: Image.asset(adeyAbeba)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "More Challenges Will Come Soon",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 25, color: Colors.black54),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ]),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Material(
                color: Color(0xff52de97),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  splashColor: Color(0xfff6f4e6),
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    resetPrefs();
                    Navigator.pushReplacementNamed(context, homeRoute);
                  },
                  child: Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width - 80,
                    child: Center(
                      child: Text(
                        "Play Again",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: Color(0xfff6f4e6)),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )),
      );
    } else {
      anim..stop();
      return Text("");
    }
  }

  Widget gameMenu() {
    if (game) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                child: Text(
                  "Challenge $currentIndex/$totalQuestions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.black45),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(11),
                        onTap: () => print("ss"),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          height:
                              aspect(MediaQuery.of(context).size.height, 40),
                          child: Icon(Icons.chevron_left),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        elevation: 4,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, fullscreenImagePageRoute,
                              arguments: [imageUrl, currentIndex]),
                          child: Hero(
                            tag: "image",
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: aspect(
                                  MediaQuery.of(context).size.height, 40),
                              height: aspect(
                                  MediaQuery.of(context).size.height, 40),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  imageUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(11),
                        onTap: () => print("ss"),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          height:
                              aspect(MediaQuery.of(context).size.height, 40),
                          child: Icon(Icons.chevron_right),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                // padding: EdgeInsets.all(5),
                child: Wrap(
                  runSpacing: 10,
                  spacing: 5,
                  children: getlist(answer, ans),
                ),
              ),
              SizedBox(
                height: 33,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: SlideTransition(
                    position: _offsetAnimation,
                    child: Container(
                      height: 80,
                      width: 80,
                      child: Material(
                        borderRadius: BorderRadius.circular(50),
                        color: Color(0xFFfddb3a),
                        child: InkWell(
                          onTap: () => validateSubmision(),
                          borderRadius: BorderRadius.circular(50),
                          splashColor: Color(0xFF41444b),
                          child: Center(
                              child: Text(
                            "GO!",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF41444b)),
                          )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // SlideTransition(
              //     position: _offsetAnimation,
              //     child: Container(
              //       height: 50,
              //       width: 50,
              //       color: Colors.red,
              //     ))
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Text(""),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff6f4e6),
        appBar: AppBar(
          backgroundColor: Color(0xfff2d863),
          elevation: 5,
          leading: Padding(
              padding: EdgeInsets.all(7),
              child: Material(
                borderRadius: BorderRadius.circular(50),
                color: Colors.transparent,
                elevation: 5,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      logoURl, //Rotate animation on touch
                    )),
              )),
          title: Center(
              child: Text(
            "Finding Sheger",
            style: TextStyle(),
          )),
        ),
        body: Stack(
            children: [gameMenu(), popupScreen(), popupScreenStayTuned()]),
      ),
    );
  }
}
