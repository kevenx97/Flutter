import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=ea2030c8';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

Widget buildTextField(String _label, String _prefix,
  TextEditingController _controller, Function _onChange) {
  return TextField(
    decoration: InputDecoration(
      labelStyle: TextStyle(color: Colors.amber),
      labelText: _label,
      prefixText: _prefix,
      border: OutlineInputBorder(),
    ),
    style: TextStyle(color: Colors.white, fontSize: 18),
    onChanged: _onChange,
    controller: _controller,
  );
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void onChangeReal(text) {
    double real = double.parse(text);
    realController.text = (real * this.dolar).toStringAsFixed(2);
    realController.text = (real * this.euro).toStringAsFixed(2);
  }

  void onChangeDolar(text) {
    realController.text = (euro * this.dolar).toStringAsFixed(2);
    realController.text = (euro * this.dolar / dolar).toStringAsFixed(2);
  }

  void onChangeEuro(text) {
    realController.text = (euro * this.euro).toStringAsFixed(2);
    realController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: Text('\$ Conversor \$', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'Carregando Dados...',
                  style: TextStyle(color: Colors.amber, fontSize: 18),
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao Carregar Dados :(',
                    style: TextStyle(color: Colors.amber, fontSize: 18),
                  ),
                );
              } else {
                euro = snapshot.data['results']['currencies']['EUR']['buy'];
                dolar = snapshot.data['results']['currencies']['USD']['buy'];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          color: Colors.amber, size: 80),
                      Divider(height: 16),
                      buildTextField(
                          'Reais', 'R\$', realController, onChangeReal),
                      Divider(),
                      buildTextField(
                          'Dólares', 'US\$', dolarController, onChangeReal),
                      Divider(),
                      buildTextField(
                          'Dólares', '€', euroController, onChangeReal),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
