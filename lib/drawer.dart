import 'package:flutter/material.dart';


class SummonerDrawerItem extends StatelessWidget  {
  SummonerDrawerItem({
    this.summonerName,
    this.realm,
    this.onTap,
  }) : assert(summonerName != null);

  final String summonerName;
  final String realm;
  final ValueChanged<BuildContext> onTap;

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundImage: new NetworkImage("https://avatar.leagueoflegends.com/euw/$summonerName.png"),
      ),
      subtitle: new Text(realm),
      title: new Text(
        summonerName,
        textScaleFactor: 1.1,
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: onTap == null ? null : () { onTap(context); },
    );
  }
}



class AddSummonerDrawerItem extends StatelessWidget {
  AddSummonerDrawerItem({
      this.summonerName,
      this.realm,
  }) : assert(summonerName != null && realm != null);

  final String summonerName;
  final String realm;


  @override
  Widget build(BuildContext context) {
    return null;
  }

}