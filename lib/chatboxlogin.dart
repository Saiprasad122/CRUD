import 'package:flutter/material.dart';
import 'main.dart';

class ChatBoxLogin extends StatefulWidget {
  ChatBoxLogin({Key key}) : super(key: key);

  @override
  _ChatBoxLoginState createState() => _ChatBoxLoginState();
}

class _ChatBoxLoginState extends State<ChatBoxLogin> {
  @override
  Widget build(BuildContext context) {
    SignIn signIn = SignIn();
    return Scaffold(
        body: Center(
      child: RaisedButton(
        onPressed: () {
          signIn.signiwthGoogle().whenComplete(() {
            Navigator.pushNamed(context, '/ChatBoxHome',
                arguments:
                    UserData(signIn.name, signIn.email, signIn.imageurl));
          });
        },
        child: Text("Login With Google"),
      ),
    ));
  }
}
