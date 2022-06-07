import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:peliculas_app/src/models/movie_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  CardSwiper({required this.movies});

  /// It creates a container with a padding of 0.9 and a child of Swiper.
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget.
  ///
  /// Returns:
  ///   A widget that is a container with a child that is a swiper.
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.only(top: 0.9),
        child: Swiper(
          itemCount: movies.length,
          itemWidth: screenSize.width * 0.75,
          itemHeight: screenSize.height * 0.5,
          layout: SwiperLayout.STACK,
          itemBuilder: (BuildContext context, int index) {
            movies[index].uniqueId = '${movies[index].id}-card';
            return Hero(
                tag: movies[index].uniqueId,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, 'details',
                            arguments: movies[index]),
                        child: FadeInImage(
                          image: NetworkImage(movies[index].getPosterImage()),
                          placeholder: const NetworkImage(
                              'https://www.servicioaltoque.online/uploads/services/foo.jpg'),
                          fit: BoxFit.fill,
                        ))));
          },
        ));
  }
}
