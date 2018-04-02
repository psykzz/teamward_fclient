import 'package:flutter/material.dart';


class Match extends StatelessWidget {
  Match({
    this.blueTeam,
    this.redTeam
  }) : assert (redTeam != null && blueTeam != null);

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
    this.teamMembers,
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
      leading: new Image.network("http://ddragon.leagueoflegends.com/cdn/7.20.3/img/champion/${this.champion}.png"),
      title: new Text(
        champion,
        textScaleFactor: 1.0,
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: new Text(
        "$summonerName\n$level",
        textScaleFactor: 1.0,
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      isThreeLine: true,
      onTap: onTap == null ? null : () { onTap(context); },
    );
  }

}
