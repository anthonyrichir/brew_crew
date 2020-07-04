import 'package:brewcrew/models/user.dart';
import 'package:brewcrew/services/auth.dart';
import 'package:brewcrew/shared/constants.dart';
import 'package:brewcrew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  bool loading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              title: Text('Sign up to Brew Crew'),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text('Sign In'))
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
                        obscureText: true,
                        validator: (value) => value.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password')),
                    SizedBox(height: 20),
                    RaisedButton(
                      color: Colors.pink[400],
                      child: Text('Register',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          User result = await _auth
                              .registerWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'Oopsy';
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: 12),
                    Text(error,
                        style: TextStyle(color: Colors.red, fontSize: 14))
                  ],
                ),
              ),
            ),
          );
  }
}
