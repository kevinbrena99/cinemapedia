import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_format.dart';
import 'package:cinemapedia/domain/entiites/movie_entity.dart';
import 'package:flutter/material.dart';

class MovieHorizontalListview extends StatefulWidget {
  final List<MovieEntity> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview({
    super.key,
    required this.movies,
    this.title,
    this.subTitle,
    this.loadNextPage,
  });

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener((){
      if(widget.loadNextPage == null) return ;
      if(scrollController.position.pixels + 200 >= scrollController.position.maxScrollExtent){
          widget.loadNextPage!();
      }
    });
  }

@override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if(widget.title != null || widget.subTitle != null)
            _Title(
              title: widget.title,
              subTitle: widget.subTitle,
            ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => FadeInRight(child: _Slide(movie: widget.movies[index])),))
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {

  final String? title;
  final String? subTitle;

  const _Title({ this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    final themeText = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if(title != null)
           Text(title!, style: themeText),
          Spacer(),
          if(subTitle != null)
            FilledButton(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: (){}, 
              child: Text(subTitle!))
            
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {

  final MovieEntity movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final themeText = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                fit: BoxFit.cover,
                movie.posterPath,
                width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if(loadingProgress != null){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  }
                  return FadeIn(child: child);
                }),
            ),
          ),

          // Title

          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2,
              style: themeText.titleSmall,
            ),
          ),

           // Rating

           SizedBox(
            width: 150,
             child: Row(
              children: [
                Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
                const SizedBox(height: 10),
                Text("${movie.voteAverage}", style: themeText.bodyMedium!.copyWith(color: Colors.yellow.shade800)),
                const Spacer(),
                Text(HumanFormat.number(movie.popularity), style: themeText.bodySmall),
              ],
             ),
           )
        ],
      ),
    );
  }
}