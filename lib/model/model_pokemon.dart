import 'package:signals/signals_flutter.dart';

class Pokemon {
  static Signal<String> name = signal("");
  static Signal<String> image = signal("");
  static Signal<List<String>> types = signal([]);
}
