import 'package:flutter/material.dart';
import 'package:movie_searcher/ui/movie_list_tile.dart';
import 'package:movie_searcher/data/movie_data.dart';
import 'package:movie_searcher/dependency_injection.dart';
import 'package:movie_searcher/commonWidgets/placeholder_content.dart';

final Injector injector = Injector();
const int FIRST_PAGE_MOVIE = 1;

void main() {
  Injector.configure(Flavor.PROD);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Movie Seacher",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Home page building block");
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Movie Searcher",
            textDirection: TextDirection.ltr,
          ),
        ),
        body: MoviePage());
  }
}

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  Widget build(BuildContext context) {
    print("Building block");
    return new FutureBuilder<Movies>(
        future: injector.movieRepository.fetchMovies(FIRST_PAGE_MOVIE),
        builder: (context, snapshots) {
          if (snapshots.hasError)
            return PlaceHolderContent(
              title: "Problem Occurred",
              message: "Internet not connect try again",
              tryAgainButton: _tryAgainButtonClick,
            );
          switch (snapshots.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return MovieTile(movies: snapshots.data);
            default:
          }
        });
  }

  _tryAgainButtonClick(bool _) => setState(() {});
}

class MovieTile extends StatefulWidget {
  final Movies movies;

  MovieTile({Key key, this.movies}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MovieTileState();
}

class MovieTileState extends State<MovieTile> {
  MovieLoadMoreStatus loadMoreStatus = MovieLoadMoreStatus.STABLE;
  final ScrollController scrollController = new ScrollController();
  static const String IMAGE_BASE_URL = "http://image.tmdb.org/t/p/w185";
  List<Movie> movies;
  int currentPageNumber;

  @override
  void initState() {
    movies = widget.movies.movies;
    currentPageNumber = widget.movies.page;
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
        onNotification: onNotification,
        child: new GridView.builder(
            padding: EdgeInsets.only(top: 5.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
            ),
            controller: scrollController,
            itemCount: movies.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              return MovieListTile(movie: movies[index]);
            }));
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent > scrollController.offset &&
          scrollController.position.maxScrollExtent - scrollController.offset <=
              50) {
        if (loadMoreStatus != null &&
            loadMoreStatus == MovieLoadMoreStatus.STABLE) {
          loadMoreStatus = MovieLoadMoreStatus.LOADING;
          injector.movieRepository
              .fetchMovies(currentPageNumber + 1)
              .then((moviesObject) {
            currentPageNumber = moviesObject.page;
            loadMoreStatus = MovieLoadMoreStatus.STABLE;
            setState(() => movies.addAll(moviesObject.movies));
          });
        }
      }
    }
    return true;
  }

  var meg = function("Hello");
}

// high level Function
var function = (String msg) => '!!!${msg.toUpperCase()}!!!';
