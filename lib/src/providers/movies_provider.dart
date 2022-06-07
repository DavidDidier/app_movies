import 'dart:async';

import 'package:peliculas_app/src/models/movie_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/actors_model.dart';

class MoviesProvider {
  final String _apikey = 'ddc710de4fb7810818d52156f0d17f2f';
  final String _url = 'api.themoviedb.org';
  final String _language = 'es-ES';

  int _popularsPage = 0;
  bool _loanding = false;

  final List<Movie> _populars = [];

  /// A stream controller that is used to send data to the stream.
  final _polurasStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularsSink => _polurasStreamController.sink.add;

  Stream<List<Movie>> get popularsStream => _polurasStreamController.stream;

  void disposeStreams() {
    _polurasStreamController.close();
  }

  /// It takes a url and returns a list of movies.
  ///
  /// Args:
  ///   url (Uri): The URL to fetch the JSON from.
  ///
  /// Returns:
  ///   A Future<List<Movie>>
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

  /// A function that returns a list of movies.
  ///
  /// Returns:
  ///   A list of movies
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

  /// Getting the cast of a movie.
  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apikey, 'language': _language});
    final resp = await http.get(url);
    final dataDecode = json.decode(resp.body);
    final cast = Cast.fromJsonList(dataDecode['cast']);
    return cast.actors;
  }

  Future<List<Movie>> getSearchMovie(String query) async {
    final url = Uri.https(_url, '/3/search/movie/',
        {'api_key': _apikey, 'language': _language, 'query': query});

    return await _procesarResp(url);
  }
}
