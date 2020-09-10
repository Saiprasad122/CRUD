import 'package:flutter/material.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SignIn signIn = SignIn();
    UserData args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("HomeScreen"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image(image: NetworkImage(args.url)),
            Text(args.email),
            Text(args.name),
            RaisedButton(
              onPressed: () {
                signIn.signoutGoogle();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              child: Text("SignOut"),
            ),
          ],
        ),
      ),
    );
  }
}
