import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Future<Database> initializeDatabase() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    return await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE cards (
            id TEXT PRIMARY KEY,
            quantity INTEGER
          )
        ''');
      },
    );
  }

  Future<List<String>> fetchOwnedIds(Database db) async {
    final results = await db.query('cards', columns: ['id']);
    return results.map((row) => row['id'] as String).toList();
  }

  Future<List<Map<String, dynamic>>> getAllCards(Database database) async {
    return await database.query('cards');
  }
}

void main() async {
  Database database;
  late DatabaseService databaseService;
  databaseService = DatabaseService();
  database = await databaseService.initializeDatabase();

  test('insertCards() inserts cards into the database', () async {
    await database.insert('cards', {
      'id': '1',
      'quantity': 0,
    });
    List<String> fetchedIDs = await databaseService.fetchOwnedIds(database);
    expect(fetchedIDs, equals(['1']));
  });
}
