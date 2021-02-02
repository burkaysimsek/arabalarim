import 'package:arabalarim_burkay/backend/veri.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Api {
  static String baseURL = "http://siberhane.tk/arabalarim/";
  static String apiUrl = "http://siberhane.tk/arabalarim/api.php/";
  static String araba = baseURL + "api.php?get=araba";
  static String imageURL = baseURL + "images/";

  static Future<ArabaFeed> arabalariGetir(String url) async {
    var res = await http.get(url);
    ArabaFeed category;
    if (res.statusCode == 200) {
      final jsonResponse = json.decode(res.body);
      category = ArabaFeed.fromJson(jsonResponse);
    } else {
      throw (res.statusCode);
    }
    return category;
  }

  static Future<bool> aracSil(String url) async {
    var res = await http.get(url);
    if (res.statusCode == 200) {
    } else {
      throw (res.statusCode);
    }
    print(res.body);
  }
}
