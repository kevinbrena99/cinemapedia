import 'package:cinemapedia/domain/entiites/actor_entity.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final actorsBymovieProvider = StateNotifierProvider<ActorsByMovieNotifier,Map<String, List<ActorEntity>>>((ref){

  final getActorsByMovie = ref.watch(actorRepositoryProvider).getActorsByMovie;

  return ActorsByMovieNotifier(getActors: getActorsByMovie);
});


typedef GetActorsCallback = Future<List<ActorEntity>> Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<ActorEntity>>>{

  final GetActorsCallback getActors;

  ActorsByMovieNotifier({required this.getActors}): super({});

  Future<void> getActorsByMovie(String movieId) async {

    if(state[movieId] != null) return;

    final movie = await getActors(movieId);

    state = {...state, movieId: movie};
  }

}