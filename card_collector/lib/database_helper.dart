import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart'; // For platform-specific checks
import 'dart:io'; // For platform detection
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    // Assert to ensure databaseFactory is initialized
    assert(databaseFactory != null,
        'databaseFactory must be initialized before accessing the database.');

    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pokemon.db');

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 2, // Increment this version
        onCreate: (db, version) async {
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

          await db.execute('''
          CREATE TABLE wish (
            id TEXT PRIMARY KEY, -- Card ID
            timestamp TEXT -- Timestamp of when the card was marked as wished
          )
        ''');

          debugPrint('Database created with tables: cards, wish');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('''
            CREATE TABLE wish (
              id TEXT PRIMARY KEY, -- Card ID
              timestamp TEXT -- Timestamp of when the card was marked as wished
            )
          ''');
            debugPrint('Database upgraded: wish table added');
          }
        },
      ),
    );
  }


  /// Fetch all cards from the database
  Future<List<Map<String, dynamic>>> fetchCards() async {
    final db = await database;
    return await db.query('cards', orderBy: 'name ASC');
  }

  /// Insert multiple cards into the database
  Future<void> insertCards(List<Map<String, dynamic>> cards) async {
    final db = await database;
    final batch = db.batch();

    for (var card in cards) {
      batch.insert(
        'cards',
        card,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  ///Insert wished card into the database
  Future<void> addWish(String cardId) async {
    final db = await database;
    await db.insert(
      'wish',
      {
        'id': cardId,
        'timestamp': DateTime.now().toIso8601String(), // Current timestamp
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace if exists
    );
  }

  ///Remove wished card into the database
  Future<void> removeWish(String cardId) async {
    final db = await database;
    await db.delete(
      'wish',
      where: 'id = ?',
      whereArgs: [cardId],
    );
  }

  ///Check if a card is wished for
  Future<bool> isWished(String cardId) async {
    final db = await database;
    final result = await db.query(
      'wish',
      where: 'id = ?',
      whereArgs: [cardId],
    );
    return result.isNotEmpty; // Returns true if the card is found
  }
}
