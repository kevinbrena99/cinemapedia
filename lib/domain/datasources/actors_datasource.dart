import 'package:cinemapedia/domain/entiites/actor_entity.dart';

abstract class ActorsDatasource {

  Future<List<ActorEntity>> getActorsByMovie( String movieId );

}