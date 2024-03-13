import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:poketype/common/global_functions.dart';
import 'package:poketype/common/types.dart';
import 'package:poketype/connection/poke_api.dart';
import 'package:poketype/design/modal_help/modal_help.dart';
import 'package:poketype/model/model_pokemon.dart';
import 'package:signals/signals_flutter.dart';

class ControllerPokeType {
  static var feedBackText = signal("");
  static var pokemonHP = signal(100);
  static var selectedDifficulty =
      signal(Hive.box("settings").get("difficulty"));
  static var buttonState = signal(true);
  static var indexCorrectType = signal([-1, -1]);
  static var numberOfTries = signal(3);
  static var numberOfPoints = signal(0);
  static var generationsMarked =
      signal(Hive.box("settings").get("generations") as Map);

  final _myFunctions = MyFunctions();
  final _pokeAPI = PokeAPI();
  final Map<String, List> _pokedexGenerationNumbers = {
    "start": [1, 152, 252, 387, 494, 650, 722, 808],
    "end": [151, 251, 386, 493, 649, 721, 807, 905],
  };

  void startGame(BuildContext context, bool win) {
    if (win == false) {
      numberOfPoints.value = 0;
    }
    feedBackText.value = "";
    pokemonHP.value = 100;
    indexCorrectType.value[0] = -1;
    indexCorrectType.value[1] = -1;
    numberOfTries.value = 3;
    _pokeAPI.getPokemon(_sortPokemonId());
    buttonState.value = true;
  }

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
    List generationsMarkedTrue = generationsMarked.value.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();
    return pokemonIdsPerGeneration[
        (generationsMarkedTrue[random.nextInt(generationsMarkedTrue.length)]) -
            1];
  }

  Future<void> _sortNewPokemon(
      BuildContext context, String text, bool win) async {
    buttonState.value = false;
    feedBackText.value = text;
    await Future.delayed(const Duration(seconds: 1));
    feedBackText.value = "Sorteando um novo Pokemon!";
    await Future.delayed(
      const Duration(seconds: 3),
      () => startGame(context, win),
    );
  }

  saveSettings(bool isOpened, BuildContext context) {
    if (isOpened == false) {
      _myFunctions.showSnackBar(
          context, "Para aplicar as configurações clique em novo jogo!");
      Hive.box("settings").put("generations", generationsMarked.value);
      Hive.box("settings").put("difficulty", selectedDifficulty.value);
    }
  }

  onClickIconButtonHelp(BuildContext context) {
    _myFunctions.showModal(ModalHelp(), context);
  }

  onClickDifficultyButton(int index) {
    selectedDifficulty.value = index;
  }

  onChangedGeneration(bool? value, int index) {
    if (ControllerPokeType.generationsMarked.value.values
                .where((element) => element == true)
                .length >
            1 ||
        value == true) {
      ControllerPokeType.generationsMarked.value
          .addAll({index + 1: value as bool});
    }
  }

  Future<void> onClickTypeButton(
      String type, BuildContext context, int buttonIndex) async {
    if (Pokemon.types.value.contains(type)) {
      // verifica se o tipo clicado é o do pokemon
      if (Pokemon.types.value.length == 1) {
        Pokemon.image.value = "";
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
          Pokemon.image.value = "";
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
