import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Home(), theme: ThemeData(hintColor: Colors.white)));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();

  String descricao = 'info';

  void _resetFields() {
    pesoController.text = '';
    alturaController.text = '';

    setState(() {
      descricao = '';
    });
  }

  void _calcularImc() {
    double peso = double.parse(pesoController.text);
    double altura = double.parse(alturaController.text);
    double imc = peso / (altura * altura);

    setState(() {
      if (imc < 18.6 && imc < 24.9) {
        descricao = 'Abaixo do Peso (${imc.toStringAsPrecision(3)})';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          title: Text('Calculadora IMC'),
          backgroundColor: Colors.grey[800],
          actions: <Widget>[
            IconButton(onPressed: _resetFields, icon: Icon(Icons.refresh))
          ],
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Form(
              key: _keyForm,
              child: Column(
                children: <Widget>[
                  Icon(Icons.person, size: 100, color: Colors.white),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(labelText: 'Peso (kg)'),
                    controller: pesoController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Digite o seu peso!';
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(labelText: 'Altura (cm)'),
                    controller: alturaController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Digite a sua altura';
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Container(
                        height: 40,
                        child: RaisedButton(
                            onPressed: () {
                              if (_keyForm.currentState.validate()) {
                                _calcularImc();
                              }
                            },
                            color: Colors.blue,
                            child: Text('Calcular',
                                style: TextStyle(color: Colors.white)))),
                  ),
                  Text('$descricao', style: TextStyle(color: Colors.amber))
                ],
              ),
            )));
  }
}
