

import 'package:cinemapedia/domain/entiites/movie_entity.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier,List<MovieEntity>>((ref){

  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;

  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

typedef MovieCallback = Future<List<MovieEntity>> Function({int page});


class MoviesNotifier extends StateNotifier<List<MovieEntity>>{

  int currentPage = 0;
  MovieCallback fetchMoreMovies;
  bool isLoading = false;

  MoviesNotifier({
    required this.fetchMoreMovies,
  }): super ([]);

  Future<void> loadNextPage() async{
    if(isLoading) return;
    isLoading = true;
    currentPage++;
    final List<MovieEntity> movies = await fetchMoreMovies(page: currentPage);
    state = [...state,...movies];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
  
}