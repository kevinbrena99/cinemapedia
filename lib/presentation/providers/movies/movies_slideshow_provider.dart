

import 'package:cinemapedia/domain/entiites/movie_entity.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moviesSlideShowProvider = Provider<List<MovieEntity>>((ref){

      final nowPlayingMovieProvider = ref.watch(nowPlayingMoviesProvider);

      if(nowPlayingMovieProvider.isEmpty) return [];

      return nowPlayingMovieProvider.sublist(0,6);

});