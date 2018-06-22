import '../data/movie_data.dart';
import '../dependency_injection.dart';

abstract class MovieListViewContract {
  void onMovies(List<Movie> movies);
  void onLoadMoviesError();
}

class MovieListPresenter {
  final MovieListViewContract movieListViewContract;
  MovieRepository movieRepository;

  MovieListPresenter(this.movieListViewContract) {
    movieRepository = new Injector().movieRepository;
  }

  void loadMovies() {
    movieRepository
        .fetchMovies(1)
        .then((movies) => movieListViewContract.onMovies(movies.movies))
        .catchError((onError) => movieListViewContract.onLoadMoviesError());
  }
}
