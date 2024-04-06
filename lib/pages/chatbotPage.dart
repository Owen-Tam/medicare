import 'package:flutter/material.dart';
import "../data.dart";
import 'package:provider/provider.dart';

class Message {
  final bool isBot;
  final String message;

  Message({required this.isBot, required this.message});
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
