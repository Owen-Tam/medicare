import 'package:flutter/material.dart';
import "../data.dart";
import "../components/medicine_schedule.dart";
import "../components/medicine_stock.dart";
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  int testDataIndex = 0;
  List<Medication> testMedications = [
    Medication(
        name: "Calcium 200mg",
        quantity: 1,
        times: [TimeOfDay(hour: 18, minute: 00)],
        stock: 120,
        drawerID: "4"),
    Medication(
      name: "Vitamin C 500mg",
      quantity: 1,
      times: [TimeOfDay(hour: 9, minute: 30)],
      stock: 90,
      drawerID: "2",
    ),
    Medication(
      name: "Ibuprofen 400mg",
      quantity: 2,
      times: [TimeOfDay(hour: 12, minute: 0), TimeOfDay(hour: 18, minute: 00)],
      stock: 200,
      drawerID: "1",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    final user = data.user;
    final now = DateTime.now();
    Future<void> _showUnallowDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Action unavailable.'),
            content: const SingleChildScrollView(
                child: Text('This feature has not been implemented fully.')),
            actions: <Widget>[
              FilledButton.tonal(
                child: const Text('I understand'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

// Get the user's medications and stock data
    final List<Medication> userMedications = user.medications;

// Create a map to store medication details by time
    final Map<TimeOfDay, List<MedicationDetails>> medicationByTime = {};

// Iterate through each medication in the stock
    userMedications.forEach((medication) {
      final List<TimeOfDay> medicationTimes = medication.times;
      final int medicationQuantity = medication.quantity;

      // Associate each time with the stock information
      medicationTimes.forEach((time) {
        MedicationDetails medicationDetails = MedicationDetails(
          name: medication.name,
          quantity: medicationQuantity,
          drawer: medication.drawerID,
        );

        if (medicationByTime.containsKey(time)) {
          medicationByTime[time]!.add(medicationDetails);
        } else {
          medicationByTime[time] = [medicationDetails];
        }
      });
    });

// Now `medicationByTime` contains the desired object
    final nowTimeOfDay = TimeOfDay.fromDateTime(now);
    const chartDir = "assets/chart.svg";
    return Stack(children: [
      ListView(scrollDirection: Axis.vertical, children: [
        Column(
          children: <Widget>[
            SizedBox(height: 18),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(
                      0xFF5D8AFF), // Set your desired background color
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text(
                                  "Today’s medicine",
                                  style: TextStyle(
                                    fontSize: 20, // Set font size to 25
                                    fontWeight:
                                        FontWeight.w600, // Set medium weight
                                    color: Color(0xFFEEF3FF),
                                  ),
                                )),
                            MedicineWidget(
                                medicationByTime: medicationByTime,
                                now: nowTimeOfDay)
                          ],
                        )))),
            Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(
                          0xFFEBEDF3), // Set your desired background color
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.topLeft,
                            child: StockWidget(
                                userMedications: userMedications,
                                short: false))))),
            Padding(
                padding: EdgeInsets.only(top: 15),
                child: SvgPicture.asset(chartDir, semanticsLabel: 'chart')),
            SizedBox(height: 18),
          ],
        )
      ]),
      Positioned(
        right: 0,
        bottom: 75,
        child: FloatingActionButton.small(
          onPressed: () {
            _showUnallowDialog();
          },
          child: Icon(Icons.calendar_month),
          backgroundColor: Color(0xFFE2EAFF),
        ),
      ),
      Positioned(
        right: 0,
        bottom: 10,
        child: FloatingActionButton.extended(
          onPressed: () {
            if (testDataIndex > testMedications.length - 1) {
              _showUnallowDialog();
              return;
            }
            var newMedication = testMedications[testDataIndex];
            data.addMedication(
                newMedication.name,
                newMedication.times,
                newMedication.quantity,
                newMedication.stock,
                newMedication.drawerID);
            setState(() {
              testDataIndex++;
            });
          },
          icon: Icon(Icons.add, color: Color(0xFFFFFFFF)),
          label: Text("Add to Schedule",
              style: TextStyle(color: Colors.white, fontSize: 15)),
          backgroundColor: Color(0xFF5D8AFF),
        ),
      ),
    ]);
  }
}
