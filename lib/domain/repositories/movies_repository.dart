import 'package:cinemapedia/domain/entiites/movie_entity.dart';

abstract class MoviesRepository {

  Future<List<MovieEntity>> getNowPlaying({ int page = 1 });

  Future<List<MovieEntity>> getPopulars({ int page = 1 });

  Future<List<MovieEntity>> getTopsReated({ int page = 1 });

  Future<List<MovieEntity>> getUpComming({ int page = 1 });

}