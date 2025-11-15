import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ===== IMPORT SEMUA SCREEN =====
import '../screens/splash_screen.dart';
import '../screens/login_registrasi/signin_screen.dart';
import '../screens/login_registrasi/signup_screen.dart';
import '../screens/login_registrasi/otp_screen.dart';
import '../screens/login_registrasi/identitas_screen.dart';
import '../screens/login_registrasi/kontak_screen.dart';
import '../screens/login_registrasi/berhasil_screen.dart';

import '../screens/home_screen.dart';
import '../screens/main_navigation.dart'; // controller bottom nav

// ===== ROUTE NAMES & PATHS DALAM SATU TEMPAT =====
class AppRoutes {
  static const String splash = '/';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String otp = '/otp';
  static const String identitas = '/identitas';
  static const String kontak = '/kontak';
  static const String berhasil = '/berhasil';

  // ===== HALAMAN UTAMA NAVIGASI =====
  static const String mainNav = '/main';
  static const String home = '/home';
}

// ===== ROUTER FINAL TANPA ERROR =====
GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,

    routes: [
      GoRoute(
        name: 'splash',
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        name: 'signin',
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),

      GoRoute(
        name: 'signup',
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),

      GoRoute(
        name: 'otp',
        path: AppRoutes.otp,
        builder: (context, state) => const OtpScreen(),
      ),

      GoRoute(
        name: 'identitas',
        path: AppRoutes.identitas,
        builder: (context, state) => const IdentitasScreen(),
      ),

      GoRoute(
        name: 'kontak',
        path: AppRoutes.kontak,
        builder: (context, state) => const KontakScreen(),
      ),

      GoRoute(
        name: 'berhasil',
        path: AppRoutes.berhasil,
        builder: (context, state) => const BerhasilScreen(),
      ),

      // =============================
      // HALAMAN UTAMA DENGAN BOTTOM NAV
      // =============================
      GoRoute(
        name: 'main',
        path: AppRoutes.mainNav,
        builder: (context, state) => const MainNavigationScreen(),
      ),

      // Optional: akses HomeScreen saja (bukan disarankan)
      GoRoute(
        name: 'home',
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],

    // ===== 404 PAGE =====
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 70),
            const SizedBox(height: 15),
            const Text(
              "404 - Page Tidak Ditemukan",
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
