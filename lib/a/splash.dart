
import 'package:flutter/material.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);
  static const routeName = '/';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _routePage();
  }

  _routePage () async {
    await Future.delayed(Duration(seconds: 4));
    return Navigator.pushReplacementNamed(context, '/auth');
  }

  Widget _buildBody() {
    return Container(
      color: Colors.deepPurple,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('fodo', style: TextStyle(fontSize: 40,color: Colors.white)),
            Text('loading...', style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }
}