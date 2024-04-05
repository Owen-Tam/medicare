import 'package:flutter/material.dart';
import "data.dart";
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const MyApp());

class CustomTheme {
  static ThemeData lightThemeData(BuildContext context) {
    return ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        fontFamily: "Poppins");
  }

  static ThemeData darkThemeData() {
    return ThemeData(useMaterial3: true);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Data(), // Create an instance of your provider
      child: MaterialApp(
          theme: CustomTheme.lightThemeData(context),
          darkTheme: CustomTheme.darkThemeData(),
          home: const MyWidget()),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class Message {
  final bool isBot;
  final String message;

  Message({required this.isBot, required this.message});
}

Widget formatHashtags(String text) {
  final List<String> letters = text.split('');
  var between = false;
  var str = "";
  var regular = "";

  List<TextSpan> finalStr = [];
  letters.asMap().forEach((index, letter) {
    if (letter == '#') {
      if (!between) {
        between = true;
        finalStr.add(TextSpan(
            text: '$regular',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: "Poppins",
            )));
        regular = "";
      } else {
        between = false;
        finalStr.add(TextSpan(
          text: '$str',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
            decoration: TextDecoration.underline,
            fontFamily: "Poppins",
          ),
        ));
        str = "";
      }

      // Hashtag found, apply blue and underlined style
    } else {
      if (between) {
        str += letter;
      } else {
        regular += letter;
      }

      if (index == letters.length - 1) {
        finalStr.add(TextSpan(
            text: '$letter',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: "Poppins",
            )));
      }
      // Regular text, keep the original style
    }
  });

  return RichText(
    text: TextSpan(
      children: finalStr,
      // Set the maximum number of lines
    ),
    overflow: TextOverflow.ellipsis, // Adjust overflow behavior
    maxLines: 100,
  );
}

class _ChatbotPageState extends State<ChatbotPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    List<Message> messages = [
      Message(
          isBot: false,
          message: "I feel unwell today, should I take 5 magnesium pills"),
      Message(
          isBot: true,
          message:
              "Oh, I'm sorry to hear that you're feeling unwell today, Amy. However, you should not take more than the prescribed dosage of any medication without consulting with your healthcare provider first. Your recommended dosage is one 100mg pill at 12:00pm and another at 6:00pm. If you feel unwell, please tell your son at #852+ 1234 5678#."),
      Message(isBot: false, message: "Do I need to buy any medicine?"),
      Message(
          isBot: true,
          message:
              "Hello Amy, based on the information I have, we currently have 2 days' worth of Coenzyme Q10, 9 days' worth of magnesium, and 10 days' worth of glucosamine in stock. Since the Coenzyme Q10 pills are running low, your local pharmaceutical company has already been contacted to restock. Your family has been scheduled to pick up the medicine by tomorrow. If you have any questions, please contact your local pharmaceutical at #852+ 4321 9765#."),
    ];
    return ListView.builder(
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          if (messages[index].isBot == true) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 3.0),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Color(0xFF5D8AFF),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("Mini doctor - 3:02pm",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700))
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        SizedBox(width: 35),
                        Flexible(
                            child: formatHashtags(messages[index].message)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Color(0xFFAEAEAE),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("You - 3:02pm",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700))
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 35),
                        Flexible(
                          child: Text(
                            messages[index].message,
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow
                                .ellipsis, // Adjust overflow behavior
                            maxLines: 100, // Set the maximum number of lines
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}

List<Widget> generateMedicineSchedule(
    Map<TimeOfDay, List<MedicationDetails>> medicationByTime,
    TimeOfDay currentTime) {
  bool completedMedicine(TimeOfDay time, TimeOfDay currentTime) {
    final double timeDouble =
        time.hour.toDouble() + (time.minute.toDouble() / 60);
    final double nowDouble =
        currentTime.hour.toDouble() + (currentTime.minute.toDouble() / 60);

    if (timeDouble > nowDouble) {
      return true;
    } else {
      return false;
    }
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
  });
  return medicationWidgets;
}

