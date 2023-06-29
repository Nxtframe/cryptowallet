import 'package:flutter/foundation.dart';

class DarkModeProvider with ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}
