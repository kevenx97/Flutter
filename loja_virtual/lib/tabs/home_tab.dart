import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildBackgound() {
      return Container(
        color: Colors.blueGrey[900],
      );
    }

    return Stack(
      children: <Widget>[
        _buildBackgound(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              snap: true,
              elevation: 4,
              floating: true,
              backgroundColor: Colors.blueGrey[900],
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Novidades',
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection('home')
                  .orderBy('pos')
                  .getDocuments(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                } else {
                  print(snapshot.data.documents[0]);
                  return SliverStaggeredGrid.count(
                    crossAxisCount: 2,
                    staggeredTiles: snapshot.data.documents.map<StaggeredTile>(
                      (image) {
                        return StaggeredTile.count(
                          image.data['x'],
                          image.data['y'],
                        );
                      },
                    ).toList(),
                    children: snapshot.data.documents.map<Widget>((doc) {
                      return FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: doc.data['image'],
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  );
                }
              },
            )
          ],
        )
      ],
    );
  }
}
