import 'package:cinemapedia/domain/entities/actor.dart';

import 'package:cinemapedia/presentation/providers/actors/actor_repository_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorByMovieProvider =
    StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>(
        (ref) {
  return ActorsByMovieNotifier(
      getActors: ref.watch(actorsRepositoryProvider).getActorsByMovie);
});

typedef GetActorsCallback = Future<List<Actor>> Function(String movieID);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsCallback getActors;
  ActorsByMovieNotifier({
    required this.getActors,
  }) : super({});

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;
    final actors = await getActors(movieId);
    state = {...state, movieId: actors};
  }
}
