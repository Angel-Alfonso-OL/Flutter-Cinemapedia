import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_format.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallback searchMovies;
  List<Movie> initialMovie;
  StreamController<List<Movie>> debouncedMovides = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.initialMovie,
    required this.searchMovies,
  });

  void clearStreams() {
    debouncedMovides.close();
  }

  void _onQueryChange(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: 500),
      () async {
        final movies = await searchMovies(query);
        initialMovie = movies;
        debouncedMovides.add(movies);
        isLoadingStream.add(false);
      },
    );
  }

  @override
  String? get searchFieldLabel => "Buscar Pelicula";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 5,
              infinite: true,
              child: IconButton(
                onPressed: () => query = "",
                icon: const Icon(Icons.refresh_rounded),
              ),
            );
          }
          return FadeIn(
            child: IconButton(
              onPressed: () => query = "",
              icon: const Icon(Icons.clear),
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    _onQueryChange(query);
    return StreamBuilder(
      initialData: initialMovie,
      stream: debouncedMovides.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItems(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              clearStreams();
              close(context, movie);
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChange(query);
    return StreamBuilder(
      initialData: initialMovie,
      stream: debouncedMovides.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItems(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              clearStreams();
              close(context, movie);
            },
          ),
        );
      },
    );
  }
}

class _MovieItems extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _MovieItems({
    required this.movie,
    required this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(movie.posterPath,
                    loadingBuilder: (context, child, loadingProgress) =>
                        FadeIn(child: child)),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textStyles.titleMedium,
                  ),
                  (movie.overview.length > 100)
                      ? Text("${movie.overview.substring(0, 100)}...")
                      : Text(movie.overview),
                  Row(
                    children: [
                      Icon(
                        Icons.star_half_outlined,
                        color: Colors.yellow.shade800,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        HumansFormat.number(movie.voteAverage, 1),
                        style: textStyles.bodyMedium!.copyWith(
                          color: Colors.yellow.shade900,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
