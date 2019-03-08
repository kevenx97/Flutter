import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  DrawerTile(this.icon, this.text, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          this.controller.jumpToPage(page);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          child: Row(
            children: <Widget>[
              Icon(icon, color: page == this.controller.page.round() ? Theme.of(context).accentColor : Theme.of(context).iconTheme.color), 
              SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(color: page == this.controller.page.round() ? Theme.of(context).accentColor : Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
