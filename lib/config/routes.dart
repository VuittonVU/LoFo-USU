import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ====== ONBOARDING ======
import '../screens/onboarding/splash_screen.dart';
import '../screens/onboarding/welcome_screen.dart';

// ====== AUTH ======
import '../screens/auth/signin_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/EmailVerificationScreen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/identitas_screen.dart';
import '../screens/auth/kontak_screen.dart';
import '../screens/auth/berhasil_screen.dart';

// ====== MAIN ======
import '../screens/main/main_navigation_screen.dart';
import '../screens/main/notification_screen.dart';
import '../screens/main/filter_screen.dart';
import '../screens/main/add_new_laporan.dart';
import '../screens/main/laporan_pelapor.dart';
import '../screens/main/edit_laporan.dart';
import '../screens/main/edit_dokumentasi_screen.dart';

// ====== PROFILE ======
import '../screens/main/profile_screen.dart';
import '../screens/main/edit_profile_screen.dart';
import '../screens/main/account_settings_screen.dart';

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
  static const String mainNav     = '/main';
  static const String notif       = '/notifikasi';
  static const String filter      = '/filter';
  static const String addLaporan  = '/add-laporan';
  static const String laporanItem = '/laporan-aktif';   // item detail

  // EDIT ROUTES
  static const String editLaporan      = '/edit-laporan';
  static const String editDokumentasi  = '/edit-dokumentasi';

  // PROFILE
  static const String profile        = '/profile';
  static const String editProfile    = '/edit-profile';
  static const String accountSettings = '/account-settings';
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
        path: '/email-verification',
        builder: (_, __) => const EmailVerificationScreen(),
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
      // NOTIFICATION
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
      // LAPORAN PELAPOR (DETAIL ITEM)
      // ============================
      GoRoute(
        path: AppRoutes.laporanItem,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};

          return LaporanPelaporScreen(
            images: data["images"] ?? [],
            title: data["title"] ?? "-",
            reporterName: data["reporterName"] ?? "-",
            dateFound: data["dateFound"] ?? "-",
            locationFound: data["locationFound"] ?? "-",
            category: data["category"] ?? "-",
            description: data["description"] ?? "-",
            status: data["status"] ?? "Aktif",
          );
        },
      ),

      // ============================
      // EDIT LAPORAN
      // ============================
      GoRoute(
        path: AppRoutes.editLaporan,
        builder: (_, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};

          return EditLaporanScreen(
            images: data["images"] ?? [],
            title: data["title"] ?? "",
            reporterName: data["reporterName"] ?? "",
            dateFound: data["dateFound"] ?? "",
            locationFound: data["locationFound"] ?? "",
            category: data["category"] ?? "",
            description: data["description"] ?? "",
            status: data["status"] ?? "Aktif",
          );
        },
      ),

      // ============================
      // EDIT DOKUMENTASI
      // ============================
      GoRoute(
        path: AppRoutes.editDokumentasi,
        builder: (_, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};

          return EditDokumentasiScreen(
            images: data["images"] ?? [],
            title: data["title"] ?? "",
            status: data["status"] ?? "Dalam Proses",
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

      // ============================
      // PROFILE
      // ============================
      // PROFILE
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, __) => const ProfileScreen(),
      ),

      GoRoute(
        path: AppRoutes.editProfile,
        builder: (_, __) => const EditProfileScreen(),
      ),

      GoRoute(
        path: AppRoutes.accountSettings,
        builder: (_, __) => const AccountSettingsScreen(),
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
