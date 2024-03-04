import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const name = 'home-screen';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {


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

    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider);
    final nowSlideshowMovies = ref.watch( moviesSlideshowProvider );
    final popularMovies = ref.watch( popularMoviesProvider);
    final upcomingMovies = ref.watch( upcomingMoviesProvider);
    final topRatedMovies = ref.watch( topRatedgMoviesProvider);

    return CustomScrollView(
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
            
                // const CustomAppbar(),
            
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
    );
  }
}