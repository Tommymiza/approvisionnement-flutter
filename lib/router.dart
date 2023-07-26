import 'package:approvisionnement/pages/login.dart';
import 'package:approvisionnement/pages/oneconsumer.dart';
import 'package:approvisionnement/pages/oneprovider.dart';
import 'package:approvisionnement/pages/struct.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/appro',
    builder: (context, state) => const Struct(),
  ),
  GoRoute(
    path: "/",
    builder: (context, state) => const Login(),
  ),
  GoRoute(
      name: "provider",
      path: "/provider",
      builder: (context, state) => OneProvider(id: state.extra as String)),
  GoRoute(
      name: "consumer",
      path: "/consumer",
      builder: (context, state) => OneConsumer(id: state.extra as String)),
]);
