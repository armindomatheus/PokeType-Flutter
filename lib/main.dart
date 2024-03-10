import 'package:flutter/material.dart';
import 'package:poketype/design/view_home.dart';

void main() {
  runApp(const MyApp());
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
      home: Home(),
    );
  }
}
