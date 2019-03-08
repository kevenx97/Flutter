import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gifs/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _offset = 0;
  String _search = '';

  Future<Map> _getGifs() async {
    http.Response response;
    if (_search == '') {
      response = await http.get(
          'http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC&limit=10');
    } else {
      response = await http.get(
          'http://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q=$_search&limit=19&offset=$_offset');
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((gifs) {
      print(gifs);
    });
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: _getCount(snapshot.data['data']),
      itemBuilder: (context, index) {
        if (_search == '' || index <= snapshot.data['data'].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
              image: snapshot.data['data'][index]['images']
                  ['fixed_height_small']['url'],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GifPage(snapshot.data['data'][index]),
                ),
              );
            },
            onLongPress: () {
              Share.share(snapshot.data['data'][index]['images']
                  ['fixed_height_small']['url']);
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 50,
                  ),
                  Text(
                    'Adicionar mais...',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 9;
                });
              },
            ),
          );
        }
      },
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                labelText: 'Pesquise Aqui',
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container(
                        width: 0.0,
                        height: 0.0,
                        padding: EdgeInsets.all(10.0),
                      );
                    } else {
                      return _createGifTable(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
