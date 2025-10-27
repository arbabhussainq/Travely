import 'package:flutter/foundation.dart';
import '../models/place.dart';
import '../services/wikipedia_places_service.dart';
import '../services/unsplash_service.dart';

class SearchProvider extends ChangeNotifier {
  late final WikipediaPlacesService _wiki;
  late final UnsplashService _unsplash;

  SearchProvider() {
    _unsplash = UnsplashService();
    _wiki = WikipediaPlacesService(
      _unsplash,
    ); // pass Unsplash for per-place fallback
  }

  String _city = '';
  String get city => _city;

  bool _loading = false;
  bool get loading => _loading;

  String? coverUrl;
  List<Place> results = [];
  String? error;

  Future<void> search(String city) async {
    if (_loading) return;
    final q = city.trim();
    if (q.isEmpty) return;

    _city = q;
    _loading = true;
    error = null;
    notifyListeners();

    try {
      // 1) Nice city cover from Unsplash
      coverUrl = await _unsplash.cityCover(_city);

      // 2) Wikipedia results (auto-fills Unsplash image per place if missing)
      results = await _wiki.searchCityPOIs(_city);

      if (results.isEmpty) {
        error =
            'No places found for "$_city". Try another spelling or a larger city.';
      }
    } catch (e) {
      error = e.toString();
      results = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
