import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  int _currentIndex = 0;
  final List<String> _items = []; // Add items list declaration

  int get currentIndex => _currentIndex;
  List<String> get items => _items; // Add items getter

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void loadItems() {
    if (_items.isEmpty) {
      _items.addAll([
        'Item 1',
        'Item 2',
        'Item 3',
        'Item 4',
        'Item 5',
      ]);
      notifyListeners();
    }
  }
}