import 'dart:convert';
import 'database_helper.dart';

class FilterCards {
  Future<List<Map<String, dynamic>>> filterCards(String? selectedType, List<Map<String,dynamic>> cards) async {
    if (selectedType == null) {
      return [];
    }

    DatabaseHelper dbHelper = DatabaseHelper();
    //cards = await dbHelper.fetchCards();
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
