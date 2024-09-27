import 'package:cinemapedia/presentation/screens/views/home_views/favorite_view.dart';
import 'package:cinemapedia/presentation/screens/views/home_views/home_view.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final int pageIndex;
  static const name = 'home-screen';

  const HomeScreen({
    super.key,
    required this.pageIndex,
  });

  final viewRoutes = const <Widget>[
    HomeView(),
    SizedBox(),
    FavoriteView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: pageIndex,),
    );
  }
}
