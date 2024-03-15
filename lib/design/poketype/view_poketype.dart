// ignore_for_file: avoid_print, use_key_in_widget_constructors, sort_child_properties_last, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:poketype/common/colors.dart';
import 'package:poketype/common/global_functions.dart';
import 'package:poketype/common/types.dart';
import 'package:poketype/model/model_pokemon.dart';
import 'package:poketype/design/poketype/controller_poketype.dart';
import 'package:signals/signals_flutter.dart';

class ViewPokeType extends StatefulWidget {
  @override
  State<ViewPokeType> createState() => _ViewPokeTypeState();
}

class _ViewPokeTypeState extends State<ViewPokeType> {
  final myFunctions = MyFunctions();
  ControllerPokeType controller = ControllerPokeType();
  @override
  void initState() {
    super.initState();
    controller.startGame(context, false);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controller.startGame(context, false);
        if (Hive.box("settings").get("isFirstTime") == true) {
          Hive.box("settings").put("isFirstTime", false);
          controller.onClickIconButtonHelp(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      onDrawerChanged: (isOpened) => controller.saveSettings(isOpened, context),
      drawer: _drawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: _textAppBarTitle(),
        actions: _actionsAppBar(),
      ),
      body: Center(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                _pokemon(),
                Align(alignment: Alignment.bottomCenter, child: _buttonTypes()),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(5),
        child: _buttonNewGame(),
      ),
    );
  }

  Widget _textAppBarTitle() {
    return const Text(
      'PokéType',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    );
  }

  List<Widget> _actionsAppBar() {
    return [
      IconButton(
        onPressed: () => controller.onClickIconButtonHelp(context),
        icon: const Icon(Icons.help),
        iconSize: 30,
      ),
    ];
  }

