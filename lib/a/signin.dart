
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../../methods/toast.dart';
import '../../methods/validators.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);
  static const routeName = '/signin';

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _googleSignIn () async {
    final bool isSignedIn = await GoogleSignIn().isSignedIn();
    GoogleSignInAccount googleUser;
    if (isSignedIn) googleUser = await GoogleSignIn().signInSilently();
    else googleUser = await GoogleSignIn().signIn();
    // await GoogleSignIn().signOut();
    // GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    // print("signed in " + user.displayName);
    return user;
  }

  _buildLoading() {
    return Center(child: CircularProgressIndicator(),);
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'eg) johndoe@xxx.com',
                  border: OutlineInputBorder(),
                ),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: emailValidator,
              ),
              // Container(height: 10,),
              SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'eg) very hard key',
                  border: OutlineInputBorder(),
                ),
                controller: passwordController,
                obscureText: true,
                validator: passwordValidator,
              ),
              SizedBox(height: 10,),
              SignInButton(
                Buttons.Email,
                onPressed: () async {
                  if (!_formKey.currentState.validate()) return;
                  try {
                    setState(() => _loading = true);
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    Navigator.pushReplacementNamed(context, '/auth');
                  } catch (e) {
                    toastError(_scaffoldKey, e);
                  } finally {
                    setState(() => _loading = false);
                  }
                },
              ),
              Text('or'),
              SignInButton(
                Buttons.Google,
                onPressed: () async {
                  try {
                    setState(() => _loading = true);
                    await _googleSignIn();
                    // Navigator.pushReplacementNamed(context, '/');
                    Navigator.pushReplacementNamed(context, '/auth');
                    // Navigator.pushReplacementNamed(context, '/home');
                  } catch (e) {
                    toastError(_scaffoldKey, e);
                  } finally {
                    setState(() => _loading = false);
                  }
                },
              ),
              SizedBox(height: 20,),
              Text("Don't have an account yet?"),
              FlatButton(
                child: Text('Sign up'),
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Sign in'), ),
        body: _loading ? _buildLoading() : _buildBody()
    );
  }
}