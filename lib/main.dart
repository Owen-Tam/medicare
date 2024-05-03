import 'package:flutter/material.dart';
import "data.dart";
import 'package:provider/provider.dart';

import "pages/home_page.dart";
import "pages/reminders_page.dart";
import "pages/profile_page.dart";
import "pages/chatbot_page.dart";

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
          debugShowCheckedModeBanner: false,
          home: const MyWidget()),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
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
          centerTitle: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.translate_outlined,
              ),
              tooltip: 'Show Snackbar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Translating...')));
              },
            ),
          ]),
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
          padding: const EdgeInsets.only(left: 18, right: 18),
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
