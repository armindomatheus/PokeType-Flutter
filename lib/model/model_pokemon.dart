import 'package:signals/signals_flutter.dart';

class Pokemon {
  static Signal<String> name = signal("");
  static Signal<String> image = signal("");
  static Signal<String> type1 = signal("");
  static Signal<String> type2 = signal("");
}
