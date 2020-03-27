import 'package:bagi_barang/services/authentication.dart';
import 'package:flutter/material.dart';

class LoginWithGooglePage extends StatefulWidget {
  LoginWithGooglePage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginWithGooglePage();
}

class _LoginWithGooglePage extends State<LoginWithGooglePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: OutlineButton(
          onPressed: () async {
            String userId = "";
            userId = await widget.auth.googleSignIn();
            if (userId.length > 0 && userId != null) {
              widget.loginCallback();
            }
          },
          child: Text("SignIn with Google"),
        ),
      ),
    );
  }
}
