import 'package:cinemapedia/domain/entiites/actor_entity.dart';

abstract class ActorsRepository {

  Future<List<ActorEntity>> getActorsByMovie(String movieId);

}