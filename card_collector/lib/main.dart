import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pokemon_tcg_service.dart';
import 'database_helper.dart';
import 'landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: "../../.env");

  // Initialize data
  await initializeData();

  // Run the app
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
        '/browse': (context) => PlaceholderPage('Browse Card Catalog'),
        '/your_catalog': (context) => PlaceholderPage('Your Card Catalog'),
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


Future<void> initializeData() async {
  final pokemonService = PokemonTCGService();
  final dbHelper = DatabaseHelper();

  try {
    print('Checking for existing cards in the database...');
    final existingCards = await dbHelper.fetchCards();

    if (existingCards.isEmpty) {
      print('No cards found in the database. Fetching from API...');
      final cards = await pokemonService.fetchCards();
      print('Fetched ${cards.length} cards successfully.');

      print('Saving cards to database...');
      await dbHelper.insertCards(cards);
      print('Cards saved to database successfully.');
    } else {
      print('Cards already exist in the database. Skipping API call.');
    }
  } catch (error) {
    print('Error during data initialization: $error');
  }
}
