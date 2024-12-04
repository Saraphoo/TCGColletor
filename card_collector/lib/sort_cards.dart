import 'package:card_collector/database_helper.dart';


/// Allows the user to sort by: Name, Most Owned, Least Owned, Most HP, Least HP, ID
abstract class SortCards { 
  ///Uses a list of all pokemon cards then reorders them based on what the user is sorting by. Returned list in sorted order. 
  Future<List<Map<String,dynamic>>> sortCards(List<Map<String,dynamic>> cards);
} 
class HandleSort {
  List<Map<String,dynamic>> selectionSort(List<Map<String,dynamic>> oldList, String sortBy) {
    List<Map<String,dynamic>> list = List.from(oldList);
    for (int i = 0; i < list.length; i++) {
      int minIndex = i;

      // Find the minimum element in unsorted array
      for (int j = i + 1; j < list.length; j++) {
        if(int.tryParse(list[j][sortBy]) != null){
          if (int.parse(list[j][sortBy]) < int.parse(list[minIndex][sortBy])) {
            minIndex = j;
          }
        }
      }

      // Swap the found minimum element with the first element
      Map<String,dynamic> temp = list[i];
      list[i] = list[minIndex];
    list[minIndex] = temp;
    }
    return list;
  }
  List<Map<String, dynamic>> reverseList(List<Map<String,dynamic>> list){
    List<Map<String,dynamic>> temp = [];
    for(int i = list.length - 1; i >= 0; i--){
      temp.add(list[i]);
    }
    return temp;
  }
}


///Sorts cards alphabetically 
class SortByName implements SortCards {
  @override 
  Future<List<Map<String,dynamic>>> sortCards(List<Map<String,dynamic>>cards) async{
      HandleSort handler = HandleSort();
      return handler.selectionSort(cards, 'name');
  }
} 
///Sorts cards by most cards owned 
///Defaults to alphabetical for equal number owned 
class SortByMostOwned implements SortCards{
  @override
  Future<List<Map<String,dynamic>>> sortCards(List<Map<String,dynamic>> cards) async{ 
    HandleSort handler = HandleSort();
    return handler.selectionSort(cards, 'numOwned');
  }
} 
///Sorts cards by least cards owned 
///Defaults to alphabetical for equal number owned 
class SortByLeastOwned implements SortCards{ 
  Future<List<Map<String,dynamic>>> sortCards(List<Map<String,dynamic>> cards) async{ 
    HandleSort handler = HandleSort();
    return handler.reverseList(handler.selectionSort(cards, 'numOwned'));
  }
} 
///Sorts cards by most HP 
///Defaults to alphabetical for equal HP 
class SortByMostHP implements SortCards{ 
  @override 
  Future<List<Map<String,dynamic>>> sortCards(List<Map<String,dynamic>> cards) async{ 
    HandleSort handler = HandleSort();
    return handler.selectionSort(cards, 'hp');
  } 
} 
///Sorts cards by least HP 
///Defaults to alphabetical for equal HP 
class SortByLeastHP implements SortCards{ 
  @override 
  Future<List<Map<String,dynamic>>> sortCards(List<Map<String,dynamic>> cards) async{ 
    HandleSort handler = HandleSort();
    return handler.reverseList(handler.selectionSort(cards, 'hp'));
  } 
} 
///Sorts cards by ID 
///Defaults to alphabetical for ID cards 
class SortByID implements SortCards{ 
  @override 
  Future<List<Map<String,dynamic>>> sortCards(List<Map<String,dynamic>> cards) async{ 
    HandleSort handler = HandleSort();
    return handler.selectionSort(cards, 'id');
  } 
} 

