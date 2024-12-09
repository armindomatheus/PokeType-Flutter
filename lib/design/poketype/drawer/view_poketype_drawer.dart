import 'package:flutter/material.dart';
import 'package:poketype/common/global_functions.dart';
import 'package:poketype/design/poketype/drawer/controller_poketype_drawer.dart';

class ViewPoketypeDrawer extends StatefulWidget {
  const ViewPoketypeDrawer({super.key});

  @override
  State<ViewPoketypeDrawer> createState() => _ViewPoketypeDrawerState();
}

class _ViewPoketypeDrawerState extends State<ViewPoketypeDrawer> {
  final _controller = ControllerPokeTypeDrawer();
  final myFunctions = MyFunctions();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      surfaceTintColor: Colors.transparent,
      width: myFunctions.verifyIfIsWebPlataform() == true
          ? MediaQuery.of(context).size.width * 0.2
          : MediaQuery.of(context).size.width * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: _textDrawerGenerations(),
          ),
          _checkBoxGenerations(),
          const Divider(
            color: Colors.white,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: _textDrawerDifficulty(),
          ),
          _buttonsDifficulty(),
        ],
      ),
    );
  }

  Widget _textDrawerGenerations() {
    return const Text(
      "Geração",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _checkBoxGenerations() {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: List.generate(
        8,
        (index) {
          return CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: const EdgeInsets.all(3),
            visualDensity: VisualDensity.compact,
            activeColor: Theme.of(context).colorScheme.secondary,
            title: Text(
              "Geração ${index + 1}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            value: ControllerPokeTypeDrawer.generationsMarked.value[index + 1],
            onChanged: (value) => setState(
              () {
                _controller.onChangedGeneration(value, index);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _textDrawerDifficulty() {
    return const Text(
      "Dificuldade",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buttonsDifficulty() {
    List<String> difficulties = ["Fácil", "Médio", "Difícil"];
    return ListView(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      children: List.generate(
        difficulties.length,
        (index) {
          return Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 3),
            child: Opacity(
              opacity:
                  ControllerPokeTypeDrawer.selectedDifficulty.value == index
                      ? 0.4
                      : 1,
              child: ElevatedButton(
                onPressed: () =>
                    ControllerPokeTypeDrawer.selectedDifficulty.value == index
                        ? null
                        : _controller.onClickDifficultyButton(index),
                child: Text(difficulties[index]),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
