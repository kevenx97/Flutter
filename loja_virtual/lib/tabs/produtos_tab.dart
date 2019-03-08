import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/tiles/produtos_tile.dart';

class ProdutosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('produtos').getDocuments(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        else {
          return ListView(
           children: snapshot.data.documents.map<Widget>((doc) {
             return ProdutosTile(doc);
           }).toList(),
          );
        }
      },
    );
  }
}