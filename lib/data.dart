import "package:flutter/material.dart";

class Medication {
  final String name;
  final List<TimeOfDay> times; // List of times (e.g., 10:00 AM, 2:30 PM)
  final int quantity; // Quantity of medication (e.g., 1 tablet, 2 capsules)

  Medication({
    required this.name,
    required this.times,
    required this.quantity,
  });
}

class MedicationStock {
  final int quantity;
  final String drawerNumber;

  MedicationStock({required this.quantity, required this.drawerNumber});
}

class User {
  final List<Medication> medications;
  final Map<String, MedicationStock> stock; // New property for stock

  User({required this.medications, required this.stock});
}

class Data extends ChangeNotifier {
  var _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;
  User _user = User(medications: [
    Medication(
      name: 'Coenzyme Q10 300mg',
      times: [TimeOfDay(hour: 12, minute: 0)],
      quantity: 1, // Assuming 1 tablet
    ),
    Medication(
      name: 'Magnesium 100mg',
      times: [TimeOfDay(hour: 12, minute: 0), TimeOfDay(hour: 18, minute: 0)],
      quantity: 1, // Assuming 1 tablet
    ),
    Medication(
      name: 'Glucosamine 500mg',
      times: [TimeOfDay(hour: 12, minute: 0), TimeOfDay(hour: 18, minute: 0)],
      quantity: 1, // Assuming 1 tablet
    )
  ], stock: {
    'Coenzyme Q10 300mg': MedicationStock(quantity: 50, drawerNumber: '1'),
    'Magnesium 100mg': MedicationStock(quantity: 100, drawerNumber: '2'),
    'Glucosamine 500mg': MedicationStock(quantity: 75, drawerNumber: '3'),
  });

  User get user => _user;

  void changePage(int newPageIndex) {
    _currentPageIndex = newPageIndex;
    notifyListeners(); // Notify listeners of state change
  }
}
