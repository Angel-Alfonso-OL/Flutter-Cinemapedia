import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieInfoProvider = StateNotifierProvider<MovieMapProvider,Map<String,Movie>>((ref){
  return MovieMapProvider(getMovie: ref.watch(movieRepositoryProvider).getMovieById);
});

typedef GetMovieCallback = Future<Movie> Function(String movieID);

class MovieMapProvider extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;
  MovieMapProvider({
    required this.getMovie,
  }) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;
    final movie = await getMovie(movieId);
    state = {...state, movieId: movie};
  }
}
