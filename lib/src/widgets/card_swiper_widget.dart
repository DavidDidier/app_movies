import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:peliculas_app/src/models/movie_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  CardSwiper({required this.movies});

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
            return ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage(movies[index].getPosterImage()),
                  placeholder: const NetworkImage(
                      'https://www.servicioaltoque.online/uploads/services/foo.jpg'),
                  fit: BoxFit.fill,
                ));
          },
        ));
  }
}
