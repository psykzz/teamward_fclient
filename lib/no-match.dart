import 'package:flutter/material.dart';


class NoActiveMatch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text('No Game found'),
          new RaisedButton(
            child: new Text('Refresh'),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
    );
  }
}
