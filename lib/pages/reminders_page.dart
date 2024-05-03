import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class TimeButton {
  String label;
  int count;
  TimeOfDay? selectedTime;

  TimeButton({required this.label, required this.count, this.selectedTime});
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
  List<String> list = <String>['Drawer 4', 'Drawer 5', 'Drawer 6', 'Drawer 7'];
  List<String> providerList = <String>[
    'Harmony Health Solutions',
    'DragonBio Pharmaceuticals',
    'PureLife Pharma',
    'HealthBridge Biotech',
    'WellSpring Biotech'
  ];

  List<TimeButton> timeButtons = [TimeButton(label: 'Add time', count: 1)];
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    final user = data.user;
    final now = DateTime.now();
    Future<void> _showUnallowDialog(
        {String message =
            'This feature has not been implemented fully.'}) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Action unavailable.'),
            content: SingleChildScrollView(
              child: Text(message),
            ),
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
            SizedBox(height: 80),
          ],
        ),
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
            if (list.isEmpty) {
              _showUnallowDialog(
                  message:
                      "There are no empty drawers left. You may update the drawer allocation in the edit page.");
              return;
            }
            openDialog();
          },
          icon: Icon(Icons.add, color: Color(0xFFFFFFFF)),
          label: Text("Add to Schedule",
              style: TextStyle(color: Colors.white, fontSize: 15)),
          backgroundColor: Color(0xFF5D8AFF),
        ),
      ),
    ]);
  }

  final medicationNameController = TextEditingController();
  final pillAmountController = TextEditingController();
  final medicationDescriptionController = TextEditingController();
  final initialStockController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    medicationNameController.dispose();
    medicationDescriptionController.dispose();
    pillAmountController.dispose();
    initialStockController.dispose();
    super.dispose();
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) {
        String drawerSelected = list.first;
        String providerSelected = "";
        return StatefulBuilder(builder: (stfContext, stfSetState) {
          void _addTimeButton() {
            stfSetState(() {
              final nextCount = timeButtons.length + 1;
              timeButtons.add(TimeButton(label: 'Add time', count: nextCount));
            });
          }

          Future<void> _selectTime(int index) async {
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (pickedTime != null) {
              stfSetState(() {
                timeButtons[index].selectedTime = pickedTime;
                timeButtons[index].label = pickedTime.format(context);
                _addTimeButton();
              });
            }
          }

          Future<void> _showErrorDialog(String message) async {
            return showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                      "There is an error in the medication information.",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  content: SingleChildScrollView(child: Text(message)),
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

          bool _checkAllFields() {
            var medicationName = medicationNameController.text;
            var medicationDescription = medicationDescriptionController.text;
            var initialStock = initialStockController.text;
            List<TimeButton> filteredButtons = timeButtons
                .where((button) => button.label != 'Add time')
                .toList();

            var pillAmount = pillAmountController.text;
            // print(medicationName);
            // print(medicationDescription);
            // print(pillAmount);
            // print(drawerSelected);
            // print(providerSelected);
            // print(initialStock);
            if (medicationName.isEmpty ||
                medicationDescription.isEmpty ||
                pillAmount.isEmpty ||
                drawerSelected.isEmpty ||
                providerSelected.isEmpty ||
                initialStock.isEmpty ||
                filteredButtons.length < 1) {
              _showErrorDialog(
                  "You have not filled in all the required fields for the medication information yet.");
              return false;
            }
            final data = Provider.of<Data>(context, listen: false);

            if (data.user.medications
                .any((medication) => medication.name == medicationName)) {
              _showErrorDialog(
                  "This medication already exists in your schedule. Please edit the medication on the home page.");
              return false;
            }
            if (int.parse(initialStock) < 1 || int.parse(pillAmount) < 1) {
              _showErrorDialog(
                  "The initial stock and pills per time must be a positive number.");
              return false;
            }
            // TODO check if stock or pills per time < 0
            return true;
          }

          void _clearAllFields() {
            medicationNameController.clear();
            medicationDescriptionController.clear();
            initialStockController.clear();
            pillAmountController.clear();
            drawerSelected = "";
            providerSelected = "";
            timeButtons = [TimeButton(label: 'Add time', count: 1)];
            print(timeButtons);
          }

          void _addNewMedication() {
            var medicationName = medicationNameController.text;
            var initialStock = int.parse(initialStockController.text);
            var pillAmount = int.parse(pillAmountController.text);

            var drawerId = drawerSelected.split(' ').last;

            List<TimeOfDay> times = {
              for (var button in timeButtons)
                if (button.label != 'Add time' && button.selectedTime != null)
                  button.selectedTime!
            }.toSet().toList();

            final data = Provider.of<Data>(context, listen: false);
            data.addMedication(
                medicationName, times, pillAmount, initialStock, drawerId);
            list.removeWhere((item) => item == drawerSelected);

            _clearAllFields();
            Navigator.of(context).pop();
          }

          return Dialog.fullscreen(
              child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: ListView(children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 18,
                          ),
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.close),
                                  color: Colors.black,
                                  onPressed: () {
                                    closeDialog();
                                  }),
                              SizedBox(width: 15),
                              const Text(
                                "Add new medication",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.w500, // Set medium weight
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: 300,
                                            height: 50,
                                            child: TextField(
                                                controller:
                                                    medicationNameController,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        "Medication Name"))),
                                        SizedBox(height: 18),
                                        SizedBox(
                                            width: 300,
                                            child: TextField(
                                                maxLines: null,
                                                controller:
                                                    medicationDescriptionController,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        "Medication Description"))),
                                        SizedBox(height: 18),
                                        DropdownMenu<String>(
                                          onSelected: (String? value) {
                                            // This is called when the user selects an item.
                                            setState(() {
                                              providerSelected = value!;
                                            });
                                          },
                                          hintText: "Select a provider",
                                          inputDecorationTheme:
                                              InputDecorationTheme(
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16),
                                            constraints: BoxConstraints.tight(
                                                const Size.fromHeight(50)),
                                            border: OutlineInputBorder(),
                                          ),
                                          dropdownMenuEntries: providerList
                                              .map<DropdownMenuEntry<String>>(
                                                  (String value) {
                                            return DropdownMenuEntry<String>(
                                                value: value, label: value);
                                          }).toList(),
                                        ),
                                        SizedBox(height: 18),
                                        SizedBox(height: 18),
                                        SizedBox(
                                            width: 300,
                                            height: 50,
                                            child: TextField(
                                                controller:
                                                    pillAmountController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  // for below version 2 use this
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        "Pills per time"))),
                                        SizedBox(height: 18),
                                        Row(children: [
                                          DropdownMenu<String>(
                                            initialSelection: list.first,
                                            onSelected: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {
                                                drawerSelected = value!;
                                              });
                                            },
                                            inputDecorationTheme:
                                                InputDecorationTheme(
                                              isDense: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              constraints: BoxConstraints.tight(
                                                  const Size.fromHeight(50)),
                                              border: OutlineInputBorder(),
                                            ),
                                            dropdownMenuEntries: list
                                                .map<DropdownMenuEntry<String>>(
                                                    (String value) {
                                              return DropdownMenuEntry<String>(
                                                  value: value, label: value);
                                            }).toList(),
                                          ),
                                          SizedBox(width: 10),
                                          SizedBox(
                                              width: 150,
                                              height: 50,
                                              child: TextField(
                                                  controller:
                                                      initialStockController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    // for below version 2 use this
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          "Initial Stock"))),
                                        ]),
                                        SizedBox(height: 18),
                                        LimitedBox(
                                          maxHeight: 200,
                                          maxWidth: 300,
                                          child: ListView.builder(
                                            addAutomaticKeepAlives: true,
                                            itemCount: timeButtons.length,
                                            itemBuilder: (context, index) {
                                              final button = timeButtons[index];
                                              if (button.label == "Add time") {
                                                return FilledButton(
                                                  onPressed: () =>
                                                      _selectTime(index),
                                                  child: Text(button.label),
                                                );
                                              }
                                              return ElevatedButton(
                                                onPressed: () =>
                                                    _selectTime(index),
                                                child: Text(button.label),
                                              );
                                            },
                                          ),
                                        ),
                                      ]),
                                ],
                              )),
                          SizedBox(
                            height: 18,
                          ),
                          FilledButton(
                              onPressed: () {
                                if (_checkAllFields()) {
                                  _addNewMedication();
                                }
                              },
                              child: Text("Submit"))
                        ])
                  ])));
        });
      });

  void closeDialog() {
    Navigator.of(context).pop();
  }
}
