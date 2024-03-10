// ignore_for_file: avoid_print, file_names

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:poketype/common/global_functions.dart';
import 'package:poketype/model/model_pokemon.dart';

class PokeAPI {
  final _myFunctions = MyFunctions();
  Future<void> getPokemon(int pokemonId) async {
    var url = Uri.parse(
      "https://pokeapi.co/api/v2/pokemon/$pokemonId",
    );

    var response = await http.get(url, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
    });
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      Pokemon.name.value =
          _myFunctions.firstLetterUpperCase(jsonResponse["name"]);
      Pokemon.image.value =
          jsonResponse["sprites"]["other"]["showdown"]["front_default"];
      Pokemon.type1.value = jsonResponse["types"][0]["type"]["name"];
      Pokemon.type2.value = (jsonResponse["types"] as List).length > 1
          ? jsonResponse["types"][1]["type"]["name"]
          : "";
    } else {
      print(response.statusCode);
    }
  }
}
