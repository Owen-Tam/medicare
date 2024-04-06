import 'package:flutter/material.dart';

List<Widget> generateMedicineSchedule(
    Map<TimeOfDay, List<MedicationDetails>> medicationByTime,
    TimeOfDay currentTime) {
  bool completedMedicine(TimeOfDay time, TimeOfDay currentTime) {
    final double timeDouble =
        time.hour.toDouble() + (time.minute.toDouble() / 60);
    final double nowDouble =
        currentTime.hour.toDouble() + (currentTime.minute.toDouble() / 60);

    return nowDouble > timeDouble;
  }

  List<Widget> generateMedicineRow(List<MedicationDetails> medications) {
    List<Widget> medicationRow = [];
    medications.forEach((medication) {
      final medicineName = medication.name;
      final quantity = medication.quantity;
      final drawerNumber = medication.drawer;

      medicationRow.add(Row(
        children: [
          Text(
            '\u2022', // Bullet symbol (UTF-8 code)
            style: TextStyle(fontSize: 20, height: 1, color: Colors.white),
          ),
          SizedBox(width: 5),
          Text(
            "Drawer $drawerNumber: $medicineName x $quantity",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ));
    });
    return medicationRow;
  }

  List<Widget> medicationWidgets = [];
  medicationByTime.forEach((time, medications) {
    medicationWidgets.add(Opacity(
      opacity: completedMedicine(time, currentTime) ? 0.3 : 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                completedMedicine(time, currentTime)
                    ? Icons.check_circle_outline
                    : Icons.timer_outlined,
                size: 30,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  "${_formatTimeOfDay(time)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: generateMedicineRow(medications),
          ),
        ],
      ),
    ));
    medicationWidgets.add(SizedBox(height: 15));
  });
  medicationWidgets.removeLast();
  return medicationWidgets;
}

class MedicationDetails {
  final String name;
  final String drawer; // List of times (e.g., 10:00 AM, 2:30 PM)
  final int quantity; // Quantity of medication (e.g., 1 tablet, 2 capsules)

  MedicationDetails({
    required this.name,
    required this.drawer,
    required this.quantity,
  });
}

class MedicineWidget extends StatefulWidget {
  final Map<TimeOfDay, List<MedicationDetails>>
      medicationByTime; // Replace with your actual data
  final TimeOfDay now;

  MedicineWidget({required this.medicationByTime, required this.now});

  @override
  State<MedicineWidget> createState() => _MedicineWidgetState();
}

class _MedicineWidgetState extends State<MedicineWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: generateMedicineSchedule(widget.medicationByTime, widget.now),
    );
  }
}

String _formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod; // Get hour in 12-hour system
  final minute =
      time.minute.toString().padLeft(2, '0'); // Ensure 2-character minute
  final period =
      time.period == DayPeriod.am ? 'a.m.' : 'p.m.'; // Determine AM or PM
  return '$hour:$minute $period';
}
