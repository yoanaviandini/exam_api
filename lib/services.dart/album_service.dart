import 'dart:convert';

import 'package:nyobaflutter/models.dart/album.dart';
import 'package:http/http.dart' as http;

class AlbumService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/photos';

  static Future<List<Album>> fetchAlbum() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> result = jsonDecode(response.body);
        List<Album> lastAlbum =
            result.map((albums) => Album.fromJson(albums)).toList();
        return lastAlbum;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> deleteAlbum(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete album');
    }
  }

  static Future<void> updateAlbum(Album album) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${album.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(album.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update album');
    }
  }
}
