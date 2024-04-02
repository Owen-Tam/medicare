import "package:flutter/material.dart";

class Data extends ChangeNotifier {
  var _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;

  void changePage(int newPageIndex) {
    _currentPageIndex = newPageIndex;
    notifyListeners(); // Notify listeners of state change
  }
}
