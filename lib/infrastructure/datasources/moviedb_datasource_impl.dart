import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/moviesdb_datasources.dart';
import 'package:cinemapedia/domain/entiites/movie_entity.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_data_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasourceImpl extends MoviesDBDatasource{

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


  List<MovieEntity> _jsonToMovies(Map<String, dynamic> json){
     final moviesResponse = MovieDataResponse.fromJson(json);
    final List<MovieEntity> movies = moviesResponse.results
    .where((movie) => movie.posterPath != "no-poster")
    .map((movie) => MovieMapper.movieDBToEntity(movie))
    .toList();
    
    return movies;
  }
  


  @override
  Future<List<MovieEntity>> getNowPlaying({int page = 1}) async {
    final response = await dio.get("/movie/now_playing",
    queryParameters: {
      "page": page
    });
    
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<MovieEntity>> getPopulars({int page = 1}) async {
     final response = await dio.get("/movie/popular",
    queryParameters: {
      "page": page
    });

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<MovieEntity>> getTopsReated({int page = 1}) async {
     final response = await dio.get("/movie/top_rated",
    queryParameters: {
      "page": page
    });

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<MovieEntity>> getUpComing({int page = 1}) async {
    final response = await dio.get("/movie/upcoming",
    queryParameters: {
      "page": page
    });

    return _jsonToMovies(response.data);
  }

  @override
  Future<MovieEntity> getMovieById(String movieId) async {
    final response = await dio.get("/movie/$movieId");

    if(response.statusCode != 200) throw Exception("Movie with id: $movieId not found");

    return MovieMapper.movieDetailsToEntity(MovieDetailsResponse.fromJson(response.data));
  }

  @override
  Future<List<MovieEntity>> searchMovies(String query) async {

    if(query.isEmpty) return [];

     final response = await dio.get("/search/movie",
    queryParameters: {
      "query": query
    });

    return _jsonToMovies(response.data);
  }

}