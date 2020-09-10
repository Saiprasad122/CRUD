import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_real/CRUDreal.dart';
import 'package:google_sign_real/ChatBoxHome.dart';
import 'package:google_sign_real/HomeScereen2.dart';
import 'package:google_sign_real/HomeScreen.dart';
import 'package:google_sign_real/chatboxlogin.dart';
import 'package:vibration/vibration.dart';
import 'package:connectivity/connectivity.dart';

// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/HomeScreen': (context) => HomeScreen(),
      '/HomeScreen2': (context) => HomeScreeen2(),
      '/ChatBoxLogin': (context) => ChatBoxLogin(),
      '/ChatBoxHome': (context) => ChatBoxHome(),
    },
  ));
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ConnectivityResult connectionStatus;
  String mobilenum = "";
  String code = "";
  SignIn signIn = SignIn();
  @override
  Widget build(BuildContext context) {
    Future<ConnectivityResult> chechInternet() async {
      var result = await Connectivity().checkConnectivity();
      return result;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                signIn.signiwthGoogle().whenComplete(() => {
                      Navigator.pushNamed(context, '/HomeScreen',
                          arguments: UserData(
                              signIn.name, signIn.email, signIn.imageurl))
                    });
              },
              child: Text("Sign in with Google"),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (text) {
                mobilenum = "+91" + text;
              },
              decoration: InputDecoration(
                  hintText: "Enter mobile number",
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 5.0,
            ),
            RaisedButton(
              onPressed: () {
                signIn.verifyuser(mobilenum, context);
              },
              child: Text("Submit"),
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/ChatBoxLogin');
              },
              child: Text("Click to go Chat Box Login Page"),
            ),
            RaisedButton(
              child: Text("CRUD real"),
              onPressed: () async {
                connectionStatus = await chechInternet();
                if (connectionStatus == ConnectivityResult.none) {
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("No Intenet Connection"),
                          content: Text("Please Connect to Internet and retry"),
                          actions: [
                            RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            )
                          ],
                        );
                      });
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CRUDreal()));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SignIn {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String name;
  String email;
  String imageurl;
  String phonenum;
  String smsOTP;
  String verificationId;
  String smscode = "";
  Future<void> signiwthGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    name = user.displayName;
    email = user.email;
    imageurl = user.photoUrl;
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }
  }

  void signoutGoogle() async {
    await _googleSignIn.signOut();
  }

  Future verifyuser(String mobile, BuildContext context) async {
    _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 120),
        verificationCompleted: (AuthCredential authCredential) {
          _auth
              .signInWithCredential(authCredential)
              .then((AuthResult authResult) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreeen2(
                          user: authResult.user,
                        )));
          }).catchError((e) {
            print(e);
          });
        },
        verificationFailed: (AuthException authException) {
          print(authException.message);
        },
        codeSent: (String verid, [int forceCodeRespond]) {
          this.verificationId = verid;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Enter SMS code"),
              content: TextField(
                onChanged: (value) => smscode = value,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Done"),
                  onPressed: () {
                    try {
                      _auth.currentUser().then((user) async {
                        if (user != null) {
                          Navigator.of(context).pop();
                          Navigator.pushReplacementNamed(
                              context, '/HomeScreen2');
                        } else {
                          try {
                            AuthCredential authCredential =
                                PhoneAuthProvider.getCredential(
                                    verificationId: verificationId,
                                    smsCode: smscode);
                            AuthResult authResult = await _auth
                                .signInWithCredential(authCredential);
                            FirebaseUser user = authResult.user;
                            FirebaseUser currentuser =
                                await _auth.currentUser();

                            assert(user.uid == currentuser.uid,
                                "print-------------------");
                            Navigator.of(context).pop();
                            Navigator.pushReplacementNamed(
                                context, '/HomeScreen2');
                          } catch (e) {
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Invalid OTP!!"),
                                      content: Text("Please try again"),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("OK"))
                                      ],
                                    ));
                            Vibration.vibrate();
                          }
                        }
                      });
                    } catch (e) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ).then((value) => print("Sign in hua h----------"));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("TimeOut");
        });
  }

  void numberLogout() async {
    await FirebaseAuth.instance.signOut();
    print("User sign out");
  }
}

class UserData {
  String name;
  String email;
  String url;

  UserData(this.name, this.email, this.url);
}
