import 'package:flutter/material.dart';
import "../data.dart";
import 'package:provider/provider.dart';

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
