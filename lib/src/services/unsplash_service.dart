import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class UnsplashService {
  // Keep your existing AppConfig.unsplashAccessKey
  String get _accessKey => AppConfig.unsplashAccessKey;

  /// City header/cover image
  Future<String?> cityCover(String city) async {
    if (_accessKey.isEmpty) return null;
    final q = Uri.encodeComponent('$city skyline cityscape');
    final uri = Uri.parse(
      'https://api.unsplash.com/search/photos?query=$q&per_page=1&orientation=landscape',
    );
    final resp = await http.get(
      uri,
      headers: {'Authorization': 'Client-ID $_accessKey'},
    );
    if (resp.statusCode != 200) return null;
    final map = json.decode(resp.body) as Map<String, dynamic>;
    final results = (map['results'] as List?) ?? const [];
    if (results.isEmpty) return null;
    return results.first['urls']?['regular'] as String?;
  }

  /// Per-place image when Wikipedia doesn't provide a thumbnail
  Future<String?> placeImage(String query) async {
    if (_accessKey.isEmpty) return null;
    final q = Uri.encodeComponent(query);
    final uri = Uri.parse(
      'https://api.unsplash.com/search/photos?query=$q&per_page=1&orientation=landscape',
    );
    final resp = await http.get(
      uri,
      headers: {'Authorization': 'Client-ID $_accessKey'},
    );
    if (resp.statusCode != 200) return null;
    final map = json.decode(resp.body) as Map<String, dynamic>;
    final results = (map['results'] as List?) ?? const [];
    if (results.isEmpty) return null;
    return results.first['urls']?['regular'] as String?;
  }
}
