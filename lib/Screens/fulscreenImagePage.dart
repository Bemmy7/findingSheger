import 'package:flutter/material.dart';

class FullScreenPage extends StatefulWidget {
  final List sas;
  const FullScreenPage({Key key, this.sas}) : super(key: key);
  @override
  _FullScreenPage createState() => _FullScreenPage(sas);
}

class _FullScreenPage extends State<FullScreenPage> {
  final List list;

  _FullScreenPage(this.list);
  @override
  Widget build(BuildContext context) {
    int index = list[1];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfff2d863),
          elevation: 5,
          title: Center(
              child: Text(
            "Challenge #$index",
            style: TextStyle(),
          )),
        ),
        backgroundColor: Color(0xfffddb3a),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: Hero(
                  tag: "image",
                  child: Material(
                    color: Colors.transparent,
                    child: Image.asset(
                      list[0],
                      fit: BoxFit.contain,
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
