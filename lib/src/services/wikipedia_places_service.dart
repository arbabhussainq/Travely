import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place.dart';
import 'unsplash_service.dart';

class WikipediaPlacesService {
  WikipediaPlacesService(this._unsplash);
  final UnsplashService _unsplash;

  static const _base = 'https://en.wikipedia.org/w/api.php';

  bool _isValidCity(String q) {
    final cityRegex = RegExp(r'^[a-zA-Z\s\-]+$');
    return q.isNotEmpty && cityRegex.hasMatch(q) && q.length > 4;
  }

  Future<List<Place>> searchCityPOIs(String city) async {
    final q = city.trim();
    if (!_isValidCity(q)) return [];

    // Improved query: prioritizes pages categorized as places/landmarks in that city
    final search =
        'intitle:"$q" (landmark OR attraction OR monument OR museum OR park OR site OR place)';

    final uri = Uri.parse(
      '$_base'
      '?action=query'
      '&format=json'
      '&generator=search'
      '&gsrlimit=25'
      '&gsrsearch=${Uri.encodeComponent(search)}'
      '&prop=extracts|pageimages|coordinates'
      '&exintro=1'
      '&explaintext=1'
      '&piprop=thumbnail'
      '&pithumbsize=800'
      '&origin=*',
    );

    final res = await http.get(uri).timeout(const Duration(seconds: 12));
    if (res.statusCode != 200) {
      throw Exception('Wikipedia HTTP ${res.statusCode}');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final query = json['query'] as Map<String, dynamic>?;
    if (query == null) return [];

    final pages = (query['pages'] as Map).values.cast<Map>().toList();

    final places = <Place>[];

    for (final p in pages) {
      final title = (p['title'] ?? '').toString();
      if (title.isEmpty) continue;

      // Reject irrelevant pages (like history, biography, etc.)
      final lower = title.toLowerCase();
      if (lower.contains('history') ||
          lower.contains('timeline') ||
          lower.contains('culture') ||
          lower.contains('economy') ||
          lower.contains('transport') ||
          lower.contains('education') ||
          lower.contains('politics')) {
        continue;
      }

      final id = (p['pageid'] ?? '').toString();
      final extract = (p['extract'] as String?)?.trim();
      String? photo = (p['thumbnail'] as Map?)?['source'] as String?;

      // Try Unsplash if missing thumbnail
      if (photo == null) {
        photo = await _unsplash.placeImage('$title $q landmark');
      }

      places.add(
        Place(
          placeId: id,
          name: title,
          city: q,
          description: extract?.isNotEmpty == true ? extract : null,
          photoUrl: photo,
          address: null,
          rating: null,
          lat: (p['coordinates'] != null)
              ? (p['coordinates'][0]['lat'] as double?)
              : null,
          lng: (p['coordinates'] != null)
              ? (p['coordinates'][0]['lon'] as double?)
              : null,
        ),
      );
    }

    // Sort alphabetically
    places.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return places;
  }
}
