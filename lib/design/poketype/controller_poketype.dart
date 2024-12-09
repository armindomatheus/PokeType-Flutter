import 'dart:math';
import 'package:flutter/material.dart';
import 'package:poketype/common/global_functions.dart';
import 'package:poketype/common/types.dart';
import 'package:poketype/connection/poke_api.dart';
import 'package:poketype/design/modal_help/modal_help.dart';
import 'package:poketype/design/poketype/drawer/controller_poketype_drawer.dart';
import 'package:poketype/model/model_pokemon.dart';
import 'package:signals/signals_flutter.dart';

class ControllerPokeType {
  static var feedBackText = signal("");
  static var pokemonHP = signal(100);
  static var buttonState = signal(true);
  static var indexCorrectType = signal([-1, -1]);
  static var numberOfTries = signal(3);
  static var numberOfPoints = signal(0);
  final _myFunctions = MyFunctions();
  final _pokeAPI = PokeAPI();

  final Map<String, List> _pokedexIndices = {
    "start": [1, 152, 252, 387, 494, 650, 722, 808],
    "end": [151, 251, 386, 493, 649, 721, 807, 905],
  };
  final List<int> _start = [1, 152, 252, 387, 494, 650, 722, 808];
  final List<int> _end = [151, 251, 386, 493, 649, 721, 807, 905];
  final Map<int, List<int>> _pokedexGenerationsNumebesNew = {
    1: [],
    2: [],
    3: [],
    4: [],
    5: [],
    6: [],
    7: [],
    8: [],
  };
  Map<int, int> _pokemonIndexPerGeneration = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
    8: 0
  };

  _teste() {
    // gera e embaralha os indices dos pokemons de cada intervalo de geração
    for (int i = 1; i <= 8; i++) {
      for (int j = _start[i - 1]; j <= _end[i - 1]; j++) {
        _pokedexGenerationsNumebesNew[i]?.add(j);
      }
      _pokedexGenerationsNumebesNew[i]?.shuffle(Random());
    }
  }

  startGame(BuildContext context, bool win) async {
    if (win == false) {
      numberOfPoints.value = 0;
    }
    feedBackText.value = "";
    pokemonHP.value = 100;
    indexCorrectType.value[0] = -1;
    indexCorrectType.value[1] = -1;
    numberOfTries.value = 3;
    _teste();
    _pokeAPI.getPokemon(_sortPokemonId());
    buttonState.value = true;
  }

  int _sortPokemonId() {
    List<int> pokemonIdsPerGeneration = [];
    int pokemonIndex = 0;
    List generationsMarkedTrue = ControllerPokeTypeDrawer
        .generationsMarked.value.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();
    Random random = Random();
    int generationSorted =
        generationsMarkedTrue[random.nextInt(generationsMarkedTrue.length)];
    pokemonIndex = _pokedexGenerationsNumebesNew[generationSorted]![
        _pokemonIndexPerGeneration[generationSorted]!];
    _pokemonIndexPerGeneration[generationSorted] =
        _pokemonIndexPerGeneration[generationSorted]! + 1;
    print(pokemonIndex);
    return pokemonIndex;
    for (int i = 0; i < 8; i++) {
      pokemonIdsPerGeneration.add(
        _pokedexIndices["start"]?[i] +
            random.nextInt(
                _pokedexIndices["end"]?[i] - _pokedexIndices["start"]?[i] + 1),
      );
    }
    return pokemonIdsPerGeneration[
        (generationsMarkedTrue[random.nextInt(generationsMarkedTrue.length)]) -
            1];
  }

  Future<void> _sortNewPokemon(
      BuildContext context, String text, bool win) async {
    buttonState.value = false;
    feedBackText.value = text;
    await Future.delayed(const Duration(seconds: 3));
    feedBackText.value = "Sorteando um novo Pokemon!";
    await Future.delayed(
      const Duration(seconds: 3),
      () => startGame(context, win),
    );
  }

  onClickIconButtonHelp(BuildContext context) {
    _myFunctions.showModal(ModalHelp(), context);
  }

  Future<void> onClickTypeButton(
      String type, BuildContext context, int buttonIndex) async {
    if (Pokemon.types.value.contains(type)) {
      // verifica se o tipo clicado é o do pokemon
      if (Pokemon.types.value.length == 1) {
        // caso o pokemon só tem 1 tipo
        _sortNewPokemon(
          context,
          "Acertou! o Pokemon era do tipo: ${Types.types[Pokemon.types.value[0]]}",
          true,
        );
        pokemonHP.value -= 100;
        indexCorrectType.value[0] = buttonIndex;
        numberOfPoints.value++;
      } else {
        // caso o pokemon tenha 2 tipos
        if (indexCorrectType.value[0] > -1) {
          // caso já tenha acertado 1 tipo
          _sortNewPokemon(
            context,
            "Acertou! o Pokemon era do tipo: ${Types.types[Pokemon.types.value[0]]} e ${Types.types["${Pokemon.types.value[1]}"]}",
            true,
          );
          pokemonHP.value -= 50;
          indexCorrectType.value[1] = buttonIndex;
          numberOfPoints.value++;
        } else {
          pokemonHP.value -= 50;
          feedBackText.value = "Acertou o primeiro tipo";
          indexCorrectType.value[0] = buttonIndex;
        }
      }
    } else {
      // Se o tipo nao for o correto
      numberOfTries.value--;
      if (numberOfTries.value == 0) {
        // Caso a quantidade de tentativas chegue a 0
        _sortNewPokemon(
          context,
          "GAME OVER!!! o Pokemon era do tipo: ${Types.types[Pokemon.types.value[0]]} e ${Types.types["${Pokemon.types.value[1]}"]}",
          false,
        );
      } else {
        // Caso ainda tenha tentativas sobrando
        feedBackText.value = "Errou Miseravelmente!";
      }
    }
  }
}
