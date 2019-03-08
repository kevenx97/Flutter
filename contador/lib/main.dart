import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Contador de Pessoas',
    home: Home()
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _people = 0;

  void changeOnPeople (int delta) {

    setState(() {
      _people += delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'images/bg.jpg',
          fit: BoxFit.cover,
          height: 1000,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pessoas: $_people',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FlatButton(
                    onPressed: () {
                      changeOnPeople(1);
                    },
                    child: Text(
                        '+1',
                        style: TextStyle(color: Colors.white, fontSize: 20)
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FlatButton(
                    onPressed: () {
                      changeOnPeople(-1);
                    },
                    child: Text(
                      '-1',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
            Text('Pode Entrar!',
                style: TextStyle(
                    color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic))
          ],
        ),
      ],
    );
  }
}

