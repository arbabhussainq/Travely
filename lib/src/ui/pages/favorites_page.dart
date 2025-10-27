import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import '../../services/auth_service.dart';
import '../../models/place.dart';
import '../widgets/place_card.dart';
import 'details_page.dart';
import 'login_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = context.read<FavoritesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<AuthService>().signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              }
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: StreamBuilder<List<Place>>(
        stream: favs.streamFavorites(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: ${snap.error}'),
              ),
            );
          }

          final items = snap.data ?? const <Place>[];
          if (items.isEmpty) {
            return const Center(
              child: Text('No favorites yet. Tap ♥ on a place.'),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final p = items[i];
              return PlaceCard(
                place: p,
                isFav: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailsPage(place: p)),
                ),
                onFav: () async {
                  final added = await favs.toggleFavorite(p); // no uid param
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        added ? 'Added to favorites' : 'Removed from favorites',
                      ),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
