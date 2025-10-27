import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/place.dart';
import '../../providers/favorites_provider.dart';
import '../../services/auth_service.dart';
import 'login_page.dart';

class DetailsPage extends StatefulWidget {
  final Place place;
  const DetailsPage({super.key, required this.place});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isFav = false;
  bool canFav = false;

  @override
  void initState() {
    super.initState();
    _loadInitialFavState();
  }

  Future<void> _loadInitialFavState() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    setState(() => canFav = uid != null);
    if (uid == null) return;

    // check once if this place is already in favorites
    final docId = '${uid}_${widget.place.placeId}';
    final snap = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(docId)
        .get();
    if (!mounted) return;
    setState(() => isFav = snap.exists);
  }

  @override
  Widget build(BuildContext context) {
    final favs = context.read<FavoritesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.place.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
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
      body: ListView(
        children: [
          Hero(
            tag: 'photo_${widget.place.placeId}',
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: widget.place.photoUrl == null
                  ? Container(color: const Color(0xFFEFF4FF))
                  : Image.network(widget.place.photoUrl!, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.place.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                if (widget.place.description != null)
                  Text(widget.place.description!),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: canFav
                      ? () async {
                          try {
                            final added = await favs.toggleFavorite(
                              widget.place,
                            );
                            if (!mounted) return;
                            setState(() => isFav = added);

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
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed: $e'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      : null,
                  icon: Icon(
                    isFav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                  ),
                  label: Text(isFav ? 'Added' : 'Add to favorites'),
                  style: FilledButton.styleFrom(
                    backgroundColor: isFav
                        ? Colors.redAccent
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
