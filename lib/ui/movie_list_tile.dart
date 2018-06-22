import 'package:flutter/material.dart';
import 'package:movie_searcher/data/movie_data.dart';
import 'package:movie_searcher/network/network_image.dart';

const String IMAGE_BASE_URL = "http://image.tmdb.org/t/p/w185";

class MovieListTile extends StatelessWidget {
  MovieListTile({this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
        ),
        color: Colors.white,
        elevation: 5.0,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image(
              image: NetworkImageWithRetry(
                IMAGE_BASE_URL + movie.posterPath,
                scale: 0.85,
              ),
              fit: BoxFit.fill,
            ),
            _MovieFavoredImage(movie: movie),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 5.0,
                    right: 5.0,
                  ),
                  child: Text('Rating : ${movie.voteAverage}'),
                )),
          ],
        ));
  }
}

class _MovieFavoredImage extends StatefulWidget {
  final Movie movie;
  _MovieFavoredImage({@required this.movie});

  @override
  State<StatefulWidget> createState() => _MovieFavoredImageState();
}

class _MovieFavoredImageState extends State<_MovieFavoredImage> {
  Movie currentMovie;

  @override
  void initState() {
    currentMovie = widget.movie;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Align(
        alignment: Alignment.topRight,
        child: new IconButton(
          icon: Icon(currentMovie.favored ? Icons.star : Icons.star_border),
          onPressed: onFavoredImagePressed,
        ),
      ),
    );
  }

  onFavoredImagePressed() {
    setState(() => currentMovie.favored = !currentMovie.favored);
  }
}
