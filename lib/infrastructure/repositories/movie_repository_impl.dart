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

  @override
  Future<List<MovieEntity>> getPopulars({int page = 1}) {
    return datasource.getPopulars(page: page);
  }

  @override
  Future<List<MovieEntity>> getTopsReated({int page = 1}) {
    return datasource.getTopsReated();
  }

  @override
  Future<List<MovieEntity>> getUpComming({int page = 1}) {
    return datasource.getUpComing();
  }

  @override
  Future<MovieEntity> getMovieById(String movieId) {
    return datasource.getMovieById(movieId);
  }


}