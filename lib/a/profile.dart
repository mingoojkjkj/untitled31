import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key, this.user}) : super(key: key);
  static const routeName = '/profile';
  final FirebaseUser user;

  Widget _buildCard(BuildContext context) {
    return Container(

        child:Column(
          children:<Widget>[Row(

            children: <Widget>[
              Container(padding: EdgeInsets.fromLTRB(25, 25, 25, 30),
                child: CircleAvatar(radius: 50, child: Image.network(user.photoUrl)),
              ),

              Column(
                  children:<Widget>[
                    Container(padding: EdgeInsets.only(top: 20),child: Text(user.displayName,
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,
                          color: Colors.black),),),
                    Container(padding: EdgeInsets.only(top: 50.0),width: 100,height: 5,color: Colors.deepPurple,),
                     ] ),




            ],
          ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color:Colors.pink[100],
                  child: Text('jjim'),
                  onPressed: (){
                    Navigator.pushNamed(context, '/f');
                  },),

                RaisedButton(
                    color:Colors.lightBlueAccent[100],
                    child: Text('my board'),
                    onPressed: (){
                      Navigator.pushNamed(context, '/g');
                    })

              ],
            ),





          ],)


    );
  }

  Widget _buildSignOut(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          child: Text('Sign out'),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
            // Navigator.pushReplacementNamed(context, '/auth');
          },
        )
      ],
    );
  }
  Widget _buildList(BuildContext context){
    return Card(
      child:  ListTile(
          leading:  Icon(Icons.check, color: Colors.grey[850],),
          title: Text('notice')
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildCard(context),
            _buildSignOut(context),
          _buildList(context)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'),backgroundColor: Colors.deepPurple),
      body: _buildBody(context),
    );
  }
}



