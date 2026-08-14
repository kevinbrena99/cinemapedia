import 'package:cinemapedia/domain/datasources/moviesdb_datasources.dart';
import 'package:cinemapedia/domain/entiites/movie_entity.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';


class MovieRepositoryImpl extends MoviesRepository {

  final MoviesDBDatasource datasource;
  MovieRepositoryImpl(this.datasource);

  
  @override
  Future<List<MovieEntity>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }


}