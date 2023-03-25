import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_shopping_car/blocs/auth_bloc.dart';
import 'package:my_shopping_car/firebase_options.dart';
import 'package:my_shopping_car/ui/navigation/shopping_routes.dart';
import 'package:my_shopping_car/ui/screens/home_screen.dart';
import 'package:my_shopping_car/ui/screens/login_screen.dart';
import 'package:my_shopping_car/utilities/go_router_refresh_stream.dart';
import 'package:my_shopping_car/utilities/my_bloc_observer.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationSupportDirectory());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = MyBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoRouter router;

  @override
  void initState() {
    super.initState();

    final authBloc = context.read<AuthBloc>();

    router = GoRouter(
      routes: [
        GoRoute(
          path: ShoppingRoutes.login,
          builder: (_, __) => const LoginScreen(),
        ),
        GoRoute(
          path: ShoppingRoutes.home,
          builder: (_, __) => const HomeScreen(),
        ),
      ],
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        if (!authBloc.state.isAuthenticated) {
          return ShoppingRoutes.login;
        } else {
          return ShoppingRoutes.home;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      title: 'My shopping car',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
