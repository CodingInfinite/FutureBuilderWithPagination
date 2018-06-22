import 'dart:async';
import 'movie_data.dart';
import 'package:flutter/foundation.dart';

class MovieMockRepository extends MovieRepository {
  @override
  Future<Movies> fetchMovies(int pageNumber) async {
    print("Movie mocking called");
    return compute(createMovies, 100);
  }
}

Movies createMovies(int x) {
  return Movies(
      page: 2,
      totalPages: 10,
      totalResults: 100,
      movies: List<Movie>.generate(x, (int i) {
        return Movie(
          title: "Deadpool $i",
          posterPath: "\/c9XxwwhPHdaImA2f1WEfEsbhaFB.jpg",
          id: i.toString(),
          overview: "Jurasic World movie is awesome!",
          voteAverage: "4.5",
        );
      }));
}
