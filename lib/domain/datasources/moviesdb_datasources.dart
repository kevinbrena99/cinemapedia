import 'package:cinemapedia/domain/entiites/movie_entity.dart';

abstract class MoviesDBDatasource {

  Future<List<MovieEntity>> getNowPlaying({ int page = 1 });

}