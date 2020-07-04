import 'package:brewcrew/models/user.dart';
import 'package:brewcrew/services/auth.dart';
import 'package:brewcrew/shared/constants.dart';
import 'package:brewcrew/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Sign in to Brew Crew'),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text('Register'))
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) =>
                            value.isEmpty ? 'Enter an email' : null,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email')),
                    SizedBox(height: 20),
                    TextFormField(
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        validator: (value) => value.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        obscureText: true,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password')),
                    SizedBox(height: 20),
                    RaisedButton(
                      color: Colors.pink[400],
                      child: Text('Sign in',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        print(email);
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          User result = await _auth.signInWithEmailAndPassword(
                              email, password);
                          if (result == null) {
                            setState(() {
                              error = 'Oopsy';
                              loading = false;
                            });
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
