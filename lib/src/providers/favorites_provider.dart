import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../models/place.dart';
import 'dart:async';

class FavoritesProvider extends ChangeNotifier {
  final _col = FirebaseService.db.collection('favorites');

  // NEW: cache + listener
  Set<String> _favIds = <String>{};
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;

  String _safeId(Object? v) => (v ?? '').toString().replaceAll('/', '_');
  double? _safeDouble(num? n) {
    if (n == null) return null;
    final d = n.toDouble();
    return (d.isNaN || d.isInfinite) ? null : d;
  }

  // NEW: call this once after login (e.g., in HomePage initState)
  void start() {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    _sub?.cancel();
    _favIds.clear();
    if (uid.isEmpty) {
      notifyListeners();
      return;
    }

    _sub = _col.where('uid', isEqualTo: uid).snapshots().listen((qs) {
      _favIds = qs.docs
          .map((d) => (d.data()['placeId'] ?? '').toString())
          .toSet();
      notifyListeners();
    });
  }

  // NEW: simple helper for UI
  bool isFavorite(Object? placeId) =>
      _favIds.contains((placeId ?? '').toString());

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  // (unchanged) toggle, but update _favIds after a successful write
  Future<bool> toggleFavorite(Place p) async {
    final authUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (authUid.isEmpty) throw Exception('User not signed in.');

    final pid = _safeId(p.placeId);
    final docId = '${authUid}_$pid';
    final doc = _col.doc(docId);
    final snap = await doc.get();

    if (snap.exists) {
      await doc.delete();
      _favIds.remove(pid); // <- update cache
      notifyListeners();
      return false;
    } else {
      await doc.set({
        'uid': authUid,
        'placeId': pid,
        'name': p.name,
        'address': p.address,
        'rating': _safeDouble(p.rating),
        'photoUrl': p.photoUrl,
        'city': p.city,
        'lat': _safeDouble(p.lat),
        'lng': _safeDouble(p.lng),
        'description': p.description,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _favIds.add(pid); // <- update cache
      notifyListeners();
      return true;
    }
  }

  // (keep your streamFavorites if other screens use it)
  Stream<List<Place>> streamFavorites() {
    final authUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (authUid.isEmpty) return const Stream<List<Place>>.empty();
    return _col
        .where('uid', isEqualTo: authUid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return Place(
              placeId: (data['placeId'] ?? '').toString(),
              name: (data['name'] ?? '').toString(),
              address: data['address'],
              rating: (data['rating'] as num?)?.toDouble(),
              photoUrl: data['photoUrl'],
              city: data['city'],
              lat: (data['lat'] as num?)?.toDouble(),
              lng: (data['lng'] as num?)?.toDouble(),
              description: data['description'],
            );
          }).toList(),
        );
  }
}
