import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'info_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Home Page'),
            GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                prefs.remove("Email").then((value) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoScreen(),
                    )));
              },
              child: ListTile(
                title: Text(
                  "Log out",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: Icon(Icons.logout),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
