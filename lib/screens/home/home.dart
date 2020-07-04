import 'package:brewcrew/models/brew.dart';
import 'package:brewcrew/screens/home/brew_list.dart';
import 'package:brewcrew/screens/home/settings_form.dart';
import 'package:brewcrew/services/auth.dart';
import 'package:brewcrew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  void _showSettingsPanel(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
            child: SettingsForm(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      child: PlatformScaffold(
        backgroundColor: Colors.brown[50],
        appBar: PlatformAppBar(
          title: Text('Brew Crew'),
          backgroundColor: Colors.brown[400],
//          elevation: 0,

          trailingActions: <Widget>[
            PlatformIconButton(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
//                label: Text('logout')
            ),
            PlatformIconButton(
              onPressed: () => _showSettingsPanel(context),
              icon: Icon(Icons.settings),
//                label: Text('Settings')
            )
          ],
        ),
        body: Container(
            child: BrewList(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/coffee_bg.png'),
                    fit: BoxFit.cover))),
      ),
    );
  }
}
