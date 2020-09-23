import 'package:fit_k/Logic/auth.dart';
import 'package:fit_k/Logic/profile.dart';
import 'package:fit_k/Pages/page_profile_home.dart';
import 'package:fit_k/Pages/page_profile_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
  final BaseAuth auth;

  ProfilePage({Key key, this.auth}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

enum AuthStatus { notSignedIn, signedIn, beforeChecked }

class _ProfilePageState extends State<ProfilePage> {
  AuthStatus _authStatus = AuthStatus.beforeChecked;
  Profile currentUserProfile;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    widget.auth.currentUserID().then((onValue) {
      setState(() {
        _authStatus =
            onValue == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
    super.initState();
  }

  void _signedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return new LoggedInPage(
          auth: widget.auth,
          onSignedOut: _signOut,
        );
      case AuthStatus.beforeChecked:
        return Container();
        break;
    }
  }
}
