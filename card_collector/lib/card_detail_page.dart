import 'package:flutter/material.dart';

class CardDetailPage extends StatelessWidget {
  final Map<String, dynamic> card; // Accepts the card data

  CardDetailPage({required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card['name'] ?? 'Card Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Image
            if (card['smallImage'] != null)
              Center(
                child: Image.network(
                  card['smallImage'],
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            SizedBox(height: 16),

            // Card Name
            Text(
              'Name: ${card['name']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Supertype
            if (card['supertype'] != null)
              Text(
                'Supertype: ${card['supertype']}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),

            // Subtypes
            if (card['subtypes'] != null)
              Text(
                'Subtypes: ${card['subtypes']}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),

            // HP
            if (card['hp'] != null)
              Text(
                'HP: ${card['hp']}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),

            // Types
            if (card['types'] != null)
              Text(
                'Types: ${card['types']}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),

            // Evolves To
            if (card['evolvesTo'] != null)
              Text(
                'Evolves To: ${card['evolvesTo']}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),

            // Retreat Cost
            if (card['retreatCost'] != null)
              Text(
                'Retreat Cost: ${card['retreatCost']}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),

            // Rarity
            if (card['rarity'] != null)
              Text(
                'Rarity: ${card['rarity']}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),

            // Artist
            if (card['artist'] != null)
              Text(
                'Artist: ${card['artist']}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),

            // Set Details
            if (card['set'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('ID: ${card['set']['id']}'),
                  Text('Name: ${card['set']['name']}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
