import 'package:cinemapedia/domain/entiites/movie_entity.dart';

abstract class MoviesDBDatasource {

  Future<List<MovieEntity>> getNowPlaying({ int page = 1 });

  Future<List<MovieEntity>> getPopulars({ int page = 1 });

  Future<List<MovieEntity>> getTopsReated({ int page = 1 });

  Future<List<MovieEntity>> getUpComing({ int page = 1 });

  Future<MovieEntity> getMovieById( String movieId );
}