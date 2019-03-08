import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  CustomButton({@required this.onPressed});

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      fillColor: Colors.deepOrange,
      splashColor: Colors.orange,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.check_circle, color: Colors.amber),
            SizedBox(width: 8),
            Text('Toasted', style: TextStyle(color: Colors.white)),
          ],
        )
      ),
      shape: StadiumBorder(),
    );
  }
}