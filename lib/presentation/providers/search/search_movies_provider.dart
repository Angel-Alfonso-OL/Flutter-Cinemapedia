import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) {
  return "";
});

final searchedMovieProvider =
    StateNotifierProvider<SearchMoviesNotifier, List<Movie>>((ref) {
  final movieRepository = ref.read(movieRepositoryProvider);
  return SearchMoviesNotifier(
    ref: ref,
    searchMovie: movieRepository.searchMovies,
  );
});

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMoviesNotifier extends StateNotifier<List<Movie>> {
  final SearchMoviesCallback searchMovie;
  final Ref ref;

  SearchMoviesNotifier({
    required this.ref,
    required this.searchMovie,
  }) : super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final List<Movie> movies = await searchMovie(query);
    ref.read(searchQueryProvider);
    state = movies;
    return movies;
  }
}
