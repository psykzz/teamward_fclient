import 'dart:async';

import 'package:flutter/material.dart';

import 'drawer.dart';
import 'no-match.dart';
import 'match.dart';
import 'api.dart';


void main() {
  runApp(new MaterialApp(
    title: 'Flutter Demo',
    theme: new ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: new DefaultPage(title: 'Team ward'),
  ));
}

class DefaultPage extends StatefulWidget {
  DefaultPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DefaultPageState createState() => new _DefaultPageState();
}


final Widget defaultBodyPart = new NoActiveMatch();

class _DefaultPageState extends State<DefaultPage> {
  final List<Tab> headerTabs = <Tab>[
    new Tab(text: 'Blue Team'),
    new Tab(text: 'Red Team'),
    new Tab(text: 'Tips'),
  ];
  Widget bodyPart = defaultBodyPart;

  Future<void> _setActiveSummoner(String summoner, String region) async {
    var blueTeamMembers = <TeamMemberItem>[];
    var redTeamMembers = <TeamMemberItem>[];
    var matchData;
    try {
      matchData = await getMatchDetails(summoner, region);
    } catch (e) {
      setState(() {
        bodyPart = new TabBarView(
          children: <Widget> [
            new NoActiveMatch(),
            new NoActiveMatch(),
            new Center(child: new Text('No tips just yet.')),
          ],
        );
      });
      return null;
    }
    matchData['teams'].forEach((team) {
      // create the blue team
      if(team['team_id'] == 100) {
        team['players'].forEach((player) {
          blueTeamMembers.add(new TeamMemberItem(
            champion: player['champion']['name'],
            summonerName: player['summoner']['name'],
            level: player['summoner']['level'],
          ));
        });
      }
      // create the red team
      if(team['team_id'] == 200) {
        team['players'].forEach((player) {
          redTeamMembers.add(new TeamMemberItem(
            champion: player['champion']['name'],
            summonerName: player['summoner']['name'],
            level: player['summoner']['level'],
          ));
        });
      }
    });

    TeamTab blueTeam = new TeamTab(teamMembers: blueTeamMembers);
    TeamTab redTeam = new TeamTab(teamMembers: redTeamMembers);

    // Update our state
    setState(() {
      bodyPart = new TabBarView(
        children: <Widget> [
          blueTeam,
          redTeam,
          new Center(child: new Text('No tips just yet.')),
        ],
      );
    });
    return null;
  }


  @override
  Widget build(BuildContext context) {

    // TODO: Pull from store?
    var summoners = {
      'PsyKzz': 'euw',
      'Neamar': 'euw',
      'h1twoman': 'euw',
    };

    // TODO: Remove upper margin on this item?
    var summonerWidgets = <Widget>[
      new DrawerHeader(
        margin: null,
        padding: const EdgeInsets.all(0.0),
        child: new Image.network("https://raw.githubusercontent.com/Neamar/teamward-client/master/app/src/main/res/drawable-hdpi/banner.jpg"),
      ),
    ];

    summoners.forEach((summonerName, realm) {
        var widget = new SummonerDrawerItem(
          summonerName: summonerName,
          realm: realm,
          onTap: (BuildContext context) {
            _setActiveSummoner(summonerName, realm);
            Navigator.pop(context);
          }
      );
      summonerWidgets.add(widget);
    });

    return new DefaultTabController(
      length: headerTabs.length,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          bottom: new TabBar(
            tabs: headerTabs,
          ),
        ),
        drawer: new Drawer(
          child: new ListView(
            // shrinkWrap: true,
            padding: const EdgeInsets.all(0.0),
            children: summonerWidgets,
          )
        ),
        body: bodyPart,
      ),
    );
  }
}
