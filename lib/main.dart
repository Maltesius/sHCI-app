import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monster Ranker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Monster Ranker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  get homePage => const RankingPage();
  get secondPage => const SecondPage();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
        ],
        animationDuration: const Duration(milliseconds: 1000),
      ),
      body: [homePage,secondPage][currentPageIndex],
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => RankingPageState();
}

class RankingPageState extends State<RankingPage>{
  // Create a list containing the names of the images in the assets folder
  Future<List<String>> loadImagePaths(String path) async {
    List<String> imagePaths = [];

    try {
      // Load the asset manifest file
      String manifestContent = await rootBundle.loadString('AssetManifest.json');
      Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Get all asset paths under the specified directory
      List<String> assets = manifestMap.keys
          .where((String key) => key.startsWith(path))
          .toList();

      // Remove the 'packages/' prefix if present (for assets in packages)
      assets = assets.map((String asset) {
        return asset.replaceFirst('packages/', 'assets/packages/');
      }).toList();

      imagePaths = List<String>.from(assets);
    } catch (e) {
      print('Error loading image paths: $e');
    }

    return imagePaths;
  }

  int prevFirstIndex = 0;
  int prevSecondIndex = 0;
  String firstImage = 'assets/drinkImages/lilla.png'; // Initial placeholder image
  String secondImage = 'assets/drinkImages/lilla.png'; // Initial placeholder image
  late List<String> imagePaths;

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
      while (randomFirstIndex == randomSecondIndex || (randomFirstIndex == prevFirstIndex && randomSecondIndex == prevSecondIndex)) {
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child:
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(onPressed: changeImages, icon: Image(
                    image: AssetImage(firstImage),
                    ),
                    ),
                  ),
                Expanded(
                  flex: 1,
                  child: IconButton(onPressed: changeImages, icon: Image(
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

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Text(
          'Second Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}


