import 'package:go_router/go_router.dart';

import '../mods/cat/cat.dart' show Cat;
import '../mods/todo/todo.dart' show Todo;

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Cat(),
    ),
    GoRoute(
      path: '/todo',
      builder: (context, state) => const Todo(),
    ),
  ],
);
