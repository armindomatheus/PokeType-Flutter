import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:poketype/design/poketype/view_poketype.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _checkIfFirstTimeUser();
  runApp(const MyApp());
}

_checkIfFirstTimeUser() async {
  await Hive.initFlutter();
  final settingsBox = await Hive.openBox("settings");
  bool isFirstTime = settingsBox.get("isFirstTime") ?? true;
  if (isFirstTime == true) {
    settingsBox.put("isFirstTime", isFirstTime);
    Map<int, bool> generations =
        Map.fromEntries(List.generate(8, (index) => MapEntry(index + 1, true)));
    settingsBox.put("generations", generations);
    settingsBox.put("difficulty", 1);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokéType',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFe74c3c),
          onPrimary: Colors.white,
          secondary: Color(0xFF595959),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Color(0xFF202124),
          onBackground: Colors.white,
          surface: Color(0xFF595959),
          onSurface: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: ViewPokeType(),
    );
  }
}
