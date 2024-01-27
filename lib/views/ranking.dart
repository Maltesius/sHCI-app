import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

import '../database/Matchup.dart';
import '../database/database_service.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => RankingPageState();
}

class RankingPageState extends State<RankingPage> {
  final database = FirebaseDatabase.instance.ref();
  final Matchup? matchup;

  RankingPageState({Key? key, this.matchup});

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

  Future<void> changeImagesFirstWinner() async {
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
          .then((_) => debugPrint(
              "You have written to the database. First choice $winnerString won!"))
          .catchError((error) => debugPrint('ERROR! $error'));

      final Matchup model = Matchup(
          id: Random().nextInt(10000000),
          winner: winnerString,
          loser: loserString);
      if (matchup == null) {
        try {
          DatabaseService.addMatchup(model);
        } catch (e) {
          throw Future.error(e);
        }
      } else {
        try {
          DatabaseService.updateMatchup(model);
        } catch (e) {
          throw Future.error(e);
        }
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
          .then((_) => debugPrint(
              "You have written to the database. Second choice $winnerString won!"))
          .catchError((error) => debugPrint('ERROR! $error'));

      final Matchup model = Matchup(
          id: Random().nextInt(10000000),
          winner: winnerString,
          loser: loserString);
      if (matchup == null) {
        try {
          DatabaseService.addMatchup(model);
        } catch (e) {
          throw Future.error(e);
        }
      } else {
        try {
          DatabaseService.updateMatchup(model);
        } catch (e) {
          throw Future.error(e);
        }
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

  String versusAsset = 'assets/versus.png';

  @override
  Widget build(BuildContext context) {
    changeImages();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
          flexibleSpace: ClipRect(child:
          BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: const Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0),child: Text(
            'MONSTER RANKER',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),),),)),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
      bottom: PreferredSize(preferredSize: const Size.fromHeight(2.0), child: Container(color: Colors.white, height: 2.0,)),),
      body: DecoratedBox(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg.png"), fit: BoxFit.fill)),
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Padding(padding: const EdgeInsets.fromLTRB(0, 80, 0, 0), child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 140, 40),
                      child: IconButton(
                        onPressed: changeImagesSecondWinner,
                        icon: Transform.rotate(
                          angle: 0.25,
                          child: Image(
                            width: 300,
                            image: AssetImage(firstImage),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(140, 40, 0, 10),
                      child: IconButton(
                        onPressed: changeImagesSecondWinner,
                        icon: Transform.rotate(
                          angle: 0.25,
                          child: Image(
                            width: 300,
                            image: AssetImage(secondImage),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Image(
                  image: AssetImage(versusAsset),
                  height: 190,
                ),
              )
            ],
          ),),
        ),
      ),
      backgroundColor: Colors.grey.shade900,
    );
  }
}
