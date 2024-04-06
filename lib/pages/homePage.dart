import 'package:flutter/material.dart';
import "../data.dart";
import "../components/medicineSchedule.dart";
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    final user = data.user;

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
    final now = DateTime.now();
    final nowTimeOfDay = TimeOfDay.fromDateTime(now);
    return Stack(
      children: [
        ListView(scrollDirection: Axis.vertical, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
              padding: EdgeInsets.only(top: 15), // Add margin top of 30px
              child: Text(
                "Welcome back!",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8C8C8C),
                ),
              ),
            ),
            const Text(
              "Amy Wong",
              style: TextStyle(
                fontSize: 45, // Set font size to 25
                fontWeight: FontWeight.w500, // Set medium weight
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  "Now: ${_formatTime(DateTime.now())}",
                  style: const TextStyle(
                    fontSize: 20, // Set font size to 25
                    fontWeight: FontWeight.w500, // Set medium weight
                  ),
                ))
          ]),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        Color(0xFF5D8AFF), // Set your desired background color
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
                              Padding(
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
                          ))))),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        Color(0xFFEBEDF3), // Set your desired background color
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
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.only(bottom: 8),
                                        child: Row(children: [
                                          Text(
                                            "Medicine Stock: ",
                                            style: TextStyle(
                                              fontSize:
                                                  20, // Set font size to 25
                                              fontWeight: FontWeight
                                                  .w600, // Set medium weight
                                            ),
                                          ),
                                          Text(
                                            "Critical",
                                            style: TextStyle(
                                                fontSize:
                                                    20, // Set font size to 25
                                                fontWeight: FontWeight.w600,
                                                color: Color(
                                                    0xFFFF0000) // Set medium weight
                                                ),
                                          )
                                        ])),
                                    const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Coenzyme Q10 300mg - 2 days",
                                              style: TextStyle(
                                                  color: Color(0xFFFF0000),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                          Text("Magnesium 100mg - 8 days",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                        ]),
                                  ]),
                              SizedBox(height: 8),
                              FilledButton.tonal(
                                onPressed: () {
                                  data.changePage(1);
                                },
                                child: const Text('See More'),
                              )
                            ],
                          ))))),
          SizedBox(height: 20),
        ]),
        Positioned(
          right: 0,
          bottom: 0,
          child: FloatingActionButton.extended(
            onPressed: () {},
            icon: Icon(Icons.calendar_month, color: Color(0xFFFFFFFF)),
            label: Text("Manage Schedule",
                style: TextStyle(color: Colors.white, fontSize: 15)),
            backgroundColor: Color(0xFF5D8AFF),
          ),
        ),
      ],
    );
  }
}

String _formatTime(DateTime time) {
  final hour = time.hour % 12; // Convert to 12-hour system
  final minute =
      time.minute.toString().padLeft(2, '0'); // Ensure 2-character minute
  final period = time.hour < 12 ? 'a.m.' : 'p.m.'; // Determine AM or PM
  return '$hour:$minute $period';
}
