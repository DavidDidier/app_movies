import 'package:flutter/material.dart';
import 'package:peliculas_app/src/providers/movies_provider.dart';

import '../models/movie_model.dart';
import '../widgets/card_swiper_widget.dart';
import '../widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final movieProvider = MoviesProvider();

  HomePage({Key? key}) : super(key: key);

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
