import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/drawerTile.dart';

Widget _buildBackground() {
  return Container(
    color: Colors.blueGrey[900],
  );
}

class CustomDrawer extends StatelessWidget {

  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildBackground(),
          ListView(
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColor,
                margin: EdgeInsets.only(bottom: 10),
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.face,
                      color: Theme.of(context).accentColor,
                      size: 26,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Flutter's",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    Text(
                      " Fashion",
                      style: TextStyle(
                          color: Colors.blueGrey[300],
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              DrawerTile(Icons.home, 'Home', pageController, 0),
              DrawerTile(Icons.list, 'Produtos', pageController, 1),
              DrawerTile(Icons.location_on, 'Lojas', pageController, 2),
              DrawerTile(Icons.playlist_add_check, 'Meus pedidos', pageController, 3)
            ],
          ),
        ],
      ),
    );
  }
}
