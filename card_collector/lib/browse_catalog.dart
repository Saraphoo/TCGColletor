import 'package:flutter/material.dart';
import 'database_helper.dart';

class BrowseCatalogPage extends StatefulWidget {
  @override
  _BrowseCatalogPageState createState() => _BrowseCatalogPageState();
}

class _BrowseCatalogPageState extends State<BrowseCatalogPage> {
  late Future<List<Map<String, dynamic>>> cards;

  @override
  void initState() {
    super.initState();
    cards = fetchCardsFromDatabase();
  }

  Future<List<Map<String, dynamic>>> fetchCardsFromDatabase() async {
    final dbHelper = DatabaseHelper();
    return await dbHelper.fetchCards(); // Fetch cards from SQLite
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Card Catalog'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: cards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching cards: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cards found.'));
          } else {
            final cardList = snapshot.data!;
            return ListView.builder(
              itemCount: cardList.length,
              itemBuilder: (context, index) {
                final card = cardList[index];
                return ListTile(
                  title: Text(card['name']),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/card_detail',
                      arguments: card, // Pass the card data to the detail page
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
