import 'package:flutter/material.dart';
import 'package:peliculas_app/src/models/movie_model.dart';
import 'package:peliculas_app/src/providers/movies_provider.dart';

import '../models/actors_model.dart';

class MovieDetail extends StatelessWidget {
  const MovieDetail({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _appBarCreate(movie),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(
                height: 9.0,
              ),
              _titlePoster(context, movie),
              _description(movie),
              _createCasting(movie),
            ]),
          )
        ],
      ),
    );
  }

  Widget _appBarCreate(Movie movie) {
    return SliverAppBar(
      elevation: 3.0,
      backgroundColor: Colors.blueGrey,
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(movie.title,
            style: const TextStyle(color: Colors.white10, fontSize: 18.0)),
        background: FadeInImage(
            placeholder: const NetworkImage(
                'https://www.servicioaltoque.online/uploads/services/foo.jpg'),
            fit: BoxFit.fill,
            image: NetworkImage(movie.backdropPath),
            fadeInDuration: const Duration(microseconds: 200)),
      ),
    );
  }

  Widget _titlePoster(context, Movie movie) {
    return Container(
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              child: Image(
                  image: NetworkImage(movie.getPosterImage()),
                  height: 200.0,
                  width: 15.0),
            ),
          ),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(movie.title,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis),
              Text(movie.originalTitle,
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis),
              Row(
                children: <Widget>[
                  const Icon(Icons.star),
                  Text(movie.voteAverage.toString(),
                      style: Theme.of(context).textTheme.subtitle1)
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _description(Movie movie) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 23.0),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _createCasting(Movie movie) {
    final movieProvaider = MoviesProvider();
    return FutureBuilder(
      future: movieProvaider.getCast(movie.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _createActorsPageView(snapshot.data);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _createActorsPageView(List<Actor> actors) {
    return SizedBox(
      height: 220.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.4, initialPage: 1),
        itemCount: actors.length,
        itemBuilder: (context, i) => _actorTarjeta(actors[i]),
      ),
    );
  }

  Widget _actorTarjeta(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: const NetworkImage(
                    'https://www.servicioaltoque.online/uploads/services/foo.jpg'),
                fit: BoxFit.fill,
                image: NetworkImage(actor.getPhoto()),
                height: 135.0,
              )),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
