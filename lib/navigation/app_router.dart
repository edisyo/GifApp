import 'package:gif_app/data/models/gif.dart';
import 'package:gif_app/screens/detail_page.dart';
import 'package:gif_app/screens/search_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter goRouter = GoRouter(routes: [
  // home page
  GoRoute(
    path: '/',
    builder: (context, state) => SearchPage()
  ),

  // detailed view
  GoRoute(
    path: '/gif',
    builder: (context, state) => DetailPage(gif: state.extra as Gif)
  )
]);