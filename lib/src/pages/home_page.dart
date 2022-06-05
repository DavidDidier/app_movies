import 'package:flutter/material.dart';
import 'package:peliculas_app/src/providers/movies_provider.dart';

import '../models/movie_model.dart';
import '../widgets/card_swiper_widget.dart';
import '../widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final movieProvider = MoviesProvider();

  HomePage({Key? key}) : super(key: key);

  /// The main function of the application, it is the one that is in charge of building the application.
  ///
  /// Args:
  ///   context (BuildContext): The current BuildContext.
  ///
  /// Returns:
  ///   A Scaffold with a AppBar, a Container with a Column with two children, the first one is a
  /// _swiperTarjetas() and the second one is a _footer().
  @override
  Widget build(BuildContext context) {
    movieProvider.getPopulars();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Movies in Cine'),
          backgroundColor: Colors.blueGrey,
          actions: <Widget>[
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _swiperTarjetas(),
              _footer(),
            ],
          ),
        ));
  }

  /// A function that returns a widget, which is a FutureBuilder, which is a widget that returns a
  /// widget, which is a CardSwiper, which is a widget that returns a widget, which is a Container,
  /// which is a widget that returns a widget, which is a Center, which is a widget that returns a
  /// widget, which is a CircularProgressIndicator, which is a widget that returns a widget, which is a
  /// Container, which is a widget that returns a widget, which is a CardSwiper, which is a widget that
  /// returns a widget, which is a FutureBuilder, which is a widget that returns a widget, which is a
  /// Container, which is a widget that returns a widget, which is a Center, which is a widget that
  /// returns a widget, which is a CircularProgressIndicator, which is a widget that returns a widget,
  /// which is a Container, which is a widget that returns a widget, which is a CardSwiper, which is
  ///
  /// Returns:
  ///   A FutureBuilder that returns a CardSwiper widget.
  Widget _swiperTarjetas() {
    return FutureBuilder(
        future: movieProvider.getInCine(),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.hasData) {
            return CardSwiper(movies: snapshot.data!);
          } else {
            return Container(
                height: 600.0,
                child: const Center(child: CircularProgressIndicator()));
          }
        });
  }

  /// It creates a container with a column inside. The column has two children. The first child is a
  /// container with a text widget inside. The second child is a stream builder. The stream builder has a
  /// stream and a builder. The stream is the popularsStream from the movieProvider. The builder is a
  /// function that returns a MovieHorizontal widget. The MovieHorizontal widget has a list of movies and
  /// a nextPage function. The list of movies is the data from the snapshot. The nextPage function is the
  /// getPopulars function from the movieProvider.
  ///
  /// Returns:
  ///   A widget that contains a column with a text and a streambuilder.
  Widget _footer() {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 15.0),
            child: const Text('Populares'),
          ),
          const SizedBox(height: 15.0),
          StreamBuilder(
              stream: movieProvider.popularsStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return MovieHorizontal(
                    movies: snapshot.data,
                    nextPage: movieProvider.getPopulars,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })
        ],
      ),
    );
  }
}
