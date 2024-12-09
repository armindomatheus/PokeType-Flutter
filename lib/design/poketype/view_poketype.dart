// ignore_for_file: avoid_print, use_key_in_widget_constructors, sort_child_properties_last, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:poketype/common/colors.dart';
import 'package:poketype/common/global_functions.dart';
import 'package:poketype/common/types.dart';
import 'package:poketype/design/poketype/drawer/controller_poketype_drawer.dart';
import 'package:poketype/design/poketype/drawer/view_poketype_drawer.dart';
import 'package:poketype/model/model_pokemon.dart';
import 'package:poketype/design/poketype/controller_poketype.dart';
import 'package:signals/signals_flutter.dart';

class ViewPokeType extends StatefulWidget {
  @override
  State<ViewPokeType> createState() => _ViewPokeTypeState();
}

class _ViewPokeTypeState extends State<ViewPokeType>
    with SingleTickerProviderStateMixin {
  final myFunctions = MyFunctions();
  ControllerPokeType controller = ControllerPokeType();
  late AnimationController _controllerAnimation;
  late Animation<Color?> _colorAnimation;
  bool _animationPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controller.startGame(context, false);
        if (Hive.box("settings").get("isFirstTime") == true) {
          Hive.box("settings").put("isFirstTime", false);
          controller.onClickIconButtonHelp(context);
        }
      },
    );

    // Configura o controlador da animação
    _controllerAnimation = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: const Color.fromARGB(255, 229, 131, 124),
    ).animate(_controllerAnimation);

    _controllerAnimation.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        print("inicou a animação");
        setState(() {
          _animationPlaying = true; // Marca que a animação terminou
        });
      }
    });
    _colorAnimation.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          print("completou a animação");
          setState(() {
            _animationPlaying = false;
          });
        }
      },
    );
    // Inicia a animação
  }

  _vfxPokemonDamage() {
    // Define a animação de cor
    _controllerAnimation.forward();
  }

  void _onTapButtonTypes(int index) {
    ControllerPokeType.indexCorrectType.value.contains(index) == true ||
            ControllerPokeType.buttonState.watch(context) == false
        ? null
        : controller.onClickTypeButton(
            Types.types.keys.elementAt(index),
            context,
            index,
          );
    if (ControllerPokeType.pokemonHP.value < 100) {
      print("entrou");
      _vfxPokemonDamage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      onDrawerChanged: (isOpened) =>
          ControllerPokeTypeDrawer().saveSettings(isOpened, context),
      drawer: ViewPoketypeDrawer(),
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
                Align(
                    alignment: Alignment.bottomCenter,
                    child: _gridViewButtonTypes()),
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
          width: MediaQuery.of(context).size.width - 150,
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
      decoration: BoxDecoration(
        color: Colors.grey[300], // Cor de fundo da barra de HP
        borderRadius: BorderRadius.circular(10.0),
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
              // Cor da barra de HP dependendo do percentual
              gradient: LinearGradient(
                colors: _getGradientColors(
                    ControllerPokeType.pokemonHP.watch(context) / 100),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                '${ControllerPokeType.pokemonHP.watch(context)}/100', // Texto mostrando HP atual e máximo
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "pokemon",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pokemonImage() {
    print(Pokemon.image.watch(context));
    return Pokemon.image.value == ""
        ? const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return Image.network(
                scale: 0.6,
                fit: BoxFit.none,
                filterQuality: FilterQuality.high,
                isAntiAlias: true,
                colorBlendMode:
                    _animationPlaying == true ? BlendMode.modulate : null,
                color: _animationPlaying == true ? _colorAnimation.value : null,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : const SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                Pokemon.image.watch(context),
              );
            },
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

  Widget _gridViewButtonTypes() {
    return GridView.count(
      shrinkWrap: true,
      childAspectRatio: myFunctions.verifyIfIsWebPlataform() == true ? 5 : 3,
      crossAxisCount: myFunctions.verifyIfIsWebPlataform() == true ? 6 : 3,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      padding: const EdgeInsets.all(0),
      children: List.generate(
        18,
        (index) => Opacity(
          opacity: ControllerPokeType.indexCorrectType.value.contains(index) ==
                  true //Deixa opaco elementos que já foram usados
              ? 0.3
              : 1,
          child: _buttonTypes(
            index,
          ),
        ),
      ),
    );
  }

  Widget _buttonTypes(int index) {
    return ElevatedButton.icon(
      onPressed: () => _onTapButtonTypes(index),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        backgroundColor: MyColors.colorTypes[Types.types.keys.elementAt(index)],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      icon: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: _buttonTypesIcon(index),
      ),
      label: _buttonTypesLabel(index),
    );
  }

  Widget _buttonTypesIcon(int index) {
    return Image.asset(
      "assets/icons/${Types.types.keys.elementAt(index)}.png",
      width: 30,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
    );
  }

  Widget _buttonTypesLabel(int index) {
    return SizedBox(
      width: 100,
      child: FittedBox(
        alignment: Alignment.centerLeft,
        fit: BoxFit.scaleDown,
        child: Text(
          Types.types.values.elementAt(index),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _buttonNewGame() {
    return ElevatedButton(
      onPressed: () => controller.startGame(context, false),
      child: const Text("Novo Jogo"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF595959),
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
