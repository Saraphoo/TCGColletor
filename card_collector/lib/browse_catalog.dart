import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'sort_cards.dart';

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
    final cards = await dbHelper.fetchCards(); // Fetch cards from SQLite
    print('Fetched cards: $cards');  // Log the fetched cards to the console
    return cards;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Card Catalog'),
        actions: [
          DropdownButton<String>(
            hint: Text('Sort Cards'),
            items: const [
              DropdownMenuItem(
                value: 'Alphabetical',
                child: Text('Alphabetical'),
              ),
              DropdownMenuItem(
                value: 'Most Cards Owned',
                child: Text('Most Cards Owned'),
              ),
              DropdownMenuItem(
                value: 'Least Cards Owned',
                child: Text('Least Cards Owned'),
              ),
              DropdownMenuItem(
                value: 'Most HP',
                child: Text('Most HP'),
              ),
              DropdownMenuItem(
                value: 'Least HP',
                child: Text('Least HP'),
              ),
              DropdownMenuItem(
                value: 'ID',
                child: Text('ID'),
              ),
            ],
            onChanged: (String? value) async {
              SortCards? sort;
              switch(value){
                case 'Alphabetical':
                  sort = SortByName();
                  break;
                case 'Most Cards Owned':
                  sort = SortByMostOwned();
                  break;
                case 'Least Cards Owned':
                  sort = SortByLeastOwned();
                  break;
                case 'Most HP':
                  sort = SortByMostHP();
                  break;
                case 'Least HP':
                  sort = SortByLeastHP();
                  break;
                case 'ID':
                  sort = SortByID();
                  break;
                default:
                  debugPrint('Sort type was not detected properly');
                  break;
              }
              if (sort != null) {
                List<Map<String, dynamic>> sortedCards = await sort.sortCards();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: cards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching cards: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cards found.')); //Always triggers
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
