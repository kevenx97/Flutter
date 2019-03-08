import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _lista = [];
  final _controllerTarefa = TextEditingController();

  Map<String, dynamic> _ultimaTarefaRemovida = Map();
  int _ultimaPosicaoTarefaRemovida;

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _lista = json.decode(data);
      });
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  Future<File> _saveData() async {
    String tarefas = json.encode(_lista);
    final file = await _getFile();
    return file.writeAsString(tarefas);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  void _addItemLista() {
    setState(() {
      Map<String, dynamic> novaLista = Map();
      novaLista['text'] = _controllerTarefa.text;
      novaLista['value'] = false;
      _controllerTarefa.text = '';
      _lista.add(novaLista);
      _saveData();
    });
  }

  Widget itemBuilder(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: CheckboxListTile(
        title: Text(_lista[index]['text']),
        value: _lista[index]['value'],
        onChanged: (check) {
          setState(() {
            _lista[index]['value'] = check;
            _saveData();
          });
        },
        secondary: CircleAvatar(
          child: Icon(_lista[index]['value'] ? Icons.check : Icons.error),
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _ultimaTarefaRemovida = Map.from(_lista[index]);
          _ultimaPosicaoTarefaRemovida = index;
          _lista.removeAt(index);
          _saveData();

          final snackbar = SnackBar(
            content:
                Text("Tarefa \"${_ultimaTarefaRemovida['text']}\" removida!"),
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Desfazer',
              onPressed: () {
                setState(() {
                  _lista.insert(
                      _ultimaPosicaoTarefaRemovida, _ultimaTarefaRemovida);
                  _saveData();
                });
              },
            ),
          );

          Scaffold.of(context).showSnackBar(snackbar);
        });
      },
    );
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _lista.sort((a, b) {
        if (a['value'] && !b['value']) return 1;
        else if (!a['value'] && b['value']) return 1;
        else return 0;
      });

      _saveData();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(7),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controllerTarefa,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blue, fontSize: 16),
                      labelText: 'Tarefa',
                    ),
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    _addItemLista();
                  },
                  shape: CircleBorder(),
                  fillColor: Colors.blueAccent,
                  splashColor: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      width: 35,
                      height: 35,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemCount: _lista.length,
                  itemBuilder: itemBuilder),
            ),
          ),
        ],
      ),
    );
  }
}
