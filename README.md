# Pokémon Card Tracker Project

## Overview

The **Pokémon Card Tracker** is a Flutter application designed to help users manage their Pokémon card collections. The app allows users to:
- Browse the full Pokémon card catalog.
- Mark cards as "Wished For" or "Favorited."
- Track ownership and quantity of cards.
- Filter and sort cards by various attributes.
- View detailed information about each card.

The project uses SQLite to store card data locally for offline access and includes features for database persistence.

---

## Features

1. **Browse Catalog**: View all Pokémon cards available in the catalog.
2. **User Catalog**: Displays cards the user owns, with options to manage owned quantities.
3. **Card Detail Page**: View detailed information about individual cards, including:
   - Name, Type, HP, Retreat Cost, and Rarity.
   - Favorite cards with a heart icon.
   - Add cards to the wish list with a star icon.
   - Track ownership and quantity.

---

## Prerequisites

Before running the project, ensure you have the following installed:
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) or another IDE (like VSCode with Flutter extensions)
- A device or emulator for testing.

---

## How to Run

1. **Clone the Repository**:
   ```bash
   git clone <repository_url>
   cd pokemon_card_tracker

2. **Install Dependencies**: Run the following command to fetch all necessary Flutter and Dart packages:

```bash
flutter pub get
```
3. **Configure the .env File:** Create a .env file in the root of the project directory and add the following**:
```bash
API_KEY=<your_pokemon_tcg_api_key>
```
Replace <your_pokemon_tcg_api_key> with your Pokémon TCG API key.

4. **Run the Application**: Use the Flutter CLI to run the app:
```bash
flutter run
```
5. **Database Setup:** On first run, the app will:
Fetch card data from the Pokémon TCG API.
Populate the SQLite database with the data.

**Project Structure**
**Main Components**

-lib/main.dart: Entry point for the application.

-lib/card_detail_page.dart: Displays detailed information for each card.

-lib/browse_catalog.dart: Allows users to browse all cards.

-lib/user_catalog_page.dart: Displays the user's owned cards.

-lib/database_helper.dart: Handles SQLite operations.

-lib/pokemon_tcg_service.dart: Fetches data from the Pokémon TCG API.

-lib/sort_cards.dart: Sorts cards set by specified attribute

-lib/filter_cards.dart: Filters cards by a specified attribute

**Database Tables**
- **cards**: Stores all card details fetched from the API.
- **wish**: Tracks cards marked as "Wished For."
- **favorite**: Tracks cards marked as "Favorited."
- **owned**: Tracks user-owned cards and their quantities.

**Key Features for Evaluation**

**User Interactivity**:
- Mark cards as "Wished For" or "Favorited."
- Increment/decrement owned quantities.

**SQLite Integration**:
- Persistent local storage for card details.
- Tables for managing user-specific data (e.g., `wish`, `favorite`, `owned`).

**API Integration**:
- Fetches and stores Pokémon card data locally.
- Uses the Pokémon TCG API for real-time data retrieval.

**Clean UI**:
- User-friendly interfaces for catalog browsing and card management.
- Filters and sorting options for a tailored user experience.

**Known Issues**
- **API Key**: The app requires a valid Pokémon TCG API key. Without it, data fetching will fail.
- **Desktop Platforms**: If testing on desktop, ensure the database is initialized with `sqflite_common_ffi`.

**Contact**
For any questions or support, please contact:
- **Name**: Sarah Riley
- **Email**: rileys14@mymail.nku.edu
- 

**Example Usage**
1. Open the app.
2. Browse the card catalog via the **Browse Catalog** option.
3. Mark cards as "Owned," "Wished For," or "Favorited" using the detail page.
4. View your owned cards in the **User Catalog** section.
5. Sort and filter cards as needed.



