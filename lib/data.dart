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
  final int criticalDaysLeft;
  User({required this.medications, required this.criticalDaysLeft});
}

class Data extends ChangeNotifier {
  var _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;
  final User _user = User(medications: [
    Medication(
        name: 'Coenzyme Q10 300mg',
        times: [TimeOfDay(hour: 12, minute: 0)],
        quantity: 1, // Assuming 1 tablet
        stock: 2,
        drawerID: "1"),
    Medication(
        name: 'Magnesium 100mg',
        times: [
          const TimeOfDay(hour: 12, minute: 0),
          const TimeOfDay(hour: 18, minute: 0)
        ],
        quantity: 1,
        stock: 8,
        drawerID: "2"),
    Medication(
      name: 'Glucosamine 500mg',
      times: [
        const TimeOfDay(hour: 12, minute: 0),
        const TimeOfDay(hour: 18, minute: 0)
      ],
      quantity: 1, // Assuming 1 tablet
      stock: 10,
      drawerID: "3",
    )
  ], criticalDaysLeft: 2);

  User get user => _user;
  void addMedication(String medicationName, List<TimeOfDay> times, int quantity,
      int stock, String drawerID) {
    _user.medications.add(Medication(
        name: medicationName,
        times: times,
        quantity: quantity,
        stock: stock,
        drawerID: drawerID));
    notifyListeners();
  }

  void changePage(int newPageIndex) {
    _currentPageIndex = newPageIndex;
    notifyListeners(); // Notify listeners of state change
  }
}
