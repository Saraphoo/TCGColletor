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
            name TEXT,
            supertype TEXT,
            subtypes TEXT,
            hp TEXT,
            types TEXT,
            evolvesTo TEXT,
            rules TEXT,
            attacks TEXT,
            weaknesses TEXT,
            resistances TEXT,
            retreatCost TEXT,
            convertedRetreatCost INTEGER,
            "set" TEXT,
            rarity TEXT,
            artist TEXT,
            number TEXT,
            nationalPokedexNumbers TEXT,
            legalities TEXT,
            smallImage TEXT,
            largeImage TEXT,
            tcgplayer_url TEXT,
            tcgplayer_prices TEXT
          )
        ''');
      },
    );
  }

  void insertCards(List<Map<String, dynamic>> cards, Database database) async {
    final batch = database.batch();
    for (var card in cards) {
      batch.insert(
        'cards',
        card,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
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
  final cards = [
    {
      'id': '1',
      'name': 'Card One',
      'supertype': null,
      'subtypes': null,
      'hp': null,
      'types': null,
      'evolvesTo': null,
      'rules': null,
      'attacks': null,
      'weaknesses': null,
      'resistances': null,
      'retreatCost': null,
      'convertedRetreatCost': null,
      'set': null,
      'rarity': null,
      'artist': null,
      'number': null,
      'nationalPokedexNumbers': null,
      'legalities': null,
      'smallImage': null,
      'largeImage': null,
      'tcgplayer_url': null,
      'tcgplayer_prices': null,
    },
  ];
  
  databaseService.insertCards(cards, database);
  final allCards = await databaseService.getAllCards(database);
  final card = allCards[0];
    expect(card.isNotEmpty, true);
    expect(card['id'], '1');
    expect(card['name'], 'Card One');
    expect(card['supertype'], null);
    expect(card['subtypes'], null);
    expect(card['hp'], null);
    expect(card['types'], null);
    expect(card['evolvesTo'], null);
    expect(card['rules'], null);
    expect(card['attacks'], null);
    expect(card['weaknesses'], null);
    expect(card['resistances'], null);
    expect(card['retreatCost'], null);
    expect(card['convertedRetreatCost'], null);
    expect(card['set'], null);
    expect(card['rarity'], null);
    expect(card['artist'], null);
    expect(card['number'], null);
    expect(card['nationalPokedexNumbers'], null);
    expect(card['legalities'], null);
    expect(card['smallImage'], null);
    expect(card['largeImage'], null);
    expect(card['tcgplayer_url'], null);
    expect(card['tcgplayer_prices'], null);
});
}