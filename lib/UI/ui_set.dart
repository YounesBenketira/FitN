import 'package:flutter/material.dart';

class SetUI extends StatelessWidget {
  final int rep;
  final int weight;

  SetUI({this.rep, this.weight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Container(
        width: 45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                "$rep",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 6),
              child: Container(
                color: Colors.white,
                height: 1.5,
              ),
            ),
            Center(
              child: Text(
                "$weight",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SetUI_S extends StatelessWidget {
  final int rep;
  final int weight;

  SetUI_S({this.rep, this.weight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Container(
        width: 45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                child: Center(
              child: Text(
                "$rep",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(left: 6, right: 6, bottom: 1),
              child: Container(
                color: Colors.white,
                height: 1,
              ),
            ),
            Expanded(
                child: Center(
              child: Text(
                "$weight",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
