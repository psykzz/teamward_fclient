import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

var http = createHttpClient();


Future<dynamic> getMatchDetails(String summoner, String region) async {
  var response = await http.read('https://app.teamward.xyz/game/data?summoner=$summoner&region=$region&client=psykzz');
  var res = JSON.decode(response);
  return res;
}
