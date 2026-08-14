import 'package:cinemapedia/domain/entiites/movie_entity.dart';

abstract class MoviesRepository {

  Future<List<MovieEntity>> getNowPlaying({ int page = 1 });

}