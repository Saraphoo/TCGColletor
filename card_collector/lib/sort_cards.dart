import 'package:card_collector/database_helper.dart';


/// Allows the user to sort by: Name, Most Owned, Least Owned, Most HP, Least HP, ID
abstract class SortCards { 
  ///Uses an list of all pokemon cards then reorders them based on what the user is sorting by. Returned list in sorted order. 
  Future<List<Map<String,dynamic>>> sortCards();
} 

///Sorts cards alphabetically 
class SortByName implements SortCards {
  @override 
  Future<List<Map<String,dynamic>>> sortCards() async{
      DatabaseHelper dbHelper = DatabaseHelper();
      List<Map<String, dynamic>> data = await dbHelper.fetchCards();
      data.sort((a, b) => a['name'].compareTo(b['name']));
      return data;
  }
} 
///Sorts cards by most cards owned 
///Defaults to alphabetical for equal number owned 
class SortByMostOwned implements SortCards{
  @override
  Future<List<Map<String,dynamic>>> sortCards() async{ 
      DatabaseHelper dbHelper = DatabaseHelper();
      List<Map<String, dynamic>> data = await dbHelper.fetchCards();
      data.sort((a, b) {
        int i = a['numOwned'].compareTo(b['numOwned']);
        if(i != 0){
          return i;
        }
        return a['name'].compareTo(b['name']);
      });
      return data;
  }
} 
///Sorts cards by least cards owned 
///Defaults to alphabetical for equal number owned 
class SortByLeastOwned implements SortCards{ 
  @override
  Future<List<Map<String,dynamic>>> sortCards() async{ 
      DatabaseHelper dbHelper = DatabaseHelper();
      List<Map<String, dynamic>> data = await dbHelper.fetchCards();
      data.sort((a, b) {
        int i = b['numOwned'].compareTo(a['numOwned']);
        if(i != 0){
          return i;
        }
        return a['name'].compareTo(b['name']);
      });
      return data;
  }
} 
///Sorts cards by most HP 
///Defaults to alphabetical for equal HP 
class SortByMostHP implements SortCards{ 
  @override 
  Future<List<Map<String,dynamic>>> sortCards() async{ 
        DatabaseHelper dbHelper = DatabaseHelper();
      List<Map<String, dynamic>> data = await dbHelper.fetchCards();
      data.sort((a, b) {
        int i = a['HP'].compareTo(b['HP']);
        if(i != 0){
          return i;
        }
        return a['name'].compareTo(b['name']);
      });
      return data;
  } 
} 
///Sorts cards by least HP 
///Defaults to alphabetical for equal HP 
class SortByLeastHP implements SortCards{ 
  @override 
  Future<List<Map<String,dynamic>>> sortCards() async{ 
      DatabaseHelper dbHelper = DatabaseHelper();
      List<Map<String, dynamic>> data = await dbHelper.fetchCards();
      data.sort((a, b) {
        int i = b['HP'].compareTo(a['HP']);
        if(i != 0){
          return i;
        }
        return a['name'].compareTo(b['name']);
      });
      return data;
  } 
} 
///Sorts cards by ID 
///Defaults to alphabetical for ID cards 
class SortByID implements SortCards{ 
  @override 
  Future<List<Map<String,dynamic>>> sortCards() async{ 
DatabaseHelper dbHelper = DatabaseHelper();
      List<Map<String, dynamic>> data = await dbHelper.fetchCards();
      data.sort((a, b) {
        int i = b['id'].compareTo(a['id']);
        if(i != 0){
          return i;
        }
        return a['name'].compareTo(b['name']);
      });
      return data;
  } 
} 

