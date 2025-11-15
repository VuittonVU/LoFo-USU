import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ==== IMPORT SEMUA SCREEN YANG ADA ====
import '../screens/splash_screen.dart';
import '../screens/signin_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/identitas_screen.dart';
import '../screens/kontak_screen.dart';
import '../screens/berhasil_screen.dart';

// ==== SEMUA PATH DISATUKAN DALAM SATU TEMPAT ====
class AppRoutes {
  static const String splash = '/';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String otp = '/otp';
  static const String identitas = '/identitas';
  static const String kontak = '/kontak';
  static const String berhasil = '/berhasil';
}

// ==== ROUTER FINAL TANPA ERROR ====
GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,

    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: AppRoutes.identitas,
        builder: (context, state) => const IdentitasScreen(),
      ),
      GoRoute(
        path: AppRoutes.kontak,
        builder: (context, state) => const KontakScreen(),
      ),
      GoRoute(
        path: AppRoutes.berhasil,
        builder: (context, state) => const BerhasilScreen(),
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 70),
            const SizedBox(height: 15),
            const Text(
              "404 - Page Not Found",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            Text(state.uri.toString()),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.splash),
              child: const Text("Kembali ke Awal"),
            )
          ],
        ),
      ),
    ),
  );
}