class MedicineWidget extends StatelessWidget {
  final Map<TimeOfDay, List<MedicationDetails>>
      medicationByTime; // Replace with your actual data
  final TimeOfDay now;

  MedicineWidget({required this.medicationByTime, required this.now});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: generateMedicineSchedule(medicationByTime, now),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
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

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    final user = data.user;

// Get the user's medications and stock data
    final List<Medication> userMedications = user.medications;
    final Map<String, MedicationStock> stockData = user.stock;

// Create a map to store medication details by time
    final Map<TimeOfDay, List<MedicationDetails>> medicationByTime = {};

// Iterate through each medication in the stock
    stockData.forEach((medicationName, stockInfo) {
      final List<TimeOfDay> medicationTimes =
          userMedications.firstWhere((med) => med.name == medicationName).times;

      // Associate each time with the stock information
      medicationTimes.forEach((time) {
        MedicationDetails medicationDetails = MedicationDetails(
          name: medicationName,
          quantity: stockInfo.quantity,
          drawer: stockInfo.drawerNumber,
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
                  child: const Padding(
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Opacity(
                                      opacity: 0.3,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              Icon(Icons.check_circle_outline,
                                                  size:
                                                      30, // Enlarged icon size
                                                  color: Color(0xFFFFFFFF)
                                                  // White color
                                                  // Opacity set to 0.3
                                                  ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                  "12:00pm",
                                                  style: TextStyle(
                                                    color: Color(0xFFFFFFFF),
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(children: [
                                                    Text(
                                                      '\u2022', // Bullet symbol (UTF-8 code)
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          height: 1,
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                        "Drawer 2: Coenzyme Q10 300mg x 1",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))
                                                  ]),
                                                  Row(children: [
                                                    Text(
                                                      '\u2022', // Bullet symbol (UTF-8 code)
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          height: 1,
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                        "Drawer 3: Magnesium 100mg x1",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))
                                                  ]),
                                                  Row(children: [
                                                    Text(
                                                      '\u2022', // Bullet symbol (UTF-8 code)
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          height: 1,
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                        "Drawer 4: Glucosamine 500mg x1 ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))
                                                  ])
                                                ])
                                          ])),
                                  SizedBox(height: 15),
                                  Opacity(
                                      opacity: 1,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              Icon(Icons.timer_outlined,
                                                  size:
                                                      30, // Enlarged icon size
                                                  color: Color(0xFFFFFFFF)
                                                  // White color
                                                  // Opacity set to 0.3
                                                  ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                  "6:00pm",
                                                  style: TextStyle(
                                                    color: Color(0xFFFFFFFF),
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(children: [
                                                    Text(
                                                      '\u2022', // Bullet symbol (UTF-8 code)
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          height: 1,
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                        "Drawer 3: Magnesium 100mg x1",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))
                                                  ]),
                                                  Row(children: [
                                                    Text(
                                                      '\u2022', // Bullet symbol (UTF-8 code)
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          height: 1,
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                        "Drawer 4: Glucosamine 500mg x1 ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))
                                                  ])
                                                ])
                                          ])),
                                ],
                              )
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

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    final chartDir = "assets/chart.svg";
    return Stack(children: [
      ListView(scrollDirection: Axis.vertical, children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        Color(0xFF5D8AFF), // Set your desired background color
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  child: const Padding(
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
                              Opacity(
                                  opacity: 0.3,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Icon(Icons.check_circle_outline,
                                              size: 30, // Enlarged icon size
                                              color: Color(0xFFFFFFFF)
                                              // White color
                                              // Opacity set to 0.3
                                              ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5.0),
                                            child: Text(
                                              "12:00pm",
                                              style: TextStyle(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ]),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(children: [
                                                Text(
                                                  '\u2022', // Bullet symbol (UTF-8 code)
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      height: 1,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                    "Drawer 2: Coenzyme Q10 300mg x 1",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500))
                                              ]),
                                              Row(children: [
                                                Text(
                                                  '\u2022', // Bullet symbol (UTF-8 code)
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      height: 1,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                    "Drawer 3: Magnesium 100mg x1",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500))
                                              ]),
                                              Row(children: [
                                                Text(
                                                  '\u2022', // Bullet symbol (UTF-8 code)
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      height: 1,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                    "Drawer 4: Glucosamine 500mg x1 ",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500))
                                              ])
                                            ])
                                      ])),
                              SizedBox(height: 15),
                              Opacity(
                                  opacity: 1,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Icon(Icons.timer_outlined,
                                              size: 30, // Enlarged icon size
                                              color: Color(0xFFFFFFFF)
                                              // White color
                                              // Opacity set to 0.3
                                              ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5.0),
                                            child: Text(
                                              "6:00pm",
                                              style: TextStyle(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 25,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ]),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(children: [
                                                Text(
                                                  '\u2022', // Bullet symbol (UTF-8 code)
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      height: 1,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                    "Drawer 3: Magnesium 100mg x1",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500))
                                              ]),
                                              Row(children: [
                                                Text(
                                                  '\u2022', // Bullet symbol (UTF-8 code)
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      height: 1,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                    "Drawer 4: Glucosamine 500mg x1 ",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500))
                                              ])
                                            ])
                                      ]))
                            ],
                          )))),
              Padding(
                  padding: EdgeInsets.only(top: 20),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              Text(
                                                  "Coenzyme Q10 300mg - 2 days",
                                                  style: TextStyle(
                                                      color: Color(0xFFFF0000),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              Text("Magnesium 100mg - 8 days",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              Text(
                                                  "Glucosamine 500mg - 10 days",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ])
                                      ]),
                                ],
                              ))))),
              Padding(
                  padding: EdgeInsets.only(top: 19),
                  child: SvgPicture.asset(chartDir, semanticsLabel: 'chart'))
            ],
          ),
        )
      ]),
      Positioned(
        right: 0,
        bottom: 65,
        child: FloatingActionButton.small(
          onPressed: () {},
          child: Icon(Icons.calendar_month),
          backgroundColor: Color(0xFFE2EAFF),
        ),
      ),
      Positioned(
        right: 0,
        bottom: 0,
        child: FloatingActionButton.extended(
          onPressed: () {},
          icon: Icon(Icons.add, color: Color(0xFFFFFFFF)),
          label: Text("Add Medicine",
              style: TextStyle(color: Colors.white, fontSize: 15)),
          backgroundColor: Color(0xFF5D8AFF),
        ),
      ),
    ]);
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Under Construction',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Set text color
            ),
          ),
          SizedBox(width: 16), // Add spacing between text and icon
          Icon(
            Icons.build, // Construction icon
            size: 24,
            color: Colors.black, // Set icon color
          ),
        ],
      ),
    );
  }
}

