import "package:flutter/material.dart";

class Medication {
  final String name;
  final List<TimeOfDay> times; // List of times (e.g., 10:00 AM, 2:30 PM)
  final int quantity; // Quantity of medication (e.g., 1 tablet, 2 capsules)
  final int stock;
  final String drawerID;

  Medication(
      {required this.name,
      required this.times,
      required this.quantity,
      required this.stock,
      required this.drawerID});
}

class User {
  final List<Medication> medications;

  User({required this.medications});
}

class Data extends ChangeNotifier {
  var _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;
  final User _user = User(medications: [
    Medication(
        name: 'Coenzyme Q10 300mg',
        times: [TimeOfDay(hour: 12, minute: 0)],
        quantity: 1, // Assuming 1 tablet
        stock: 50,
        drawerID: "1"),
    Medication(
        name: 'Magnesium 100mg',
        times: [TimeOfDay(hour: 12, minute: 0), TimeOfDay(hour: 18, minute: 0)],
        quantity: 1,
        stock: 100,
        drawerID: "2"),
    Medication(
      name: 'Glucosamine 500mg',
      times: [TimeOfDay(hour: 12, minute: 0), TimeOfDay(hour: 18, minute: 0)],
      quantity: 1, // Assuming 1 tablet
      stock: 75,
      drawerID: "3",
    )
  ]);

  User get user => _user;

  void changePage(int newPageIndex) {
    _currentPageIndex = newPageIndex;
    notifyListeners(); // Notify listeners of state change
  }
}
