import 'package:cinemapedia/domain/datasources/local_storage_datasourse.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl implements LocalStorageRepository{


  final LocalStorageDatasourse datasourse;

  LocalStorageRepositoryImpl({required this.datasourse});

  @override
  Future<bool> isMovieFavorite(int movieId) {
    return datasourse.isMovieFavorite(movieId);
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) {
    return datasourse.loadMovies(limit: limit,offset: offset);
  }

  @override
  Future<void> toggleFavorite(Movie movie) {
    return datasourse.toggleFavorite(movie);
  }
}