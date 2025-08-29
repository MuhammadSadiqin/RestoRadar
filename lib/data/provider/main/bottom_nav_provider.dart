import 'package:flutter/widgets.dart';

class BottomNavProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
