
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled31/a/profile.dart';
import '../../models/user.dart';
import '../../widgets/loading.dart';
import '../../widgets/message.dart';




class HomePage extends StatelessWidget {
  const HomePage({Key key, this.user}) : super(key: key);
  static const routeName = '/home';
  final FirebaseUser user;


  Widget _buildProfile(context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
        child:
        CircleAvatar(

          backgroundColor: Colors.white,
        ),
        onTap: () {
          Navigator.pushNamed(context, '/profile', arguments: user);
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HomePage'),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            _buildProfile(context),
          ],
        ),

        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  color:Colors.deepPurple,
                  child: Text('post card'),
                  onPressed: (){
                    Navigator.pushNamed(context, '/b');
                  }),

              RaisedButton(
                  color:Colors.deepPurple,
                  child: Text('goods'),
                  onPressed: (){
                    Navigator.pushNamed(context, '/c');
                  }),
              RaisedButton(
                  color:Colors.deepPurple,
                  child: Text('albums'),
                  onPressed: (){
                    Navigator.pushNamed(context, '/d');
                  }),



            ],



          ),
        ));

  }
}
