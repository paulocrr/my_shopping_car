import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shopping_car/firebase_options.dart';
import 'package:my_shopping_car/ui/navigation/shopping_routes.dart';
import 'package:my_shopping_car/ui/screens/home_screen.dart';
import 'package:my_shopping_car/ui/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
      redirect: (context, state) {
        return ShoppingRoutes.login;
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
