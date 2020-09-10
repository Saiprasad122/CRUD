import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class HomeScreeen2 extends StatelessWidget {
  const HomeScreeen2({Key key, FirebaseUser user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignIn signIn = SignIn();
    return Scaffold(
      appBar: AppBar(
        title: Text("HomeScreen Number"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            signIn.numberLogout();
            Navigator.pushReplacementNamed(context, '/');
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}
