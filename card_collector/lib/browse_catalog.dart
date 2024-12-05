import 'dart:isolate';

import 'package:flutter/material.dart';
import 'card_detail_page.dart';
import 'database_helper.dart';
import 'sort_cards.dart';
import 'filter_cards.dart';

class BrowseCatalogPage extends StatefulWidget {
  @override
  _BrowseCatalogPageState createState() => _BrowseCatalogPageState();
}


class HandleFilters{
  Future<bool> checkForFilter(List<Map<String,dynamic>> list) async{
    final dbHelper = DatabaseHelper();
    final cards = await dbHelper.fetchCards(); // Fetch cards from SQLite
    SortCards? sort;

    sort = SortByName();
    list = await sort.sortCards(list);
    if(cards.length == list.length){
      for(int i = 0; i < cards.length; i++){
        for (var key in list[i].keys) {
          if (list[i][key] != cards[i][key]){
            return true;
          }
        }
      }
    } else{
      return true;
    }
    return false;
  }
}

class _BrowseCatalogPageState extends State<BrowseCatalogPage> {
  late Future<List<Map<String, dynamic>>> cards;
  SortCards? sort;  
  bool isToggled = false;
  String? activeFilter;
  @override
  void initState() {
    super.initState();
    cards = fetchCardsFromDatabase();
  }

  Future<List<Map<String, dynamic>>> fetchCardsFromDatabase() async {
    final dbHelper = DatabaseHelper();
    final cards = await dbHelper.fetchCards(); // Fetch cards from SQLite
    return cards;
  }
  
  void callOwnedFilter(bool isToggled, Future<List<Map<String,dynamic>>> currentCards) async{
    FilterCards filter = FilterCards();
    print('callOwnedFilter');
    List<Map<String,dynamic>> list = await filter.filterOwned(await currentCards, isToggled);
    if(!isToggled){
      print(activeFilter);
      //print(sort.toString());
      if(activeFilter != null && activeFilter != 'None'){
        list = await filter.filterCards(activeFilter, list);
      }
      if(sort != null){
        list = await sort!.sortCards(list);
      }
    }
    setState(() {
      cards = Future.value(list);
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Card Catalog'),

        actions: [
           ElevatedButton(
            onPressed: () {
                isToggled = !isToggled;
                print('button pressed');
                callOwnedFilter(isToggled, cards);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isToggled ? Colors.green : Colors.grey, // Change color
            ),
            child: Text(
              isToggled ? 'Owned Cards' : 'All Cards', // Change text
              style: TextStyle(color: Colors.white),
            ),
          ),

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
                List<Map<String, dynamic>> sortedCards = await sort!.sortCards(currentCards);
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
                value: 'None',
                child: Text('None'),
              ),
              DropdownMenuItem(
                value: 'Colorless',
                child: Text('Colorless'),
              ),
              DropdownMenuItem(
                value: 'Darkness',
                child: Text('Darkness'),
              ),
              DropdownMenuItem(
                value: 'Dragon',
                child: Text('Dragon'),
              ),
              DropdownMenuItem(
                value: 'Lightning',
                child: Text('Lightning'),
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
                value: 'Grass',
                child: Text('Grass'),
              ),
              DropdownMenuItem(
                value: 'Psychic',
                child: Text('Psychic'),
              ),
              DropdownMenuItem(
                value: 'Metal',
                child: Text('Metal'),
              ),
              DropdownMenuItem(
                value: 'Water',
                child: Text('Water'),
              ),
            ],
            onChanged: (String? value) async {
              activeFilter = value;
              if(value != 'None'){
                FilterCards filter = FilterCards();
                List<Map<String,dynamic>> currentCards = await cards;
                HandleFilters handleFilters = HandleFilters();
                bool filtered = await handleFilters.checkForFilter(currentCards);
                List<Map<String, dynamic>> filteredCards;
                if(filtered){
                  DatabaseHelper dbhelper = DatabaseHelper();
                  List<Map<String, dynamic>> newCards = await dbhelper.fetchCards();
                  if(sort != null){
                    newCards = await sort!.sortCards(newCards);
                  }
                  filteredCards = await filter.filterCards(value, newCards);
                  print(filteredCards);
                } else {
                  filteredCards = await filter.filterCards(value, currentCards);
                  if(sort != null){
                    filteredCards = await sort!.sortCards(await cards);
                  }
                }
                
                if(isToggled){
                  callOwnedFilter(isToggled, Future.value(filteredCards));
                }
                
                
              setState(() {
                cards = Future.value(filteredCards);
              });
              } else {
                DatabaseHelper dbhelper = DatabaseHelper();
                List<Map<String, dynamic>> newCards = await dbhelper.fetchCards();
                if(sort != null){
                  newCards = await sort!.sortCards(newCards);
                }
                setState(() {
                  cards = Future.value(newCards);
                });
              }
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
