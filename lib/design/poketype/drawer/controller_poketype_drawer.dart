import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:poketype/common/global_functions.dart';
import 'package:signals/signals_flutter.dart';

class ControllerPokeTypeDrawer {
  final _myFunctions = MyFunctions();

  static var selectedDifficulty = signal(
    Hive.box("settings").get("difficulty"),
  );

  static Signal<Map> generationsMarked =
      signal(Hive.box("settings").get("generations"));

  saveSettings(bool isOpened, BuildContext context) {
    if (isOpened == false) {
      _myFunctions.showSnackBar(
          context, "Para aplicar as configurações clique em novo jogo!");
      Hive.box("settings").put("generations", generationsMarked.value);
      Hive.box("settings").put("difficulty", selectedDifficulty.value);
    }
  }

  onClickDifficultyButton(int index) {
    selectedDifficulty.value = index;
  }

  onChangedGeneration(bool? value, int index) {
    if (generationsMarked.value.values
                .where((element) => element == true)
                .length >
            1 ||
        value == true) {
      generationsMarked.value.addAll({index + 1: value as bool});
    }
  }
}
