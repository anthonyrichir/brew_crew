import 'package:brewcrew/models/user.dart';
import 'package:brewcrew/services/database.dart';
import 'package:brewcrew/shared/constants.dart';
import 'package:brewcrew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your brew settings.',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                      initialValue: userData.name,
                      onChanged: (value) {
                        setState(() {
                          _currentName = value;
                        });
                      },
                      validator: (value) =>
                          value.isEmpty ? 'Please enter a name' : null,
                      decoration: textInputDecoration),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    value: _currentSugars ?? userData.sugars,
                    decoration: textInputDecoration,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugars = val),
                  ),
                  SizedBox(height: 20),
                  //slider
                  PlatformSlider(
                    value: (_currentStrength ?? userData.strength).toDouble(),
                    min: 100,
                    max: 900,
                    divisions: 8,
                    onChanged: (val) =>
                        setState(() => _currentStrength = val.round()),
                    activeColor: Colors.brown[_currentStrength ?? 100],
                    material: (context, platform) => MaterialSliderData(
                      inactiveColor: Colors.brown[_currentStrength ?? 100],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  PlatformButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        print(_currentName);
                        print(_currentSugars);
                        print(_currentStrength);
                        if (_formKey.currentState.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                              _currentSugars ?? userData.sugars,
                              _currentName ?? userData.name,
                              _currentStrength ?? userData.strength);
                          Navigator.pop(context);
                        }
                      }),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
