import 'package:flutter/material.dart';
import 'package:peliculas_app/src/providers/movies_provider.dart';

class SearchMovie extends SearchDelegate {
  final movieProvider = MoviesProvider();

  /// The buildActions function is called when the user submits a search. It's where you define the
  /// actions that appear at the right of the AppBar
  ///
  /// Args:
  ///   context (BuildContext): The current context of the app.
  ///
  /// Returns:
  ///   A list of widgets.
  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de nuestro AppBar
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  /// The buildLeading function is called to build the leading widget in the [AppBar]
  ///
  /// Args:
  ///   context (BuildContext): The context of the app.
  ///
  /// Returns:
  ///   IconButton
  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation));
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que mostraremos
    throw UnimplementedError();
  }

  /// The function that is called when the user starts typing in the search bar.
  ///
  /// Args:
  ///   context (BuildContext): The current BuildContext.
  ///
  /// Returns:
  ///   A FutureBuilder that returns a ListView with the movies that match the query.
  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando se va escribiendo
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: movieProvider.getSearchMovie(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data!;
          return ListView(
            children: movies.map((movie) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(movie.getPosterImage()),
                  placeholder: const NetworkImage(
                      'https://www.servicioaltoque.online/uploads/services/foo.jpg'),
                  fit: BoxFit.contain,
                  width: 60.0,
                ),
                title: Text(movie.title),
                subtitle: Text(movie.originalTitle),
                onTap: () {
                  close(context, null);
                  Navigator.pushNamed(context, 'details', arguments: movie);
                },
              );
            }).toList(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
