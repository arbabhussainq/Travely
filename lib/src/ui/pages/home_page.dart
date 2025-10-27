import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/search_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../services/auth_service.dart';
import '../widgets/city_search_bar.dart';
import '../widgets/place_card.dart';
import '../widgets/empty_state.dart';
import 'details_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // start favorites listener once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesProvider>().start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final sp = context.watch<SearchProvider>();
    final favs = context.watch<FavoritesProvider>(); // watch so hearts react

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travely'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Find places',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            CitySearchBar(
              onSubmitted: (v) => context.read<SearchProvider>().search(v),
            ),
            if (sp.coverUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 16 / 7,
                    child: Image.network(sp.coverUrl!, fit: BoxFit.cover),
                  ),
                ),
              ),
            if (sp.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  sp.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (sp.loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (sp.results.isEmpty)
              const EmptyState(
                title: 'Search a city to begin',
                subtitle: 'Try “Budapest”, “London”, or “Amsterdam”.',
              )
            else
              ...sp.results.map((p) {
                final uid = auth.user?.uid ?? '';
                final canFav = uid.isNotEmpty;
                final isFav = favs.isFavorite(p.placeId); // instant, cached

                return PlaceCard(
                  place: p,
                  isFav: isFav,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailsPage(place: p)),
                  ),
                  onFav: canFav
                      ? () async {
                          final added = await context
                              .read<FavoritesProvider>()
                              .toggleFavorite(p);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                added
                                    ? 'Added to favorites'
                                    : 'Removed from favorites',
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      : () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please log in to save favorites'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
