
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:untitled31/a/add.dart';

import 'package:untitled31/a/jjim.dart';
import 'package:untitled31/a/myboard.dart';
import 'package:untitled31/a/postcards.dart';
import 'package:untitled31/a/splash.dart';
import 'package:untitled31/a/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled31/a/signin.dart';
import 'package:untitled31/a/signup.dart';
import 'package:untitled31/a/home.dart';
import 'package:untitled31/a/profile.dart';
import 'package:untitled31/a/profile_edit.dart';
import 'package:untitled31/a/albums.dart';
import 'package:untitled31/a/goods.dart';



void main() => runApp(FFApp());


class FFApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter & Firebase',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),

      initialRoute: SplashPage.routeName,
      routes: {
        AuthPage.routeName: (context) => AuthPage(),
        SignInPage.routeName: (context) => SignInPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
        '/b': (context) => postcards(),
        '/c': (context) => goods(),
        '/d': (context) => albums(),
        '/f': (context) => jjim(),
        '/g': (context) => myboard(),
        '/Add':(context)=> Add()


      },
      onGenerateRoute: (settings) {



        switch (settings.name) {

          case HomePage.routeName: {
            return MaterialPageRoute(
                builder: (context) => HomePage(user: settings.arguments)
            );
          } break;



          case ProfilePage.routeName: {
            return MaterialPageRoute(
                builder: (context) => ProfilePage(user: settings.arguments)
            );
          } break;

          case ProfileEditPage.routeName: {
            return MaterialPageRoute(
                builder: (context) => ProfileEditPage(user: settings.arguments)
            );
          } break;

          default: {
            return MaterialPageRoute(
                builder: (context) => SplashPage()
            );
          } break;

        }

      },
    );
  }
}