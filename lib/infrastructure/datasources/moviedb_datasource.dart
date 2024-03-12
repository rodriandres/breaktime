import 'package:cinemapedia/infrastructure/mappers/mappers.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_videos.dart';
import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';

import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/domain/entities/entities.dart';


class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'en-US'
      }
    )
  );

  List<Movie> _jsonToMovies( Map<String,dynamic> json) {
      final movieDbReponse = MovieDbResponse.fromJson(json);

      final List<Movie> movies = movieDbReponse.results
      .where((moviedb) => moviedb.posterPath != 'no-poster') // to avoid render movies that doesnt have poster
      .map(
        (movie) => MovieMapper.movieDBToEntity(movie))
      .toList();

      return movies;
  }
 
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
      final response = await dio.get('/movie/now_playing',
        queryParameters: {
          'page': page,
        }
      );

      return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get('/movie/popular',
      queryParameters: {
        'page': page,
      }
    );
    
    return _jsonToMovies(response.data);

  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get('/movie/upcoming',
      queryParameters: {
        'page': page,
      }
    );
    
    return _jsonToMovies(response.data);

  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get('/movie/top_rated',
      queryParameters: {
        'page': page,
      }
    );
    
    return _jsonToMovies(response.data);

  }
  
  @override
  Future<Movie> getMovieById( String id ) async {
    final response = await dio.get('/movie/$id');

    if ( response.statusCode != 200 ) throw Exception('Movie with id: $id not found');

    final movieDetails = MovieDetails.fromJson(response.data);

    final movie = MovieMapper.movieDetailsToEntity(movieDetails);

    return movie;
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) [];

    final response = await dio.get('/search/movie',
      queryParameters: {
        'query': query,
      }
    );

    return _jsonToMovies(response.data);
  }

    @override
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final response = await dio.get('/movie/$movieId/similar');
    return _jsonToMovies(response.data);
  }

  
  @override
  Future<List<Video>> getYoutubeVideosById(int movieId) async {
    final response = await dio.get('/movie/$movieId/videos');
    final moviedbVideosReponse = MoviedbVideosResponse.fromJson(response.data);
    final videos = <Video>[];

    for (final moviedbVideo in moviedbVideosReponse.results) {
      if ( moviedbVideo.site == 'YouTube' ) {
        final video = VideoMapper.moviedbVideoToEntity(moviedbVideo);
        videos.add(video);
      }
    }

    return videos;
  }
}