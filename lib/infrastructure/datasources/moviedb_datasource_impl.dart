import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/moviesdb_datasources.dart';
import 'package:cinemapedia/domain/entiites/movie_entity.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_data_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasourceImpl extends MoviesDBDatasource{

  final dio = Dio(BaseOptions(
    baseUrl: "https://api.themoviedb.org/3",
   headers: {
      'Authorization': 'Bearer ${Environment.theMovieDbTokenKey}',
      'accept': 'application/json'
    },
    )
  );

  @override
  Future<List<MovieEntity>> getNowPlaying({int page = 1}) async {
    final response = await dio.get("/movie/now_playing");

    final moviesResponse = MovieDataResponse.fromJson(response.data);
    final List<MovieEntity> movies = moviesResponse.results
    .where((movie) => movie.posterPath != "no-poster")
    .map((movie) => MovieMapper.movieDBToEntity(movie))
    .toList();
    
    return movies;
  }

}