import 'package:fit_k/Logic/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  LoginPage({Key key, this.auth, this.onSignedIn}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _confirmPassword;
  String _firstName;
  String _lastName;

  bool _emailExists = false;
  bool _validEmail = true;
  bool _correctPassword = true;

  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
//    print('Running!');
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userID =
              await widget.auth.signInWithEmailAndPassword(_email, _password);
          print("Signed in: $userID");
          formKey.currentState.reset();

          final snackBar = SnackBar(
            content: Text(
              'Logged In Successfully!',
//                            textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          );
          Scaffold.of(this.context).showSnackBar(snackBar);

          widget.onSignedIn();
        } else {
          String userID = await widget.auth.createUserWithEmailAndPassword(
              _email, _password, _firstName, _lastName);
          print("Created User: $userID");

          formKey.currentState.reset();

          final snackBar = SnackBar(
            content: Text(
              'Account Created Successfully!',
//                            textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          );
          Scaffold.of(this.context).showSnackBar(snackBar);

          setState(() {
            _formType = FormType.login;
          });
        }
      } catch (e) {
        switch (e.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
//            print("Email Already Exists!");
            setState(() {
              _emailExists = true;
            });
            validateAndSave();
            break;
          case "ERROR_INVALID_EMAIL":
          case "ERROR_USER_NOT_FOUND":
            setState(() {
              _validEmail = false;
            });
            validateAndSave();
            break;
          case "ERROR_WRONG_PASSWORD":
            setState(() {
              _correctPassword = false;
            });
            validateAndSave();
            break;
          default:
            print(e);
            break;
        }

        print("Error: $e");
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          children: [
            _buildProfileHeader(),
            _buildInputs(),
            _buildSubmitButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      height: 260,
      child: Stack(
        children: <Widget>[
          Container(
            // Background
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff17EAD9),
                  Color(0xff6078EA),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 45.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 25,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('images/User.png'),
                    radius: 45,
                  ),
                  Container(
                    height: 5,
                  ),
                  Text(
                    'Name',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: 'OpenSans'),
                  ),
                  Text(
                    'Exercises Done',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 15,
                        fontFamily: 'OpenSans'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputs() {
    switch (_formType) {
      case FormType.login:
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              new Container(
                height: 30,
              ),
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontSize: 17.5,
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty)
                    return 'Email can\'t be empty';
                  else {
                    if (!_validEmail) return 'Email doesn\'t exists!';
                    return null;
                  }
                },
                onSaved: (value) => _email = value.trim(),
                onChanged: (value) {
                  setState(() {
                    _validEmail = true;
                  });
                },
              ),
              new Container(
                height: 15,
              ),
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontSize: 17.5,
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty)
                    return "Password cannot be empty!";
                  else {
                    if (!_correctPassword) return "Invalid password!";
                    return null;
                  }
                },
                onSaved: (value) => _password = value,
                onChanged: (value) {
                  setState(() {
                    _correctPassword = true;
                  });
                },
              ),
              new Container(
                height: 20,
              ),
            ],
          ),
        );
        break;
      case FormType.register:
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              new Container(
                height: 30,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: new TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'First',
                        labelStyle: TextStyle(
                          fontSize: 17.5,
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'First Name can\'t be empty' : null,
                      onSaved: (value) => _firstName = value,
                    ),
                  ),
                  Container(
                    width: 15,
                  ),
                  Expanded(
                    child: new TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'Last',
                        labelStyle: TextStyle(
                          fontSize: 17.5,
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'Last Name can\'t be empty' : null,
                      onSaved: (value) => _lastName = value,
                    ),
                  ),
                ],
              ),
              new Container(
                height: 15,
              ),
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontSize: 17.5,
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty)
                    return 'Email can\'t be empty';
                  else {
                    if (_emailExists) return 'Email already exists!';
                    return null;
                  }
                },
                onSaved: (value) {
                  _email = value;
                },
                onChanged: (value) {
                  setState(() {
                    _emailExists = false;
                  });
                },
              ),
              new Container(
                height: 15,
              ),
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontSize: 17.5,
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty)
                    return 'Password can\'t be empty';
                  else {
                    if (_confirmPassword != _password) {
                      print("$_confirmPassword $_password");
                      return 'Passwords do not match!';
                    }
                    return null;
                  }
                },
                onChanged: (value) => _password = value,
                onSaved: (value) => _password = value,
              ),
              new Container(
                height: 15,
              ),
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(
                    fontSize: 17.5,
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty)
                    return 'Confirm Password can\'t be empty';
                  else {
                    if (_confirmPassword != _password)
                      return 'Passwords do not match!';
                    return null;
                  }
                },
                onChanged: (value) => _confirmPassword = value,
                onSaved: (value) => _confirmPassword = value,
              ),
              new Container(
                height: 20,
              ),
            ],
          ),
        );
        break;
    }
  }

  Widget _buildSubmitButtons() {
    if (_formType == FormType.login)
      return Column(
        children: <Widget>[
          Container(
            width: 200,
            height: 45,
            child: new RaisedButton(
              color: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: new Text(
                'Login',
                style: new TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              onPressed: validateAndSubmit,
            ),
          ),
          new Container(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "Don't have an account? ",
                textAlign: TextAlign.right,
                style: new TextStyle(fontSize: 17.5),
              ),
              new FlatButton(
                onPressed: moveToRegister,
                child: new Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 17.5, color: Colors.blueAccent),
                  textAlign: TextAlign.left,
                ),
              ),
              new Container(
                height: 20,
              ),
            ],
          ),
        ],
      );
    else
      return Column(
        children: <Widget>[
          Container(
            width: 200,
            height: 45,
            child: new RaisedButton(
              color: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: new Text(
                'Create Account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              onPressed: validateAndSubmit,
            ),
          ),
          Container(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "Already have an account? ",
                textAlign: TextAlign.right,
                style: new TextStyle(fontSize: 17.5),
              ),
              new FlatButton(
                onPressed: moveToLogin,
                child: new Text(
                  "Login",
                  style: TextStyle(fontSize: 17.5, color: Colors.blueAccent),
                  textAlign: TextAlign.left,
                ),
              )
            ],
          ),
        ],
      );
  }
}
