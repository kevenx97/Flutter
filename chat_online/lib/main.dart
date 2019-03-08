import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  runApp(MyApp());
}

final ThemeData kIOSTheme = ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);

final ThemeData kDefaultTheme = ThemeData(
    primaryColor: Colors.purple, accentColor: Colors.orangeAccent[700]);

final googleSignIn = GoogleSignIn();
final auth = FirebaseAuth.instance;

Future<Null> _ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null) {
    user = await googleSignIn.signInSilently();
  }
  if (user == null) {
    user = await googleSignIn.signIn();
  }
  if (await auth.currentUser() == null) {
    GoogleSignInAuthentication credentials =
        await googleSignIn.currentUser.authentication;
    await auth.signInWithGoogle(
        idToken: credentials.idToken, accessToken: credentials.accessToken);
  }
}

_handleSubmited(String text) async {
  await _ensureLoggedIn();
  _sendMessage(text: text);
}

void _sendMessage({String text, String imgUrl}) {
  Firestore.instance.collection('messages').add({
    'text': text,
    'imgUrl': imgUrl,
    'senderName': googleSignIn.currentUser.displayName,
    'senderPhotoUrl': googleSignIn.currentUser.photoUrl
  });
}

void _uploadImage() async {
  await _ensureLoggedIn();
  File imgFile = await ImagePicker.pickImage(source: ImageSource.camera);
  if (imgFile != null) {
    StorageUploadTask task = FirebaseStorage.instance
        .ref()
        .child(googleSignIn.currentUser.id.toString() +
            DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(imgFile);
    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();
    _sendMessage(imgUrl: url);
  }
}

bool _typing = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).platform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat Online'),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                  stream: Firestore.instance.collection('messages').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        return ListView.builder(
                          reverse: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            List reverseList =
                                snapshot.data.documents.reversed.toList();
                            return ChatMessage(reverseList[index].data);
                          },
                        );
                    }
                  }),
            ),
            Divider(height: 1),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: TextComposer(),
            )
          ],
        ),
      ),
    );
  }
}

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final _textController = TextEditingController();

  void _reset() {
    _textController.clear();
    setState(() {
      _typing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200]),
                ),
              )
            : null,
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: _uploadImage,
                icon: Icon(Icons.camera_alt),
              )
            ),
            Expanded(
              child: TextField(
                  controller: _textController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Enviar uma mensagem',
                  ),
                  onChanged: (text) {
                    setState(() {
                      _typing = text.length > 0;
                    });
                  },
                  onSubmitted: (text) {
                    _handleSubmited(text);
                    _reset();
                  }),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _typing
                          ? () {
                              _handleSubmited(_textController.text);
                              _reset();
                            }
                          : null,
                    )
                  : IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _typing
                          ? () {
                              _handleSubmited(_textController.text);
                              _reset();
                            }
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;

  ChatMessage(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
                backgroundImage: NetworkImage(data['senderPhotoUrl'])),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data['senderName'],
                  style: Theme.of(context).textTheme.subhead,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: data['imgUrl'] != null
                      ? Image.network(
                          data['imgUrl'],
                          width: 250,
                        )
                      : Text(
                          data['text'],
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
