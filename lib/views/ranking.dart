import 'dart:convert';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => RankingPageState();
}

class RankingPageState extends State<RankingPage> {
  final database = FirebaseDatabase.instance.ref();

  int prevFirstIndex = 0;
  int prevSecondIndex = 0;
  String firstImage =
      'assets/drinkImages/Original.png'; // Initial placeholder image
  String secondImage =
      'assets/drinkImages/Original.png'; // Initial placeholder image

  List<String> imagePaths = [];

  // Create a list containing the names of the images in the assets folder
  Future<List<String>> loadImagePaths(String path) async {
    List<String> imagePaths = [];

    try {
      // Load the asset manifest file
      String manifestContent =
          await rootBundle.loadString('AssetManifest.json');
      Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Get all asset paths under the specified directory
      List<String> assets =
          manifestMap.keys.where((String key) => key.startsWith(path)).toList();

      // Remove the 'packages/' prefix if present (for assets in packages)
      assets = assets.map((String asset) {
        return asset.replaceFirst('packages/', 'assets/packages/');
      }).toList();

      imagePaths = List<String>.from(assets);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading image paths: $e');
      }
    }

    return imagePaths;
  }

  @override
  void initState() {
    super.initState();
    // Load image paths when the widget is initialized
    loadImagePaths('assets/drinkImages/').then((paths) {
      setState(() {
        imagePaths = paths;
      });
    });
  }

  void changeImages() {
    if (imagePaths.isNotEmpty) {
      // Generate a random index to select a random image from the list
      int randomFirstIndex = Random().nextInt(imagePaths.length);
      int randomSecondIndex = Random().nextInt(imagePaths.length);
      while (randomFirstIndex == randomSecondIndex ||
          (randomFirstIndex == prevFirstIndex &&
              randomSecondIndex == prevSecondIndex)) {
        randomFirstIndex = Random().nextInt(imagePaths.length);
        randomSecondIndex = Random().nextInt(imagePaths.length);
      }

      // Update the state with the new image path
      setState(() {
        firstImage = imagePaths[randomFirstIndex];
        secondImage = imagePaths[randomSecondIndex];
        prevFirstIndex = randomFirstIndex;
        prevSecondIndex = randomSecondIndex;
      });
    }
  }

  void changeImagesFirstWinner() {
    if (imagePaths.isNotEmpty) {
      // Generate a random index to select a random image from the list
      int randomFirstIndex = Random().nextInt(imagePaths.length);
      int randomSecondIndex = Random().nextInt(imagePaths.length);
      while (randomFirstIndex == randomSecondIndex ||
          (randomFirstIndex == prevFirstIndex &&
              randomSecondIndex == prevSecondIndex)) {
        randomFirstIndex = Random().nextInt(imagePaths.length);
        randomSecondIndex = Random().nextInt(imagePaths.length);
      }

      const String pngString = '.png';
      const String prefix = 'assets/drinkImages/';
      String winnerString =
          firstImage.replaceAll(pngString, '').replaceAll(prefix, '');
      String loserString =
          secondImage.replaceAll(pngString, '').replaceAll(prefix, '');

      final nextMatchup = <String, dynamic>{
        'winner': winnerString,
        'loser': loserString
      };

      database
          .child('matchups')
          .push()
          .set(nextMatchup)
          .then((_) => print(
              "You have written to the database. First choice $winnerString won!"))
          .catchError((error) => print('ERROR! $error'));

      // Update the state with the new image path
      setState(() {
        firstImage = imagePaths[randomFirstIndex];
        secondImage = imagePaths[randomSecondIndex];
        prevFirstIndex = randomFirstIndex;
        prevSecondIndex = randomSecondIndex;
      });
    }
  }

  void changeImagesSecondWinner() {
    if (imagePaths.isNotEmpty) {
      // Generate a random index to select a random image from the list
      int randomFirstIndex = Random().nextInt(imagePaths.length);
      int randomSecondIndex = Random().nextInt(imagePaths.length);
      while (randomFirstIndex == randomSecondIndex ||
          (randomFirstIndex == prevFirstIndex &&
              randomSecondIndex == prevSecondIndex)) {
        randomFirstIndex = Random().nextInt(imagePaths.length);
        randomSecondIndex = Random().nextInt(imagePaths.length);
      }

      const String pngString = '.png';
      const String prefix = 'assets/drinkImages/';
      String loserString =
          firstImage.replaceAll(pngString, '').replaceAll(prefix, '');
      String winnerString =
          secondImage.replaceAll(pngString, '').replaceAll(prefix, '');

      final nextMatchup = <String, dynamic>{
        'winner': winnerString,
        'loser': loserString
      };

      database
          .child('matchups')
          .push()
          .set(nextMatchup)
          .then((_) => print(
              "You have written to the database. Second choice $winnerString won!"))
          .catchError((error) => print('ERROR! $error'));

      // Update the state with the new image path
      setState(() {
        firstImage = imagePaths[randomFirstIndex];
        secondImage = imagePaths[randomSecondIndex];
        prevFirstIndex = randomFirstIndex;
        prevSecondIndex = randomSecondIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    changeImages();
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Rank the Monsters!',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: changeImagesFirstWinner,
                icon: Image(
                  image: AssetImage(firstImage),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: changeImagesSecondWinner,
                icon: Image(
                  image: AssetImage(secondImage),
                ),
              ),
            ),
          ],
        ), // Make a grid that fits two IconButtons, such that the first IconButton fills the top half of the screen and the second IconButton fills the bottom half of the screen
      ),
    );
  }
}
