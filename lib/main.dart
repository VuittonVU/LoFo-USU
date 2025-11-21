import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'config/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = createRouter();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'LoFo USU',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      routerConfig: router,
    );
  }
}
