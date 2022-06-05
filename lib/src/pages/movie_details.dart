import 'package:flutter/material.dart';
import 'package:peliculas_app/src/models/movie_model.dart';

class MovieDetail extends StatelessWidget {
  const MovieDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Center(child: Text(movie.title)),
    );
  }
}
