import 'package:flutter/material.dart';
import "../data.dart";
import 'package:provider/provider.dart';

List<Widget> generateMedicineStock(
    List<Medication> userMedications, int criticalDaysLeft, bool isShort) {
  List<Widget> medicineStocks = [];
  userMedications.forEach((medication) {
    final int daysLeft =
        (medication.stock / (medication.quantity * medication.times.length))
            .floor();
    medicineStocks.add(Text("${medication.name} - ${daysLeft} days",
        style: TextStyle(
            color: daysLeft <= criticalDaysLeft
                ? Color(0xFFFF0000)
                : Color(0xFF000000),
            fontSize: 16,
            fontWeight: FontWeight.w500)));
  });
  return isShort ? medicineStocks.sublist(0, 2) : medicineStocks;
}

class StockWidget extends StatefulWidget {
  final List<Medication> userMedications;
  final bool short;
  StockWidget({super.key, required this.userMedications, this.short = false});

  @override
  State<StockWidget> createState() => _StockWidgetState();
}

class _StockWidgetState extends State<StockWidget> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    bool isShort = widget.short;
    final int criticalDaysLeft = data.user.criticalDaysLeft;

    final List<Medication> userMedications = widget.userMedications;
    userMedications.sort((a, b) {
      final double ratioA = a.stock / (a.quantity * a.times.length);
      final double ratioB = b.stock / (b.quantity * b.times.length);
      return ratioA.floor().compareTo(ratioB.floor());
    });
    bool isCritical = userMedications.any((medication) {
      final int daysLeft =
          (medication.stock / (medication.quantity * medication.times.length))
              .floor();
      return daysLeft <= criticalDaysLeft;
    });
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Row(children: [
            Text(
              "Medicine Stock: ",
              style: TextStyle(
                fontSize: 20, // Set font size to 25
                fontWeight: FontWeight.w600, // Set medium weight
              ),
            ),
            Text(
              isCritical ? "Critical" : "Sufficient",
              style: TextStyle(
                  fontSize: 20, // Set font size to 25
                  fontWeight: FontWeight.w600,
                  color: isCritical
                      ? Color(0xFFFF0000)
                      : Colors.black // Set medium weight
                  ),
            )
          ])),
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: generateMedicineStock(
              userMedications, criticalDaysLeft, isShort)),
      if (isShort) ...[
        SizedBox(height: 8),
        FilledButton.tonal(
          onPressed: () {
            data.changePage(1);
          },
          child: const Text('See More'),
        ),
      ],
    ]);
  }
}
