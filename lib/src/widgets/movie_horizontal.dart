import 'package:flutter/material.dart';
import 'package:peliculas_app/src/models/movie_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;

  MovieHorizontal({required this.movies, required this.nextPage});

  final _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.25,
  );

  /// It creates a pageview that is scrollable and has a page controller.
  ///
  /// Args:
  ///   context (BuildContext): The current context of the widget.
  ///
  /// Returns:
  ///   A Container with a height of 20% of the screen size.
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 150) {
        nextPage();
      }
    });

    return Container(
      height: screenSize.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (context, i) => _crearTarjeta(context, movies[i]),
        //children: _tarjetas(context),
      ),
    );
  }

  /// It creates a card with the movie poster and title.
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget.
  ///   movie (Movie): Movie
  ///
  /// Returns:
  ///   A widget
  Widget _crearTarjeta(BuildContext context, Movie movie) {
    final movieTarjeta = Container(
      margin: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(23.0),
              child: FadeInImage(
                image: NetworkImage(movie.getPosterImage()),
                placeholder: const NetworkImage(
                    'https://www.servicioaltoque.online/uploads/services/foo.jpg'),
                fit: BoxFit.cover,
                height: 180.0,
              )),
          const SizedBox(height: 5.0),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );

    return GestureDetector(
      child: movieTarjeta,
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
    );
  }
}
