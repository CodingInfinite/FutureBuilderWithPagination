import 'dart:async';
import 'package:http/http.dart' as http;
import 'movie_data.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

const MOVIE_API_KEY = "e5c7041343c9969c537ddc8b720e80c7";
const BASE_URL = "https://api.themoviedb.org/3/movie/";

class MovieProdRepository implements MovieRepository {
  @override
  Future<Movies> fetchMovies(int pageNumber) async {
    http.Response response = await http.get(BASE_URL +
        "popular?api_key=" +
        MOVIE_API_KEY +
        "&page=" +
        pageNumber.toString());
    return compute(parseMovies, response.body);
  }
}

Movies parseMovies(String responseBody) {
  final Map moviesMap = JsonCodec().decode(responseBody);
  print(moviesMap);
  Movies movies = Movies.fromMap(moviesMap);
  if (movies == null) {
    throw new FetchMovieException("An error occurred : [ Status Code = ]");
  }
  return movies;
}
