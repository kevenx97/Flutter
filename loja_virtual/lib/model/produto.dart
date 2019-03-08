import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  String produtos;
  String id;
  String titulo;
  String descricao;
  String preco;
  List imagens;
  List tamanhos;

  Produto.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    titulo = snapshot.data['titulo'];
    descricao = snapshot.data['descricao'];
    preco = snapshot.data['preco'];
    imagens = snapshot.data['imagens'];
    tamanhos = snapshot.data['tamanhos'];
  }

}