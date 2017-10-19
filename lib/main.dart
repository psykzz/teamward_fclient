import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var http = createHttpClient();


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

class NoActiveMatch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text("No game found."),
    );
  }
}

class Match extends StatelessWidget {
  Match({
    @required this.blueTeam,
    @required this.redTeam
  }) : assert (redTeam != null),
  assert (blueTeam != null);

  final List<Widget> blueTeam;
  final List<Widget> redTeam;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: blueTeam
      )
    );
  }
}

class TeamTab extends StatelessWidget {
  TeamTab({
    @required this.teamMembers,
  }) : assert (teamMembers != null);

  final List<TeamMemberItem> teamMembers;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: teamMembers
      )
    );
  }
}

class TeamMemberItem extends StatelessWidget {
  TeamMemberItem({
    this.champion,
    this.summonerName,
    this.level,
    this.onTap,
  });

  final String champion;
  final String summonerName;
  final int level;

  final ValueChanged<BuildContext> onTap;

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: new Image.network("http://ddragon.leagueoflegends.com/cdn/5.5.1/img/champion/${this.champion}.png"),
      title: new Text(
        champion,
        textScaleFactor: 1.0,
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: new Text(
        "${summonerName}\n${level}",
        textScaleFactor: 1.0,
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      isThreeLine: true,
      onTap: onTap == null ? null : () { onTap(context); },
    );
  }

}

class SummonerDrawerItem extends StatelessWidget  {
  SummonerDrawerItem({
    @required this.summonerName,
    this.onTap,
  }) : assert(summonerName != null);

  final String summonerName;
  final ValueChanged<BuildContext> onTap;

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: new Image.network("http://ddragon.leagueoflegends.com/cdn/5.5.1/img/profileicon/1.png"),
      title: new Text(
        summonerName,
        textScaleFactor: 1.1,
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: onTap == null ? null : () { onTap(context); },
    );
  }
}


final Widget defaultBodyPart = new Center(
  child: new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      new Text(
        'You have pushed the button this many times:',
      ),
      new Text(
        'no counter sorry',
      ),
    ],
  ),
);

class _DefaultPageState extends State<DefaultPage> {
  final List<Tab> headerTabs = <Tab>[
    new Tab(text: 'Blue Team'),
    new Tab(text: 'Red Team'),
    new Tab(text: 'Tips'),
  ];
  Widget bodyPart = defaultBodyPart;

  void _getMatchDetails(String summoner, String region) async {
    var response = await http.read('https://app.teamward.xyz/game/data?summoner=${summoner}&region=${region}&client=psykzz');
    var res = JSON.decode(response);
    return res;
  }

  void _setActiveSummoner(String summoner, String region) async {


    var blueTeamMembers = <TeamMemberItem>[];
    var redTeamMembers = <TeamMemberItem>[];

    var matchData = await _getMatchDetails(summoner, region);
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
  }

  @override
  Widget build(BuildContext context) {
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
            children: <Widget>[
              new DrawerHeader(
                padding: const EdgeInsets.all(0.0),
                child: new Image.network("https://i0.wp.com/www.adventuresinpoortaste.com/wp-content/uploads/2015/11/helmet-bro-sword.png")
              ),
              new SummonerDrawerItem(
                summonerName: 'PsyKzz',
                onTap: (BuildContext context) {
                  _setActiveSummoner('psykzz', 'euw');
                  Navigator.pop(context);
                }
              ),
              new SummonerDrawerItem(
                summonerName: 'H1twoman',
                onTap: (BuildContext context) {
                  _setActiveSummoner('H1twoman', 'euw');
                  Navigator.pop(context);
                }
              ),
              new SummonerDrawerItem(
                summonerName: 'Razor2k10',
                onTap: (BuildContext context) {
                  _setActiveSummoner('razor2k10', 'euw');
                  Navigator.pop(context);
                }
              ),
            ],
          )
        ),
        body: bodyPart,
      ),
    );
  }
}
