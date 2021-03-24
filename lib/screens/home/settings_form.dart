import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> additions = ['0', '1', '2', '3', '4'];
  final List<String> sizes = ['XS', 'S', 'M', 'L', 'XL'];

  // form values
  String _currentName;
  String _currentSugars;
  String _currentCream;
  bool _currentStrength;
  int _currentSize;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DataBaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    Text(
                      'Update your brew settings.',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      initialValue: userData.name,
                      decoration: textInputDecoration,
                      validator: (val) =>
                          val.isEmpty ? 'Please enter a name' : null,
                      onChanged: (val) => setState(() => _currentName = val),
                    ),
                    // dropdown
                    DropdownButtonFormField(
                      decoration: textInputDecoration,
                      value: _currentCream ?? userData.cream,
                      items: additions.map((cream) {
                        return DropdownMenuItem(
                          value: cream,
                          child: Text('$cream cream'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _currentCream = val),
                    ),
                    DropdownButtonFormField(
                      decoration: textInputDecoration,
                      value: _currentSugars ?? userData.sugars,
                      items: additions.map((sugar) {
                        return DropdownMenuItem(
                          value: sugar,
                          child: Text('$sugar sugars'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _currentSugars = val),
                    ),
                    SizedBox(height: 2.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Size: ${sizes[((_currentSize ?? userData.size) / 2 - 4).round()]}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Spacer(),
                        Text(
                          'Strength:',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Switch(
                          value: _currentStrength ?? userData.strength,
                          activeColor: Colors.brown[900],
                          inactiveThumbColor: Colors.brown[400],
                          onChanged: (bool isOn) {
                            print('switched to: $isOn');
                            setState(() {
                              _currentStrength = isOn;
                            });
                          },
                        ),
                      ],
                    ),
                    // slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius:
                                  (_currentSize ?? userData.size).toDouble())),
                      child: Slider(
                        value: (_currentSize ?? userData.size).toDouble(),
                        activeColor: Colors.brown[
                            (_currentStrength ?? userData.strength)
                                ? 900
                                : 400],
                        inactiveColor: Colors.brown[
                            (_currentStrength ?? userData.strength)
                                ? 900
                                : 400],
                        min: 8,
                        max: 16,
                        divisions: 4,
                        onChanged: (val) =>
                            setState(() => _currentSize = val.round()),
                      ),
                    ),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.pink[400]),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await DataBaseService(uid: user.uid).updateUserData(
                              _currentSugars ?? userData.sugars,
                              _currentCream ?? userData.cream,
                              _currentName ?? userData.name,
                              _currentStrength ?? userData.strength,
                              _currentSize ?? userData.size);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
