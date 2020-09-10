import 'package:flutter/material.dart';
import 'main.dart';

class ChatBoxHome extends StatefulWidget {
  ChatBoxHome({Key key}) : super(key: key);

  @override
  _ChatBoxHomeState createState() => _ChatBoxHomeState();
}

class _ChatBoxHomeState extends State<ChatBoxHome> {
  @override
  Widget build(BuildContext context) {
    // SignIn signIn = SignIn();
    UserData args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Box Home"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Image(
              image: NetworkImage(args.url),
              width: 35.0,
              height: 35.0,
            ),
            shape: StadiumBorder(),

            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(100)),
          )
        ],
      ),
      body: Text("Home Page"),
    );
  }
}
