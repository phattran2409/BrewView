import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:briewview/app/router/route_paths.dart';
// import 'package:briewview/features/user_management/view/user_list_page.dart';

@singleton
class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: RoutePaths.userList,
      routes: [
        GoRoute(
          path: RoutePaths.userList,
          name: 'user-list',
          // builder: (context, state) => const UserListPage(),
        ),
      ],
    );
  }
}
