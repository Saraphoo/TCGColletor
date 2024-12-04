import 'package:flutter/material.dart';
import 'card_detail_page.dart';
import 'database_helper.dart';
import 'sort_cards.dart';
import 'filter_cards.dart';

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

          //Dropdown for sorting
          DropdownButton<String>(
            hint: Text('Sort Cards'),
            items: const [
              DropdownMenuItem(
                value: 'Alphabetical',
                child: Text('Alphabetical'),
              ),
              /**
              DropdownMenuItem(
                value: 'Most Cards Owned',
                child: Text('Most Cards Owned'),
              ),
              DropdownMenuItem(
                value: 'Least Cards Owned',
                child: Text('Least Cards Owned'),
              ),
              */
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
                List<Map<String,dynamic>> currentCards = await cards;
                List<Map<String, dynamic>> sortedCards = await sort.sortCards(currentCards);
                setState(() {
                  cards = Future.value(sortedCards);
                });
              }
            },
          ),
          const SizedBox(height: 20), // Space between dropdowns


          //Dropdown for filtering
          DropdownButton<String>(
            hint: Text('Filter Cards By Type'),
            items: const [
              DropdownMenuItem(
                value: 'Bug',
                child: Text('Bug'),
              ),
              DropdownMenuItem(
                value: 'Dark',
                child: Text('Dark'),
              ),
              DropdownMenuItem(
                value: 'Dragon',
                child: Text('Dragon'),
              ),
              DropdownMenuItem(
                value: 'Electric',
                child: Text('Electric'),
              ),
              DropdownMenuItem(
                value: 'Fairy',
                child: Text('Fairy'),
              ),
              DropdownMenuItem(
                value: 'Fighting',
                child: Text('Fighting'),
              ),
              DropdownMenuItem(
                value: 'Fire',
                child: Text('Fire'),
              ),
              DropdownMenuItem(
                value: 'Flying',
                child: Text('Flying'),
              ),
              DropdownMenuItem(
                value: 'Ghost',
                child: Text('Ghost'),
              ),
              DropdownMenuItem(
                value: 'Grass',
                child: Text('Grass'),
              ),
              DropdownMenuItem(
                value: 'Ground',
                child: Text('Ground'),
              ),
              DropdownMenuItem(
                value: 'Ice',
                child: Text('Ice'),
              ),
              DropdownMenuItem(
                value: 'Normal',
                child: Text('Normal'),
              ),
              DropdownMenuItem(
                value: 'Poison',
                child: Text('Poison'),
              ),
              DropdownMenuItem(
                value: 'Psychic',
                child: Text('Psychic'),
              ),
              DropdownMenuItem(
                value: 'Rock',
                child: Text('Rock'),
              ),
              DropdownMenuItem(
                value: 'Steel',
                child: Text('Steel'),
              ),
              DropdownMenuItem(
                value: 'Water',
                child: Text('Water'),
              ),
            ],
            onChanged: (String? value) async {
                FilterCards filter = FilterCards();
                List<Map<String,dynamic>> currentCards = await cards;
                List<Map<String, dynamic>> filteredCards = await filter.filterCards(value, currentCards);
                setState(() {
                  cards = Future.value(filteredCards);
                });
            }
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardDetailPage(card: card),
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
