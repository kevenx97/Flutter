import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProdutosTile extends StatelessWidget {

  final DocumentSnapshot snapshot;

  ProdutosTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data['imagem']),
      ),
      title: Text(snapshot.data['titulo'] ?? ''),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {},
    );
  }
}