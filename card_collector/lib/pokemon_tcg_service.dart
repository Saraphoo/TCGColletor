import 'dart:convert';
import 'dart:io' show File; // For file handling on non-web platforms
import 'package:flutter/foundation.dart'; // For web detection and debugPrint
import 'package:file_picker/file_picker.dart'; // For file picking
import 'package:http/http.dart' as http;

class PokemonTCGService {
  final String baseUrl = 'https://api.pokemontcg.io/v2/cards';

  /// Fetch Pokémon card data from the API
  Future<List<Map<String, dynamic>>> fetchCardsFromAPI() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      debugPrint('Connected to API...'); 
      final data = json.decode(response.body)['data'];
      return data.map<Map<String, dynamic>>((card) {
        return _parseCard(card);
      }).toList();
    } else {
      throw Exception('Failed to fetch cards from API: ${response.statusCode}');
    }
  }

  /// Load Pokémon card data from a local file
  Future<List<Map<String, dynamic>>> fetchCardsFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['json'],
      type: FileType.custom,
    );

    if (result == null || result.files.isEmpty) {
      throw Exception('No file selected');
    }

    final file = result.files.first;

    if (kIsWeb) {
      if (file.bytes != null) {
        final String data = String.fromCharCodes(file.bytes!);
        return parseCardsFromJson(data);
      } else {
        throw Exception('Unable to read file bytes on web');
      }
    } else {
      if (file.path != null) {
        final filePath = file.path!;
        final String data = await File(filePath).readAsString();
        return parseCardsFromJson(data);
      } else {
        throw Exception('Unable to read file path on non-web platform');
      }
    }
  }

  List<Map<String, dynamic>> parseCardsFromJson(String jsonString) {
    final Map<String, dynamic> decoded = json.decode(jsonString);

    if (decoded.containsKey('data')) {
      final data = decoded['data'];

      if (data is Map) {
        // If 'data' is a single card object, cast it as Map<String, dynamic>
        return [data as Map<String, dynamic>];
      } else if (data is List) {
        // If 'data' is a list of cards, cast each item
        return List<Map<String, dynamic>>.from(data.map((e) => e as Map<String, dynamic>));
      }
    }

    throw Exception('Invalid JSON format for cards data.');
  }



  /// Main function to load data either from API or file picker
  Future<List<Map<String, dynamic>>> loadData() async {
    if (kIsWeb) {
      try {
        debugPrint('Attempting to fetch data from API...');
        final apiData = await fetchCardsFromAPI();
        debugPrint('Successfully fetched data from API.');
        return apiData;
      } catch (apiError) {
        debugPrint('API fetch failed: $apiError');
        debugPrint('Falling back to file upload...');
        final fileData = await fetchCardsFromFile();
        debugPrint('Successfully loaded data from file.');
        return fileData;
      }
    } else {
      debugPrint('Fetching data from API on non-web platform...');
      return await fetchCardsFromAPI();
    }
  }

  /// Parse a single card from the API or file data
  Map<String, dynamic> _parseCard(Map<String, dynamic> card) {
    return {
      'id': card['id'],
      'name': card['name'],
      'supertype': card['supertype'],
      'subtypes': json.encode(card['subtypes'] ?? []),
      'hp': card['hp'],
      'types': json.encode(card['types'] ?? []),
      'evolvesTo': json.encode(card['evolvesTo'] ?? []),
      'rules': json.encode(card['rules'] ?? []),
      'attacks': json.encode(card['attacks'] ?? []),
      'weaknesses': json.encode(card['weaknesses'] ?? []),
      'resistances': json.encode(card['resistances'] ?? []),
      'retreatCost': json.encode(card['retreatCost'] ?? []),
      'convertedRetreatCost': card['convertedRetreatCost'],
      'set': json.encode(card['set']),
      'rarity': card['rarity'],
      'artist': card['artist'],
      'number': card['number'],
      'nationalPokedexNumbers': json.encode(card['nationalPokedexNumbers'] ?? []),
      'legalities': json.encode(card['legalities']),
      'smallImage': card['images']['small'],
      'largeImage': card['images']['large'],
      'tcgplayer_url': card['tcgplayer']?['url'] ?? '',
      'tcgplayer_prices': json.encode(card['tcgplayer']?['prices'] ?? {}),

    };
  }
}
