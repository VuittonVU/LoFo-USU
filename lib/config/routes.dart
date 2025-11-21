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
import '../screens/main/filter_screen.dart';
import '../screens/main/add_new_laporan.dart';
import '../screens/main/laporan_aktif_screen_pelapor.dart';

class AppRoutes {
  static const String splash    = '/';
  static const String welcome   = '/welcome';

  // AUTH
  static const String signIn    = '/signin';
  static const String signUp    = '/signup';
  static const String otp       = '/otp';
  static const String identitas = '/identitas';
  static const String kontak    = '/kontak';
  static const String berhasil  = '/berhasil';

  // MAIN
  static const String mainNav   = '/main';
  static const String notif     = '/notifikasi';
  static const String filter    = '/filter';
  static const String addLaporan = '/add-laporan';
  static const String laporanAktif = '/laporan-aktif';

}

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,

    routes: [
      // ============================
      // ONBOARDING
      // ============================
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (_, __) => const WelcomeScreen(),
      ),

      // ============================
      // AUTH
      // ============================
      GoRoute(
        path: AppRoutes.signIn,
        builder: (_, __) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (_, __) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (_, __) => const OtpScreen(),
      ),
      GoRoute(
        path: AppRoutes.identitas,
        builder: (_, __) => const IdentitasScreen(),
      ),
      GoRoute(
        path: AppRoutes.kontak,
        builder: (_, __) => const KontakScreen(),
      ),
      GoRoute(
        path: AppRoutes.berhasil,
        builder: (_, __) => const BerhasilScreen(),
      ),

      // ============================
      // NOTIFIKASI
      // ============================
      GoRoute(
        path: AppRoutes.notif,
        builder: (_, __) => const NotificationScreen(),
      ),

      // ============================
      // FILTER
      // ============================
      GoRoute(
        path: AppRoutes.filter,
        builder: (_, __) => const FilterScreen(),
      ),

      // ============================
      // ADD LAPORAN
      // ============================
      GoRoute(
        path: AppRoutes.addLaporan,
        builder: (_, __) => const AddLaporanScreen(),
      ),

      // ============================
      // LAPORAN AKTIF (Detail Item)
      // ============================
      GoRoute(
        path: AppRoutes.laporanAktif,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;

          return ItemDetailScreen(
            images: data?["images"] ?? [],
            title: data?["title"] ?? "-",
            reporterName: data?["reporterName"] ?? "-",
            dateFound: data?["dateFound"] ?? "-",
            locationFound: data?["locationFound"] ?? "-",
            category: data?["category"] ?? "-",
            description: data?["description"] ?? "-",
            status: data?["status"] ?? "Aktif",
          );
        },
      ),

      // ============================
      // MAIN NAVIGATION
      // ============================
      GoRoute(
        path: AppRoutes.mainNav,
        builder: (context, state) {
          final p = state.uri.queryParameters;

          return MainNavigationScreen(
            startIndex: int.tryParse(p["startIndex"] ?? "0") ?? 0,
            kategori: p["kategori"],
            lokasi:   p["lokasi"],
            urutan:   p["urutan"],
          );
        },
      ),
    ],

    // ============================
    // ERROR PAGE
    // ============================
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
