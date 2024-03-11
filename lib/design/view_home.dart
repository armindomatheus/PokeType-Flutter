// ignore_for_file: avoid_print, use_key_in_widget_constructors, sort_child_properties_last, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:poketype/common/colors.dart';
import 'package:poketype/common/types.dart';
import 'package:poketype/model/model_pokemon.dart';
import 'package:poketype/design/controller_home.dart';
import 'package:signals/signals_flutter.dart';
import 'package:universal_html/html.dart' as html;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ControllerHome controller = ControllerHome();
  String feedBack = "";
  @override
  void initState() {
    super.initState();
    controller.startGame(context);
    print(ControllerHome.generationMarkedNumber.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Colors.transparent,
          width: html.window.navigator.userAgent.contains("Mozilla") == true
              ? MediaQuery.of(context).size.width * 0.15
              : MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Geração",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _checkBoxGenerations(),
              const Divider(
                color: Colors.white,
                indent: 10,
                endIndent: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Dificuldade",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buttonsDifficulty(),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            'PokéType',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => print("ajuda"),
              icon: const Icon(Icons.help),
              iconSize: 30,
            )
          ],
        ),
        body: Center(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  _pokemon(),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Expanded(child: _buttonTypes())),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(5),
          child: ElevatedButton(
            onPressed: () => controller.startGame(context),
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
          ),
        ));
  }

  Widget _pokemon() {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 90,
            width: 350,
            child: _plataform(),
          ),
          Positioned(
            top: 30,
            width: 200,
            child: _pokemonName(),
          ),
          Positioned(
            bottom: 60,
            child: _textTypePokemon(),
          ),
          Positioned(
            bottom: 60,
            child: _textFeedBack(),
          ),
          Positioned(
            child: _HUD(),
            width: 270,
            top: 60,
          ),
          Positioned(
            bottom: 160,
            child: _pokemonImage(),
          ),
        ],
      ),
    );
  }

  Widget _textFeedBack() {
    return Text(
      feedBack,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
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

  Widget _HUD() {
    return Container(
      width: 200.0, // Largura da barra de HP
      height: 20.0, // Altura da barra de HP
      decoration: BoxDecoration(
        color: Colors.grey[300], // Cor de fundo da barra de HP
        borderRadius: BorderRadius.circular(10.0), // Borda arredondada
      ),
      child: Stack(
        children: [
          // Barra de HP preenchida
          Container(
            width: 300,
            height: 20.0,
            decoration: BoxDecoration(
              color:
                  Colors.green, // Cor da barra de HP dependendo do percentual
              borderRadius: BorderRadius.circular(10.0), // Borda arredondada
            ),
          ),
          // Texto mostrando a quantidade de HP
          const Positioned.fill(
            child: Center(
              child: Text(
                '100/100', // Texto mostrando HP atual e máximo
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
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

  Widget _pokemonImage() {
    return Pokemon.image.watch(context) == ""
        ? const Padding(
            padding: EdgeInsets.only(bottom: 200),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : Image.network(
            scale: 0.6,
            fit: BoxFit.none,
            filterQuality: FilterQuality.high,
            isAntiAlias: true,
            Pokemon.image.watch(context),
          );
  }

  Widget _buttonTypes() {
    return GridView.count(
      shrinkWrap: true,
      childAspectRatio:
          html.window.navigator.userAgent.contains("Mozilla") == true ? 5 : 3,
      crossAxisCount:
          html.window.navigator.userAgent.contains("Mozilla") == true ? 6 : 3,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      padding: const EdgeInsets.all(0),
      children: List.generate(
        18,
        (index) {
          return ElevatedButton.icon(
            onPressed: () => print("teste"),
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
          );
        },
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
            value: ControllerHome.generationsMarked.watch(context)[index],
            onChanged: (value) => setState(() {
              value == true
                  ? ControllerHome.generationMarkedNumber.value.add(index + 1)
                  : ControllerHome.generationMarkedNumber.value
                      .removeWhere((element) => element == index + 1);
              ControllerHome.generationsMarked.value[index] = value as bool;
            }),
          );
        },
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
            child: ElevatedButton(
              onPressed: () => print("difficulty"),
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
          );
        },
      ),
    );
  }
}
