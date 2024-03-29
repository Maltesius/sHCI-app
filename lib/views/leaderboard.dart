import 'package:flutter/material.dart';
import 'package:navbar/views/leaderboards/personal_leaderboard.dart';

import 'leaderboards/global_leaderboard.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'LEADERBOARD',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).canvasColor),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GlobalLeaderboard()),
                  ),
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 75),
                ),
                child: const Text("Global Leaderboard"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PersonalLeaderboard()),
                  ),
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 75),
                ),
                child: const Text("Personal Leaderboard"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}