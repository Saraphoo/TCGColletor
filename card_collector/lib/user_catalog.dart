import 'package:flutter/material.dart';
import 'card_detail_page.dart';
import 'database_helper.dart';
import 'sort_cards.dart';
import 'filter_cards.dart';

class UserCatalogPage extends StatefulWidget {
  @override
  _UserCatalogPageState createState() => _UserCatalogPageState();
}

class _UserCatalogPageState extends State<UserCatalogPage> {
  late Future<List<Map<String, dynamic>>> cards;
  SortCards? sort;

  @override
  void initState() {
    super.initState();
    cards = fetchOwnedCardsFromDatabase();
  }

  /// Fetch cards from the database that are in the owned table
  Future<List<Map<String, dynamic>>> fetchOwnedCardsFromDatabase() async {
    final dbHelper = DatabaseHelper();
    final ownedCardIds = await dbHelper.fetchOwnedIds();
    final allCards = await dbHelper.fetchCards();

    // Filter all cards to include only those with IDs in ownedCardIds
    final ownedCards = allCards.where((card) => ownedCardIds.contains(card['id'])).toList();
    return ownedCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Card Catalog'),
        actions: [
          // Dropdown for sorting
          DropdownButton<String>(
            hint: Text('Sort Cards'),
            items: const [
              DropdownMenuItem(
                value: 'Alphabetical',
                child: Text('Alphabetical'),
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
              switch (value) {
                case 'Alphabetical':
                  sort = SortByName();
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
                List<Map<String, dynamic>> currentCards = await cards;
                List<Map<String, dynamic>> sortedCards = await sort!.sortCards(currentCards);
                setState(() {
                  cards = Future.value(sortedCards);
                });
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
            return Center(child: Text('No owned cards found.'));
          } else {
            final cardList = snapshot.data!;
            return ListView.builder(
              itemCount: cardList.length,
              itemBuilder: (context, index) {
                final card = cardList[index];
                return ListTile(
                  title: Text(card['name']),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardDetailPage(card: card, cards: cardList, index: index),
                      ),
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
