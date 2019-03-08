import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/home_tab.dart';
import 'package:loja_virtual/tabs/produtos_tab.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  final _pageViewController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageViewController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          drawer: CustomDrawer(_pageViewController),
          body: HomeTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Produtos'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          drawer: CustomDrawer(_pageViewController),
          body: ProdutosTab(),
        ),
      ],
    );
  }
}
