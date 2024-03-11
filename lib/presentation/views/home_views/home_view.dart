import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView();

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {


  @override
  void initState() {
    
    super.initState();
    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
    ref.read( popularMoviesProvider.notifier ).loadNextPage();
    ref.read( upcomingMoviesProvider.notifier ).loadNextPage();
    ref.read( topRatedgMoviesProvider.notifier ).loadNextPage();

  }

  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch( initialLoadingProvider );

    if ( initialLoading ) return const FullScreenLoader(); 

    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider);
    final nowSlideshowMovies = ref.watch( moviesSlideshowProvider );
    final popularMovies = ref.watch( popularMoviesProvider);
    final upcomingMovies = ref.watch( upcomingMoviesProvider);
    final topRatedMovies = ref.watch( topRatedgMoviesProvider); 

    return Visibility(
      visible: !initialLoading,
      child: CustomScrollView(
        slivers: [
      
          const SliverAppBar(
            floating: true,
            title: CustomAppbar(),
          ),
      
      
          SliverList(
            delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (context, index) {
              return Column(
                children: [
              
                  MoviesSlidershow(movies: nowSlideshowMovies),
              
              
                  MovieHorizontalListview(
                    movies: nowPlayingMovies,
                    title: 'En cines',
                    loadNextPage: () => ref.read( nowPlayingMoviesProvider.notifier).loadNextPage(),
                  ),
      
                  MovieHorizontalListview(
                    movies: upcomingMovies,
                    title: 'Proximamente',
                    subTitle: 'Viernes 8',
                    loadNextPage: () => ref.read( upcomingMoviesProvider.notifier).loadNextPage(),
                  ),
      
      
                  MovieHorizontalListview(
                    movies: popularMovies,
                    title: 'Populares',
                    loadNextPage: () => ref.read( popularMoviesProvider.notifier).loadNextPage(),
                  ),
      
                  MovieHorizontalListview(
                    movies: topRatedMovies,
                    title: 'Mejor Calificadas',
                    loadNextPage: () => ref.read( topRatedgMoviesProvider.notifier).loadNextPage(),
                  ),
              
                  
                ],
              );
            },
          )
          )
      
      
        ]
      ),
    );
  }
}