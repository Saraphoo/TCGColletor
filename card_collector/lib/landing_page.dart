import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon Card Tracker'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              'Welcome to Pokémon Card Tracker!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            // Browse Card Catalog Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/browse');
              },
              child: Text('Browse Card Catalog'),
            ),
            SizedBox(height: 20.0),
            // Your Card Catalog Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/your_catalog');
              },
              child: Text('Your Card Catalog'),
            ),
          ],
        ),
      ),
    );
  }
}