class _MyWidgetState extends State<MyWidget> {
  List<Widget> pageList = <Widget>[
    HomePage(),
    RemindersPage(),
    ProfilePage(),
    ChatbotPage(), // New page (not part of bottomNavigationBar)
  ];
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFFEAF0F2),
          title: const Text(
            'Medicare',
            style: TextStyle(fontWeight: FontWeight.bold), // Bold the text
          ),
          titleSpacing: 18,
          centerTitle: false),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            data.changePage(index);
          });
        },
        indicatorColor: const Color(0xFFC9D5D9),
        selectedIndex: data.currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications_sharp),
            label: 'Reminders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
              icon: Icon(Icons.question_answer_outlined),
              selectedIcon: Icon(Icons.question_answer),
              label: "Chat")
        ],
      ),
      body: Padding(
          padding:
              const EdgeInsets.only(top: 15, left: 18, right: 18, bottom: 18),
          child: IndexedStack(
            index: data.currentPageIndex,
            children: pageList,
          )),
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

String _formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod; // Get hour in 12-hour system
  final minute =
      time.minute.toString().padLeft(2, '0'); // Ensure 2-character minute
  final period =
      time.period == DayPeriod.am ? 'a.m.' : 'p.m.'; // Determine AM or PM
  return '$hour:$minute $period';
}
