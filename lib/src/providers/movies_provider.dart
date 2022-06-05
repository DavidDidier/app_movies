import 'dart:async';

import 'package:peliculas_app/src/models/movie_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MoviesProvider {
  String _apikey = 'ddc710de4fb7810818d52156f0d17f2f';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularsPage = 0;
  bool _loanding = false;

  List<Movie> _populars = [];

  final _polurasStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularsSink => _polurasStreamController.sink.add;

  Stream<List<Movie>> get popularsStream => _polurasStreamController.stream;

  void disposeStreams() {
    _polurasStreamController.close();
  }

  Future<List<Movie>> _procesarResp(Uri url) async {
    final resp = await http.get(url);
    final dataDecoded = json.decode(resp.body);
    final movies = Movies.fromJsonList(dataDecoded['results']);
    return movies.items;
  }

  Future<List<Movie>> getInCine() async {
    final url = Uri.https(_url, '/3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _procesarResp(url);
  }

  Future<List<Movie>> getPopulars() async {
    if (_loanding) return [];
    _loanding = true;
    _popularsPage++;
    final url = Uri.https(_url, '/3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularsPage.toString()
    });

    final List<Movie> resp = await _procesarResp(url);
    _populars.addAll(resp);
    popularsSink(_populars);
    _loanding = false;
    return resp;
  }
}