  Widget _drawer() {
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
            value:
                ControllerPokeType.generationsMarked.watch(context)[index + 1],
            onChanged: (value) => setState(() {
              controller.onChangedGeneration(value, index);
            }),
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
                  ControllerPokeType.selectedDifficulty.watch(context) == index
                      ? 0.4
                      : 1,
              child: ElevatedButton(
                onPressed: () =>
                    ControllerPokeType.selectedDifficulty.watch(context) ==
                            index
                        ? null
                        : controller.onClickDifficultyButton(index),
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

  Widget _pokemon() {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 80,
            child: _textTypePokemon(),
          ),
          Positioned(
            bottom: 20,
            width: MediaQuery.of(context).size.width,
            child: _textFeedBack(),
          ),
          Positioned(
            top: 0,
            left: 0,
            height: 60,
            width: 60,
            child: _points(),
          ),
          Positioned(
            top: 0,
            right: 0,
            height: 60,
            width: 60,
            child: _tries(),
          ),
          Positioned(
            bottom: 90,
            width: 350,
            child: _plataform(),
          ),
          Positioned(
            bottom: 160,
            child: _pokemonImage(),
          ),
          Positioned(
            child: _HUD(),
            width: 270,
            height: 270,
            top: 0,
          ),
        ],
      ),
    );
  }

  Widget _points() {
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 30,
          child: _textNumberOfPoints(),
        ),
        Positioned(
          top: 0,
          width: 35,
          child: _imagePokeball(),
        ),
      ],
    );
  }

  Widget _imagePokeball() {
    return Image.asset(
      "assets/icons/pokeball.png",
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
    );
  }

  Widget _textNumberOfPoints() {
    return Text(
      "${ControllerPokeType.numberOfPoints.watch(context)}x",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        fontFamily: "pokemon",
      ),
    );
  }

  Widget _tries() {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children: [
        Positioned(
          top: 30,
          child: _textNumberOfTries(),
        ),
        Positioned(
          top: 0,
          width: 35,
          child: _imageTries(),
        ),
      ],
    );
  }

  Widget _imageTries() {
    return Image.asset(
      "assets/icons/heart (1).png",
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
    );
  }

  Widget _textNumberOfTries() {
    return Text(
      "${ControllerPokeType.numberOfTries.watch(context)}x",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        fontFamily: "pokemon",
      ),
    );
  }

  Widget _pokemonName() {
    return Center(
      child: Text(
        Pokemon.image.watch(context) == "" ? "" : Pokemon.name.watch(context),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: "pokemon",
        ),
      ),
    );
  }

  Widget _HUD() {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children: [
        Positioned(
          child: _pokemonHP(),
          width: 270,
          top: 30,
        ),
        Positioned(
          child: _pokemonName(),
          top: 0,
        )
      ],
    );
  }

  Widget _pokemonHP() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      width: 200.0, // Largura da barra de HP
      height: 20.0, // Altura da barra de HP
      decoration: BoxDecoration(
        color: Colors.grey[300], // Cor de fundo da barra de HP
        borderRadius: BorderRadius.circular(10.0), // Borda arredondada
      ),
      child: Stack(
        children: [
          // Barra de HP preenchida
          AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            width: 300 * (ControllerPokeType.pokemonHP.watch(context) / 100),
            height: 20.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getGradientColors(
                    ControllerPokeType.pokemonHP.watch(context) / 100),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              // color: ControllerPokeType.pokemonHP.watch(context) == 100
              //     ? Colors.green
              //     : ControllerPokeType.pokemonHP.watch(context) == 50
              //         ? Colors.yellow
              //         : Colors
              //             .red, // Cor da barra de HP dependendo do percentual
              borderRadius: BorderRadius.circular(10.0), // Borda arredondada
            ),
          ),
          // Texto mostrando a quantidade de HP
          Positioned.fill(
            child: Center(
              child: Text(
                '${ControllerPokeType.pokemonHP.watch(context)}/100', // Texto mostrando HP atual e máximo
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "pokemon"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pokemonImage() {
    return Pokemon.image.watch(context) == ""
        ? Container()
        : Image.network(
            scale: 0.6,
            fit: BoxFit.none,
            filterQuality: FilterQuality.high,
            isAntiAlias: true,
            loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null
                    ? child
                    : const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
            Pokemon.image.watch(context),
          );
  }

  Widget _plataform() {
    return Image.asset(
      "assets/images/grass.png",
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
    );
  }

  Widget _textTypePokemon() {
    return const Text(
      "Qual o tipo do Pokémon?",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _textFeedBack() {
    return Text(
      ControllerPokeType.feedBackText.watch(context),
      softWrap: true,
      textAlign: TextAlign.center,
      maxLines: 2,
      style: const TextStyle(
        fontSize: 20,
      ),
    );
  }

  Widget _buttonTypes() {
    return GridView.count(
      shrinkWrap: true,
      childAspectRatio: myFunctions.verifyIfIsWebPlataform() == true ? 5 : 3,
      crossAxisCount: myFunctions.verifyIfIsWebPlataform() == true ? 6 : 3,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      padding: const EdgeInsets.all(0),
      children: List.generate(
        18,
        (index) {
          return Opacity(
            opacity:
                ControllerPokeType.indexCorrectType.value.contains(index) ==
                        true
                    ? 0.3
                    : 1,
            child: ElevatedButton.icon(
              onPressed: () =>
                  ControllerPokeType.indexCorrectType.value.contains(index) ==
                              true ||
                          ControllerPokeType.buttonState.watch(context) == false
                      ? null
                      : controller.onClickTypeButton(
                          Types.types.keys.elementAt(index),
                          context,
                          index,
                        ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                backgroundColor:
                    MyColors.colorTypes[Types.types.keys.elementAt(index)],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Image.asset(
                  "assets/icons/${Types.types.keys.elementAt(index)}.png",
                  width: 30,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                ),
              ),
              label: SizedBox(
                width: 100,
                child: Text(
                  textAlign: TextAlign.left,
                  Types.types.values.elementAt(index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buttonNewGame() {
    return ElevatedButton(
      onPressed: () => controller.startGame(context, false),
      child: const Text("Novo Jogo"),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(double percentage) {
    if (percentage == 1) {
      return [Colors.greenAccent, Colors.green];
    } else if (percentage >= 0.75) {
      return [Colors.yellow, Colors.green];
    } else if (percentage >= 0.5) {
      return [Colors.orange, Colors.yellow];
    } else {
      return [Colors.red, Colors.orange];
    }
  }
}
