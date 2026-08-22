

import 'package:cinemapedia/domain/entiites/movie_entity.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final searchQueryProvider = StateProvider<String>((ref) => "");

final searchedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier, List<MovieEntity>>((ref) {
  final movieRepository = ref.read(movieRepositoryProvider);

  return SearchedMoviesNotifier(searchMovies: movieRepository.searchMovies, ref: ref);
});


typedef SearchMoviesCallback = Future<List<MovieEntity>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<MovieEntity>>{

  SearchMoviesCallback searchMovies;
  final Ref ref;

  SearchedMoviesNotifier({
    required this.searchMovies, required this.ref
  }): super([]);

  Future<List<MovieEntity>> searchMoviesByQuery(String query) async {
    
    final List<MovieEntity> movies = await searchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);

    state = movies;
    return movies;
  }
  
}