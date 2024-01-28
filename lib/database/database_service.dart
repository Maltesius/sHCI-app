import 'package:navbar/database/Matchup.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const int _version = 1;
  static const String _dbName = 'matchup_database.db';

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE Matchup(id INTEGER PRIMARY KEY, winner TEXT NOT NULL, loser TEXT NOT NULL);"),
        version: _version);
  }

  static Future<int> addMatchup(Matchup matchup) async {
    final db = await _getDB();
    return await db.insert("Matchup", matchup.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateMatchup(Matchup matchup) async {
    final db = await _getDB();
    return await db.update("Matchup", matchup.toJson(),
        where: 'id = ?',
        whereArgs: [matchup.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Matchup>?> getAllMatchups() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Matchup");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Matchup.fromJson(maps[index]));
  }
}
