
import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';

import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';

import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorMoviedbDatasource extends ActorsDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'en-US'
      }
    )
  );

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {

    final response = await dio.get('/movie/$movieId/credits');

    final castDbResponse = CreditsResponse.fromJson(response.data);

    final List<Actor> actors = castDbResponse.cast
    // .where((moviedb) => moviedb.posterPath != 'no-poster') // to avoid render movies that doesnt have poster
    .map(
      (cast) => ActorMapper.castToEntity(cast))
    .toList();

    return actors;
  }

}