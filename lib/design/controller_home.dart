import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poketype/connection/poke_api.dart';
import 'package:signals/signals_flutter.dart';

class ControllerHome {
  static var indexBottomNavBar = signal(0);
  static var generationMarkedNumber =
      signal(List.generate(8, (index) => index + 1));
  static var generationsMarked = signal(List.generate(8, (index) => true));
  PokeAPI pokeAPI = PokeAPI();
  final Map<String, List> _pokedexGenerationNumbers = {
    "start": [1, 152, 252, 387, 494, 650, 722, 808],
    "end": [151, 251, 386, 493, 649, 721, 807, 905],
  };
  int _sortPokemonId() {
    List<int> pokemonIdsPerGeneration = [];
    Random random = Random();
    for (int i = 0; i < 8; i++) {
      pokemonIdsPerGeneration.add(
        _pokedexGenerationNumbers["start"]?[i] +
            random.nextInt(_pokedexGenerationNumbers["end"]?[i] -
                _pokedexGenerationNumbers["start"]?[i] +
                1),
      );
    }
    int sortedGeneration =
        1 + random.nextInt(generationMarkedNumber.value.length - 1 + 1);
    print(pokemonIdsPerGeneration);
    print(sortedGeneration);
    print(generationMarkedNumber.value);
    print(pokemonIdsPerGeneration[
        generationMarkedNumber.value[sortedGeneration - 1] - 1]);
    return pokemonIdsPerGeneration[
        generationMarkedNumber.value[sortedGeneration - 1] - 1];
  }

  void startGame(BuildContext context) {
    pokeAPI.getPokemon(_sortPokemonId());
  }
}
