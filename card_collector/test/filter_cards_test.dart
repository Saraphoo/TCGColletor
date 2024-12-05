import 'package:card_collector/filter_cards.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('filterCards() should filter a list of maps based on given criteria', () async{
    List<Map<String,dynamic>> cards = [    
    {'name': 'Sarah', 'types': ['Grass']},
    {'name': 'Drew', 'types': ['Dragon']},
    {'name': 'Pikachew', 'types': ['Water']},
    ];
    List<Map<String,dynamic>> expectedCards1 = [
      {'name': 'Sarah', 'types': ['Grass']},
    ];
    List<Map<String,dynamic>> expectedCards2 = [
      {'name': 'Drew', 'types': ['Dragon']},
    ];
    FilterCards filter = FilterCards();
    expect(await filter.filterCards('Grass', cards), equals(expectedCards1));
    expect(await filter.filterCards('Dragon', cards), equals(expectedCards2));
  });
}