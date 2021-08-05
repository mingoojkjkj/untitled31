import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:untitled31/a/add.dart';





class postcards extends StatefulWidget {
  const postcards({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _postcardsState createState() => _postcardsState();
}

class _postcardsState extends State<postcards> {




  void _incrementCounter() {
    //쓰기로 이동
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Add()),
      );
    });
  }



  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        title: Text('postcards'),
        backgroundColor: Colors.deepPurple,


      ),
      body: Text('phtocards'),
    floatingActionButton: FloatingActionButton(
    onPressed: _incrementCounter,
    tooltip: '글쓰기',
    child: Icon(Icons.add),





    ));

  }
}
