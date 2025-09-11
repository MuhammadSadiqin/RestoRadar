import 'package:resto_radar/data/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  static const String _databaseName = 'restaurant-app.db';
  static const String _tableName = 'restaurants';
  static const int _version = 1;

  // Singleton pattern
  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();
  factory LocalDatabaseService() => _instance;
  LocalDatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDb();
    return _database!;
  }

  Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE $_tableName(
       id TEXT PRIMARY KEY,
       name TEXT,
       description TEXT,
       pictureId TEXT,
       city TEXT,
       rating REAL
     )
     """);
  }

  Future<Database> _initializeDb() async {
    return openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<int> insertRestaurant(Restaurant restaurant) async {
    final db = await database; // Gunakan singleton pattern

    final data = restaurant.toJson();
    final id = await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Restaurant>> getAllRestaurants() async {
    final db = await database; // Gunakan singleton pattern
    final results = await db.query(_tableName);

    return results.map((result) => Restaurant.fromJson(result)).toList();
  }

  Future<Restaurant?> getRestaurantById(String id) async {
    final db = await database; // Gunakan singleton pattern
    final results = await db.query(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    return results.isEmpty ? null : Restaurant.fromJson(results.first);
  }

  Future<int> removeRestaurant(String id) async {
    final db = await database;
    final result = await db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
    );
    return result;
  }
}
