import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ranking/ranking.dart';

class Leaderboard extends StatelessWidget {
  final _database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monster Energy Leaderboard'),
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
                        (snapshot.data! as DatabaseEvent).snapshot.value
                            as Map<dynamic, dynamic>);
                    int mapSize = myMatchups.length;

                    print('Size of the map: $mapSize');
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

                    sortedScores.forEach((drink, score) {
                      final orderTile = ListTile(
                        leading: Image(
                            image: AssetImage('assets/drinkImages/$drink.png')),
                        title:
                            Text(drink, style: TextStyle(fontFamily: 'Noto')),
                        minVerticalPadding: 22,
                      );
                      tilesList.add(orderTile);
                    });
                    return Expanded(
                      child: ListView(
                        children: tilesList,
                      ),
                    );
                  } else {
                    return Expanded(
                        child: SizedBox(
                          child: Center(
                            child: CircularProgressIndicator(),
                          heightFactor: 100,
                          widthFactor: 100,
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
