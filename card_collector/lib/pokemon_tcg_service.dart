import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PokemonTCGService {
  // Base URL for the API
  final String baseUrl = 'https://api.pokemontcg.io/v2/cards';

  // Fetch cards from the API
  Future<List<Map<String, dynamic>>> fetchCards() async {
    // Load API key from environment variables
    final String apiKey = dotenv.env['API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      throw Exception('API Key is missing. Please check your .env file.');
    }

    List<Map<String, dynamic>> allCards = [];
    bool hasMoreData = true;
    int currentPage = 1;
    final int pageSize = 250; // Maximum page size for the API

    while (hasMoreData) {
      // Construct the URL with pagination parameters
      final Uri url = Uri.parse('$baseUrl?page=$currentPage&pageSize=$pageSize');

      // Make the HTTP GET request
      final response = await http.get(
        url,
        headers: {
          'X-Api-Key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> cards = jsonData['data'];

        // Add the current page of cards to the complete list
        allCards.addAll(cards.map((card) {
          return {
            'id': card['id'],
            'name': card['name'],
            'imageUrl': card['images']['small'],
            'supertype': card['supertype'],
            'subtype': card['subtypes']?.join(', ') ?? '',
          };
        }).toList());

        // Check if more data exists
        final int totalCount = jsonData['totalCount'];
        final int fetchedCount = currentPage * pageSize;

        if (fetchedCount >= totalCount) {
          hasMoreData = false;
        } else {
          currentPage++;
        }
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception('Failed to fetch cards. Response: ${response.body}');
      }
    }

    return allCards;
  }
}
