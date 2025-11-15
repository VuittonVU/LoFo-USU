import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ====== ONBOARDING ======
import '../screens/onboarding/splash_screen.dart';
import '../screens/onboarding/welcome_screen.dart';

// ====== AUTH ======
import '../screens/auth/signin_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/identitas_screen.dart';
import '../screens/auth/kontak_screen.dart';
import '../screens/auth/berhasil_screen.dart';

// ====== MAIN ======
import '../screens/main/main_navigation_screen.dart';
import '../screens/main/notification_screen.dart';

class AppRoutes {
  // ONBOARDING
  static const String splash = '/';
  static const String welcome = '/welcome';

  // AUTH
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String otp = '/otp';
  static const String identitas = '/identitas';
  static const String kontak = '/kontak';
  static const String berhasil = '/berhasil';

  // MAIN (HANYA INI YANG DIPAKAI)
  static const String mainNav = '/main';
}

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,

    routes: [
      // =====================================================
      // ONBOARDING
      // =====================================================
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),

      // =====================================================
      // AUTH
      // =====================================================
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
      GoRoute(
        path: '/notifikasi',
        builder: (context, state) => const NotificationScreen(),
      ),

      // =====================================================
      // MAIN NAVIGATION (SATU-SATUNYA MAIN ROUTE)
      // =====================================================
      GoRoute(
        path: AppRoutes.mainNav,
        builder: (context, state) => const MainNavigationScreen(),
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 70),
            const SizedBox(height: 12),
            const Text(
              "404 - Page Tidak Ditemukan",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(state.uri.toString()),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.splash),
              child: const Text("Kembali ke Awal"),
            ),
          ],
        ),
      ),
    ),
  );
}
