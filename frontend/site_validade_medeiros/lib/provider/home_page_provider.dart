import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:site_validade_medeiros/model/register_model.dart';
import 'package:http/http.dart' as http;

class HomePageProvider extends ChangeNotifier {
  var register = <RegisterModel>[];

  Future getData(context) async {
    var response = await http.get(
        Uri.parse('https://apirest-validade-medeiros.herokuapp.com/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      print("Response ok");
      var mJson = json.decode(response.body).cast<Map<String, dynamic>>();
      //List<RegisterModel> list = mJson.map<RegisterModel>((json) => RegisterModel.fromJson(json)).toList();

      register = mJson
          .map<RegisterModel>((json) => RegisterModel.fromJson(json))
          .toList();
    }
    notifyListeners();
  }
}
