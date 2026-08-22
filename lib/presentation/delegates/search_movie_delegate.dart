import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_format.dart';
import 'package:cinemapedia/domain/entiites/movie_entity.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<MovieEntity>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<MovieEntity?> {
  final SearchMoviesCallback searchMoviesCallback;
  List<MovieEntity> initialMovies;

  StreamController<List<MovieEntity>> debounceMovies =
      StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMoviesCallback,
    required this.initialMovies,
  });

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMoviesCallback(query);
      initialMovies = movies;
      debounceMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  void clearStreams() {
    debounceMovies.close();
  }

  @override
  String? get searchFieldLabel => "Buscar pelicula";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          final isLoading = snapshot.data ?? false;

          return isLoading
              ? SpinPerfect(
                  duration: const Duration(seconds: 20),
                  spins: 10,
                  infinite: true,
                  child: IconButton(
                    onPressed: () => query = "",
                    icon: Icon(Icons.clear),
                  ),
                )
              : FadeIn(
                  animate: query.isNotEmpty,
                  duration: const Duration(milliseconds: 150),
                  child: IconButton(
                    onPressed: () => query = "",
                    icon: Icon(Icons.clear),
                  ),
                );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios_new_outlined),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _BuildResultsAndSuggestions(
      movies: initialMovies,
      movieStreamController: debounceMovies,
      movieSelected: (movie) {
        clearStreams();
        close(context, movie);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);

    return _BuildResultsAndSuggestions(
      movies: initialMovies,
      movieStreamController: debounceMovies,
      movieSelected: (movie) {
        clearStreams();
        close(context, movie);
      },
    );
  }
}

class _BuildResultsAndSuggestions extends StatelessWidget {
  final List<MovieEntity> movies;
  final StreamController movieStreamController;
  final Function(MovieEntity) movieSelected;

  const _BuildResultsAndSuggestions({
    required this.movies,
    required this.movieStreamController,
    required this.movieSelected,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: movies,
      stream: movieStreamController.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieItem(movie: movie, onMovieSelected: movieSelected);
          },
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final MovieEntity movie;
  final Function onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => onMovieSelected(movie),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) =>
                      FadeIn(child: child),
                ),
              ),
            ),

            SizedBox(width: 10),

            SizedBox(
              width: (size.width) * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleMedium),

                  (movie.overview.length > 100)
                      ? Text('${movie.overview.substring(0, 100)}...')
                      : Text(movie.overview),

                  Row(
                    children: [
                      Icon(
                        Icons.star_half_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        HumanFormat.number(movie.voteAverage, 1),
                        style: textStyles.bodyMedium!.copyWith(
                          color: Colors.yellow.shade900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
