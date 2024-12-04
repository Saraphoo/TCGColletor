import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';

class CardDetailPage extends StatefulWidget {
  final Map<String, dynamic> card; // Accepts the card data

  CardDetailPage({required this.card});

  @override
  _CardDetailPageState createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  bool isWishedFor = false; // State to track if the card is wished for
  bool isFavorite = false; // State to track if the card is favorite
  bool isOwned = false; // State to track if the card is owned
  int copiesOwned = 0; // State to track the number of copies owned

  @override
  Widget build(BuildContext context) {
    // Parse fields that are stored as TEXT but represent structured data
    final set = widget.card['set'] != null ? json.decode(widget.card['set']) : null;
    final subtypes = widget.card['subtypes'] != null ? json.decode(widget.card['subtypes']) : [];
    final types = widget.card['types'] != null ? json.decode(widget.card['types']) : [];
    final retreatCost = widget.card['retreatCost'] != null ? json.decode(widget.card['retreatCost']) : [];
    final convertedRetreatCost = widget.card['convertedRetreatCost'] != null
        ? int.tryParse(widget.card['convertedRetreatCost'].toString())
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card['name'] ?? 'Card Details'),
        actions: [
          // Heart Button for Favorite
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border, // Filled or hollow heart
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite; // Toggle state
                });
              },
            ),
          ),

          // Star Button for Wished For
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: Icon(
                isWishedFor ? Icons.star : Icons.star_border, // Solid or hollow star
                color: isWishedFor ? Colors.orange : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  isWishedFor = !isWishedFor; // Toggle state
                });
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Image
            if (widget.card['smallImage'] != null)
              Center(
                child: Image.network(
                  widget.card['smallImage'],
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            SizedBox(height: 16),

            // Card Name
            Text(
              'Name: ${widget.card['name']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Supertype
            if (widget.card['supertype'] != null)
              Text(
                'Supertype: ${widget.card['supertype']}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),

            // Subtypes
            if (subtypes.isNotEmpty)
              Text(
                'Subtypes: ${subtypes.join(', ')}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),

            // Ownership Section
            Divider(),
            Text(
              'Ownership',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Owned Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: isOwned,
                      onChanged: (value) {
                        setState(() {
                          isOwned = value ?? false;
                          if (!isOwned) copiesOwned = 0; // Reset copies if unowned
                        });
                      },
                    ),
                    Text(
                      'Mark as Owned',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),

                // Copies Counter
                Row(
                  children: [
                    IconButton(
                      onPressed: isOwned && copiesOwned > 0
                          ? () {
                        setState(() {
                          copiesOwned--;
                        });
                      }
                          : null, // Disable if not owned or copies are 0
                      icon: Icon(Icons.remove),
                    ),
                    Text(
                      '$copiesOwned',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: isOwned
                          ? () {
                        setState(() {
                          copiesOwned++;
                        });
                      }
                          : null, // Disable if not owned
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
            Divider(),

            // Evolves To
            if (widget.card['evolvesTo'] != null)
              Text(
                'Evolves To: ${widget.card['evolvesTo']}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),

            // Retreat Cost
            if (retreatCost.isNotEmpty)
              Text(
                'Retreat Cost: ${retreatCost.join(', ')}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),

            // Converted Retreat Cost
            if (convertedRetreatCost != null)
              Text(
                'Converted Retreat Cost: $convertedRetreatCost',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),

            // Rarity
            if (widget.card['rarity'] != null)
              Text(
                'Rarity: ${widget.card['rarity']}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),

            // Artist
            if (widget.card['artist'] != null)
              Text(
                'Artist: ${widget.card['artist']}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),

            // Set Details
            if (set != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('Name: ${set['name']}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
