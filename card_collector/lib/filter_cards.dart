import 'package:card_collector/database_helper.dart';

class FilterCards{

  Future<List<Map<String,dynamic>>> filterCards(String sort) async{
      List<Map<String,dynamic>> filteredCards = [];
      DatabaseHelper dbHelper = DatabaseHelper();
      List<Map<String, dynamic>> data = await dbHelper.fetchCards();
      for(int i = 0; i < data.length; i++){
        if(data[i].containsValue(sort)){
          filteredCards.add(data[i]);
        }
      }
      return filteredCards;
  }
} 