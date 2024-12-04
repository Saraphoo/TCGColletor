import 'dart:convert';
import 'database_helper.dart';

class FilterCards {
  Future<List<Map<String,dynamic>>> filterOwned(List<Map<String,dynamic>> cards, bool isToggled) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    if(isToggled){
    print('isToggled');
        List<Map<String,dynamic>> newCards = [];
        List<Map<String,dynamic>> ownedCards = await dbHelper.queryOwned();
        for(int i = 0; i < cards.length; i++){
          for(int j = 0; j < ownedCards.length; j++){
            if(cards[i]['id'] == ownedCards[j]['id']){
              newCards.add(cards[i]);
            }
          }
        }
        return newCards;
    } else{
      print('!isToggled');
      return dbHelper.fetchCards();
    }
  }
  Future<List<Map<String, dynamic>>> filterCards(String? selectedType, List<Map<String,dynamic>> cards) async {
    if (selectedType == null) {
      return [];
    }

    List<Map<String, dynamic>> filteredCards = [];

    for (var card in cards) {
      var types = card['types'];

      //Decode JSON string so types can be compared properly
      if (types is String) {
        try {
          types = jsonDecode(types);
        } catch (e) { //Makes sure nothing breaks when decoding
          print('Error decoding types for card: ${card['name']} - $e');
          continue;
        }
      }

      if (types == null || types is! List) {
        print('Skipping card with invalid types field: ${card['name']}');
        continue;
      }

      //Fixes output so the types can be compared properly
      types = types.map((e) => e.toString().toLowerCase().trim()).toList();
      String normalizedSelectedType = selectedType.toLowerCase().trim();

      //Checks to see if any types of the card match the type being filtered
      bool matchFound = false;
      for (var type in types) {
        if (type == normalizedSelectedType) {
          matchFound = true;
          break;
        }
      }

      //If the type was found, add it to a final List to return 
      if (matchFound) {
        filteredCards.add(card);
      }
    }
    return filteredCards; //Return filteredCards so they can be updated
  }
}
