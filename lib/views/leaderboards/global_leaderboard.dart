import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ranking/ranking.dart';

class GlobalLeaderboard extends StatelessWidget {
  final _database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Global Leaderboard',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          children: [
            StreamBuilder(
                stream: _database.child('matchups').orderByKey().onValue,
                builder: (context, snapshot) {
                  final tilesList = <ListTile>[];
                  List<List<dynamic>> matchupList = [[]];

                  if (snapshot.hasData &&
                      snapshot.data?.snapshot.value != null) {
                    final myMatchups = Map<String, dynamic>.from(
                        (snapshot.data!).snapshot.value
                            as Map<dynamic, dynamic>);
                    myMatchups.forEach((key, value) {
                      final nextMatchup = Map<String, dynamic>.from(value);
                      if (matchupList == [[]]) {
                        matchupList = [
                          [nextMatchup['winner'], nextMatchup['loser']]
                        ];
                      } else {
                        matchupList
                            .add([nextMatchup['winner'], nextMatchup['loser']]);
                      }
                    });

                    // Hack Alert!!! Removed the first element of the list because it is empty
                    matchupList.removeAt(0);

                    Map<dynamic, double> scores =
                        computeBradleyTerryScores(matchupList);
                    Map<dynamic, double> sortedScores = Map.fromEntries(
                        scores.entries.toList()
                          ..sort((e1, e2) => e2.value.compareTo(e1.value)));
                    sortedScores.forEach((drink, score) {
                      print("$drink -> $score");
                    });

                    final sortedScoresList = [];
                    sortedScores.forEach((key, value) {sortedScoresList.add((key,value)); });

                    sortedScores.forEach((drink, score) {
                      int index = sortedScoresList.indexOf((drink, score)) + 1;
                      bool isFirstPlace = index == 1;
                      bool isSecondPlace = index == 2;
                      bool isThirdPlace = index == 3;
                      final orderTile = ListTile(
                        leading: Image(
                            image: AssetImage('assets/drinkImages/$drink.png')),
                        title: Text(drink,
                            style: const TextStyle(fontFamily: 'Noto')),
                        trailing: isFirstPlace ? Icon(Icons.looks_one_rounded) : isSecondPlace ? Icon(Icons.looks_two_rounded) : isThirdPlace ? Icon(IconData(0xf88c, fontFamily: 'MaterialIcons')) : Padding(padding: EdgeInsets.fromLTRB(0, 0, 9, 0), child: Text('$index', style: const TextStyle(fontFamily: 'Noto',fontWeight: FontWeight.w700 )),),// index of current tile
                        minVerticalPadding: 22,
                        tileColor: isFirstPlace ? Colors.amber : isSecondPlace ? Colors.grey : isThirdPlace ? Colors.brown : Colors.white,
                      );
                      tilesList.add(orderTile);
                    });
                    return Expanded(
                      child: ListView(
                        children: tilesList,
                      ),
                    );
                  } else {
                    return const Expanded(
                        child: SizedBox(
                      child: Center(
                        heightFactor: 100,
                        widthFactor: 100,
                        child: CircularProgressIndicator(),
                      ),
                    ));
                  }
                }),
          ],
        ),
      ),
    );
  }
}

/*
final orderTile = ListTile(
                        leading: Icon(Icons.stars),
                        title: Text(nextMatchup['winner']),
                        subtitle: Text(nextMatchup['loser']));

tilesList.add(orderTile);
*/
