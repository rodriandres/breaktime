import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/actor.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';


final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {
  final actorsRepository = ref.watch( actorsRepositoryProvider ).getActorsByMovie;

  return ActorsByMovieNotifier(getActors: actorsRepository);
});

typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String,List<Actor>>> {

  final GetActorsCallback getActors;

  ActorsByMovieNotifier({
    required this.getActors
  }):super({});

  Future<void> loadActors( String movieId ) async {
    if ( state[movieId] != null ) return ;

    final List<Actor> actors = await getActors( movieId );

    state = { ...state, movieId: actors };
  }
}
