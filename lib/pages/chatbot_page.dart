import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import "../data.dart";

class Message {
  final bool isBot;
  final String message;
  final DateTime sentTime;
  Message({required this.isBot, required this.message, required this.sentTime});
}

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
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
            text: '$regular',
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
  List<Message> messages = [];
  void addMessage(String message, bool isBot) {
    setState(() {
      messages.add(
          Message(isBot: isBot, message: message, sentTime: DateTime.now()));
    });
  }

  // TODO HOW TO MAKE REACTIVE
  void ask(String message) {
    addMessage(message, false);
    switch (message) {
      case "I feel unwell today, should I take 5 magnesium pills":
        addMessage(
            "Oh, I'm sorry to hear that you're feeling unwell today, Amy. However, you should not take more than the prescribed dosage of any medication without consulting with your healthcare provider first. Your recommended dosage is one 100mg pill at 12:00pm and another at 6:00pm. If you feel unwell, please tell your son at #852+ 1234 5678#.",
            true);
        break;
      case "Do I need to buy any medicine?":
        addMessage(
            "Hello Amy, based on the information I have, we currently have 2 days' worth of Coenzyme Q10, 9 days' worth of magnesium, and 10 days' worth of glucosamine in stock. Since the Coenzyme Q10 pills are running low, your local pharmaceutical company has already been contacted to restock. Your family has been scheduled to pick up the medicine by tomorrow. If you have any questions, please contact your local pharmaceutical at #852+ 4321 9765#.",
            true);
        break;
      case "Which drawer is my Glucosamine medication in":
        addMessage(
            "Your Glucosamine medication is in drawer 3. It should automatically be opened by the Medicare box when you need to take the medication.",
            true);
        break;
      default:
        addMessage(
            "I found no data about that. You may contact your doctor at #852+ 4321 8765# if you have any questions.",
            true);
        break;
    }
  }

  int testMsgIndex = 0;

  List<String> testMessages = [
    "I feel unwell today, should I take 5 magnesium pills",
    "Do I need to buy any medicine?",
    "Which drawer is my Glucosamine medication in",
    "What is life?"
  ];

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    final ScrollController _controller = ScrollController();

    Future<void> _showUnallowDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Action unavailable.'),
            content: const SingleChildScrollView(
                child: Text(
                    'This feature has not been implemented fully or the sample data has been used up.')),
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

    return Stack(children: [
      messages.length > 0
          ? ListView.builder(
              controller: _controller,
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
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                  "Mini doctor - ${_formatTime(messages[index].sentTime)}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700))
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              SizedBox(width: 35),
                              Flexible(
                                  child:
                                      formatHashtags(messages[index].message)),
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
                              Text(
                                  "You - ${_formatTime(messages[index].sentTime)}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700))
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
                                  maxLines:
                                      100, // Set the maximum number of lines
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ));
              })
          : Center(
              child: Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFEBEDF3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No messages found',
                        style: TextStyle(fontSize: 23),
                      ),
                      const SizedBox(height: 10),
                      FilledButton.tonal(
                        onPressed: () {
                          ask(testMessages[testMsgIndex]);

                          if (testMsgIndex == 0) {
                            setState(() {
                              testMsgIndex = 1;
                            });
                          } else {
                            setState(() {
                              testMsgIndex = 0;
                            });
                          }
                        },
                        child: const Text('Have a question?'),
                      ),
                    ],
                  ))),
      Positioned(
        right: 0,
        bottom: 10,
        child: FloatingActionButton.extended(
          onPressed: () {
            if (testMsgIndex > testMessages.length - 1) {
              _showUnallowDialog();
              return;
            }
            ask(testMessages[testMsgIndex]);
            setState(() {
              testMsgIndex++;
            });

            if (_controller.hasClients) {
              _controller.animateTo(
                _controller.position.maxScrollExtent * 1.1,
                duration: Duration(milliseconds: 800),
                curve: Curves.fastOutSlowIn,
              );
            }
          },
          icon: const Icon(Icons.mic_outlined, color: Color(0xFFFFFFFF)),
          label: const Text("Ask Question",
              style: TextStyle(color: Colors.white, fontSize: 15)),
          backgroundColor: Color(0xFF5D8AFF),
        ),
      ),
    ]);
  }
}

String _formatTime(DateTime time) {
  final hour = time.hour % 12; // Convert to 12-hour system
  final minute =
      time.minute.toString().padLeft(2, '0'); // Ensure 2-character minute
  final period = time.hour < 12 ? 'a.m.' : 'p.m.'; // Determine AM or PM
  return '$hour:$minute $period';
}
