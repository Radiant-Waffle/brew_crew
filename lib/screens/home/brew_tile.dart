import 'package:flutter/material.dart';
import 'package:brew_crew/models/brew.dart';

class BrewTile extends StatelessWidget {
  final List<String> sizes = ['XS', 'S', 'M', 'L', 'XL'];
  final Brew brew;
  BrewTile({this.brew});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Spacer(
                flex: 1,
              ),
              Container(
                height: 70.0,
                width: 50.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/coffee_icon.png'),
                      radius: 0.7 * (brew.size.toDouble()) + 14,
                      backgroundColor: Colors.brown[brew.strength ? 900 : 400],
                    ),
                    Text(sizes[(brew.size / 2 - 4).round()])
                  ],
                ),
              ),
              Spacer(
                flex: 2,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    brew.name,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Takes ${brew.cream} cream\nand ${brew.sugars} sugar(s)',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
              Spacer(
                flex: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
