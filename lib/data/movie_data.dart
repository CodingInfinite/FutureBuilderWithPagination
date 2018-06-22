import 'dart:async';

enum MovieLoadMoreStatus { LOADING, STABLE }

class Movie {
  Movie(
      {this.title,
      this.posterPath,
      this.id,
      this.overview,
      this.voteAverage,
      this.favored});

  final String title, posterPath, id, overview;
  final String voteAverage;
  bool favored;

  factory Movie.fromJson(Map value) {
    return Movie(
        title: value['title'],
        posterPath: value['poster_path'],
        id: value['id'].toString(),
        overview: value['overview'],
        voteAverage: value['vote_average'].toString(),
        favored: false);
  }
}

class Movies {
  Movies({
    this.page,
    this.totalResults,
    this.totalPages,
    this.movies,
  });

  final int page;
  final int totalResults;
  final int totalPages;
  final List<Movie> movies;

  call(String a, String b) => '$a $b';

  Movies.fromMap(Map<String, dynamic> value)
      : page = value['page'],
        totalResults = value['total_results'],
        totalPages = value['total_pages'],
        movies = new List<Movie>.from(
            value['results'].map((movie) => Movie.fromJson(movie)));
}

// Callable classes
// var movie = Movies();
// movie("a","b");   This function calling call function in Movies class.

abstract class MovieRepository {
  Future<Movies> fetchMovies(int pageNumber);
}

class FetchMovieException implements Exception {
  final _message;

  FetchMovieException([this._message]);

  String toString() {
    if (_message == null) return "Exception";
    return "Exception : $_message";
  }
}
