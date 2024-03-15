import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:poketype/common/global_functions.dart';

class ModalHelp extends StatefulWidget {
  const ModalHelp({super.key});

  @override
  State<ModalHelp> createState() => _ModalHelpState();
}

class _ModalHelpState extends State<ModalHelp> {
  final myFunctions = MyFunctions();
  @override
  Widget build(BuildContext context) {
    var children = [
      _subTitle("Como Funciona"),
      _content(
        'Adivinhe o(s) tipo(s) de um, dos 905 Pokémon, e veja qual será sua maior pontuação nas diferentes dificuldades! Por padrão, há 3 tentativas por jogo.',
      ),
      Image.asset(
        'assets/images/Types_help.png',
        scale: myFunctions.verifyIfIsWebPlataform() == true ? 1 : 1.3,
      ),
      Padding(padding: EdgeInsets.all(12)),
      _subTitle("Dificuldades"),
      _content(
        'Há três diferentes dificuldades: fácil, normal (padrão) e díficil.',
        align: TextAlign.justify,
      ),
    ];
    children.addAll(
      _span(
        {
          '\nFácil: ': 'Deve acertar pelo menos um tipo.',
          '\nNormal: ': 'Deve acertar ambos os tipos, quando houver.',
          '\nDifícil: ':
              'Deve acertar ambos os tipos, quando houver. Com excessão do Game Over, as tentativas não reiniciam a cada novo jogo. É contabilizado +1 a cada acerto, com limite de 5.'
        },
      ),
    );
    children.add(
      Padding(padding: EdgeInsets.all(12)),
    );
    children.add(_subTitle("Pontuação"));
    children.add(
      _content("Cada dificuldade possui sua pontuação."),
    );
    children.addAll(
      _span(
        {
          "Acertos: ": "A cada acerto, é somado 1.",
          "\nMelhor: ":
              "No Game Over, se a quantidade de acertos for maior que a sua anterior, seus acertos serão atribuídos.",
        },
      ),
    );
    children.add(
      Padding(padding: EdgeInsets.all(12)),
    );
    children.addAll(
      _span(
        {
          'Atenção!':
              ' Antes de um fim de jogo, se você mudar a dificuldade ou as gerações, os acertos serão zerados, com excessão da melhor pontuação.'
        },
      ),
    );
    children.add(const Divider(
      color: Colors.white,
    ));
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
      contentTextStyle: const TextStyle(fontSize: 16, color: Colors.white),
      title: const Column(
        children: [
          Text(
            'Ajuda',
            textAlign: TextAlign.center,
          ),
          Divider(
            color: Colors.white,
          )
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: ListBody(
            children: children,
          ),
        ),
      ),
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('Entendi'),
          ),
        ),
      ],
    );
  }

  _span(Map<String, String> texts) {
    return List.generate(
      texts.length,
      (index) => Text.rich(
        TextSpan(
          text: texts.keys.elementAt(index),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: texts.values.elementAt(index),
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(
    String text, {
    FontWeight font = FontWeight.normal,
    TextAlign align = TextAlign.center,
  }) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontWeight: font,
      ),
    );
  }

  Widget _subTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
