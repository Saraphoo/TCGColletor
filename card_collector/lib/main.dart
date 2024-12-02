import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io'; // For platform detection
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'pokemon_tcg_service.dart';
import 'database_helper.dart';
import 'landing_page.dart';
import 'browse_catalog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database factory for desktop platforms
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    print('Initializing database factory for desktop...');
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi; // Proper initialization
    print('Database factory initialized.');
  } else {
    print('Skipping database factory initialization for non-desktop platforms.');
  }

  // Load environment variables
  print('Loading environment variables...');
  await dotenv.load(fileName: "../../.env");

  // Initialize data after database factory is initialized
  print('Initializing data...');
  await initializeData();

  // Run the app
  print('Starting the app...');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Card Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Initial route is the landing page
      routes: {
        '/': (context) => LandingPage(),
        '/browse': (context) => BrowseCatalogPage(),
        '/your_catalog': (context) => PlaceholderPage('Your Card Catalog'),
        '/card_detail': (context) => PlaceholderPage('Card Detail'),
      },
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  PlaceholderPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          '$title - Page Under Construction',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}

/// Initialize data by fetching from API or loading from the database
Future<void> initializeData() async {
  final pokemonService = PokemonTCGService();
  final dbHelper = DatabaseHelper();

  try {
    print('Checking for existing cards in the database...');
    final existingCards = await dbHelper.fetchCards();

    if (existingCards.isEmpty) {
      print('No cards found in the database. Fetching from API or file...');
      final cards = await pokemonService.loadData();
      print('Fetched ${cards.length} cards successfully.');

      print('Saving cards to database...');
      await dbHelper.insertCards(cards);
      print('Cards saved to database successfully.');
    } else {
      print('Cards already exist in the database. Skipping data load.');
    }
  } catch (error) {
    print('Error during data initialization: $error');
  }
}
