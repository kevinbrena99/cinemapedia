import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entiites/actor_entity.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_,mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorsDatasourceImpl extends ActorsDatasource{

   final dio = Dio(BaseOptions(
    baseUrl: "https://api.themoviedb.org/3",
   headers: {
      'Authorization': 'Bearer ${Environment.theMovieDbTokenKey}',
      'accept': 'application/json'
    },
    )
  )
  ..interceptors.add(
    LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
  ),
  );

  @override
  Future<List<ActorEntity>> getActorsByMovie(String movieId) async{
    final response = await dio.get("/movie/$movieId/credits");
    final credits = CreditsResponse.fromJson(response.data);
    final List<ActorEntity> actors = credits.cast.map((cast) => ActorMapper.castToEntity(cast)).toList();
    return actors;
  }
}