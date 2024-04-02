import 'package:flutter/material.dart';
import "data.dart";
import 'package:provider/provider.dart';

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

class MedicationSchedule {
  final List<Medication> medications;

  MedicationSchedule({required this.medications});
}

class userData {
  static final userData _instance = userData._internal();
  // singleton

  factory userData() {
    return _instance;
  }

  userData._internal();
}

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  @override
  Widget build(BuildContext context) {
    return const Text("Skill issue");
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);

    final now = DateTime.now();
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

    return Stack(children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF5D8AFF), // Set your desired background color
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
                                            Text("Coenzyme Q10 300mg - 2 days",
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
                                            Text("Glucosamine 500mg - 10 days",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500))
                                          ])
                                    ]),
                              ],
                            ))))),
          ],
        ),
      ),
      Positioned(
        right: 0,
        bottom: 70,
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
          label: Text("New Medicine",
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
    final ThemeData theme = Theme.of(context);

    return ListView.builder(
        reverse: true,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hello',
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
            );
          }
          return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hi!',
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: theme.colorScheme.onPrimary),
                ),
              ));
        });
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
