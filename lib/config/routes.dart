import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/admin_reports_screen.dart';
import '../screens/admin/admin_verification_screen.dart';


// ====== ONBOARDING ======
import '../screens/onboarding/splash_screen.dart';
import '../screens/onboarding/welcome_screen.dart';

// ====== AUTH ======
import '../screens/auth/signin_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/EmailVerificationScreen.dart';
import '../screens/auth/identitas_screen.dart';
import '../screens/auth/kontak_screen.dart';
import '../screens/auth/berhasil_screen.dart';

// ====== MAIN ======
import '../screens/main/main_navigation_screen.dart';
import '../screens/main/filter_screen.dart';
import '../screens/main/add_laporan_screen.dart';
import '../screens/main/report_history_screen.dart';

// ====== PROFILE ======
import '../screens/main/profile_screen.dart';
import '../screens/main/edit_profile_screen.dart';
import '../screens/main/account_settings_screen.dart';
import '../screens/main/report_user_screen.dart';

// ====== DETAIL ======
import '../screens/main/laporan_pelapor_screen.dart';
import '../screens/main/laporan_umum_screen.dart';
import '../screens/main/laporan_dokumentasi_screen.dart';

// ====== EDIT ======
import '../screens/main/edit_laporan.dart';
import '../screens/main/edit_dokumentasi_screen.dart';

class AppRoutes {
  static const String admin = '/admin';
  static const String adminReports = '/admin-reports';
  static const String adminVerifications = '/admin-verifications';

  static const String splash = '/';
  static const String welcome = '/welcome';

  // AUTH
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String emailVerification = '/email-verification';
  static const String identitas = '/identitas';
  static const String kontak = '/kontak';
  static const String berhasil = '/berhasil';

  // MAIN
  static const String mainNav = '/main';
  static const String notif = '/notifikasi';
  static const String filter = '/filter';
  static const String addLaporan = '/add-laporan';
  static const String reportHistory = '/riwayat';
  static const String dokumentasi = '/dokumentasi';

  // DETAIL
  static const String detailPelapor = '/laporan-pelapor';
  static const String detailUmum = '/laporan-umum';

  // EDIT
  static const String editLaporan = '/edit-laporan';
  static const String editDokumentasi = '/edit-dokumentasi';

  // PROFILE
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String accountSettings = '/account-settings';
  static const String reportUser = '/report-user';
}

const String adminEmail = "admin@lofo.app";

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final loc = state.uri.path;

      const adminEmail = "admin@lofo.app";

      final publicRoutes = {
        AppRoutes.splash,
        AppRoutes.welcome,
        AppRoutes.signIn,
        AppRoutes.signUp,
        AppRoutes.emailVerification,
      };

      if (user == null) {
        if (publicRoutes.contains(loc)) return null;
        return AppRoutes.signIn;
      }

      final isAdmin = user?.email == "admin@lofo.app";

      if (!isAdmin && user != null && !user.emailVerified && loc != AppRoutes.emailVerification) {
        return AppRoutes.emailVerification;
      }

      return null;
    },

    routes: [

      GoRoute(
        path: AppRoutes.admin,
        builder: (_, __) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminReports,
        builder: (_, __) => const AdminReportsScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminVerifications,
        builder: (_, __) => const AdminVerificationsScreen(),
      ),


      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: AppRoutes.welcome, builder: (_, __) => const WelcomeScreen()),

      GoRoute(path: AppRoutes.signIn, builder: (_, __) => const SignInScreen()),
      GoRoute(path: AppRoutes.signUp, builder: (_, __) => const SignUpScreen()),
      GoRoute(path: AppRoutes.emailVerification, builder: (_, __) => const EmailVerificationScreen()),
      GoRoute(path: AppRoutes.identitas, builder: (_, __) => const IdentitasScreen()),
      GoRoute(path: AppRoutes.kontak, builder: (_, __) => const KontakScreen()),
      GoRoute(path: AppRoutes.berhasil, builder: (_, __) => const BerhasilScreen()),

      GoRoute(
        path: AppRoutes.mainNav,
        builder: (_, state) {
          final q = state.uri.queryParameters;
          return MainNavigationScreen(
            startIndex: int.tryParse(q["startIndex"] ?? "0") ?? 0,
            kategori: q["kategori"],
            lokasi: q["lokasi"],
            urutan: q["urutan"],
          );
        },
      ),

      GoRoute(path: AppRoutes.filter, builder: (_, __) => const FilterScreen()),
      GoRoute(path: AppRoutes.addLaporan, builder: (_, __) => const AddLaporanScreen()),

      GoRoute(
        path: AppRoutes.detailPelapor,
        builder: (_, state) {
          final data = state.extra as Map<String, dynamic>;

          return LaporanPelaporScreen(
            laporanId: data["laporanId"],
            ownerId: data["ownerId"],
            images: List<String>.from(data["images"]),
            title: data["title"],
            reporterName: data["reporterName"],
            takerName: data["takerName"] ?? "-",
            dateFound: data["dateFound"],
            locationFound: data["locationFound"],
            category: data["category"],
            description: data["description"],
            status: data["status"],
            dokumentasi: List<String>.from(data["dokumentasi"] ?? []),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.detailUmum,
        builder: (_, state) {
          final data = state.extra as Map<String, dynamic>;

          return LaporanUmumScreen(
            laporanId: data["laporanId"],
            ownerId: data["ownerId"],
            images: List<String>.from(data["images"]),
            title: data["title"],
            reporterName: data["reporterName"],
            dateFound: data["dateFound"],
            locationFound: data["locationFound"],
            category: data["category"],
            description: data["description"],
            status: data["status"],
          );
        },
      ),

      GoRoute(
        path: AppRoutes.editLaporan,
        builder: (_, state) {
          final data = state.extra as Map<String, dynamic>?;

          return EditLaporanScreen(
            laporanId: data?["laporanId"] ?? "",
            images: List<String>.from(data?["images"] ?? []),
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

      GoRoute(
        path: AppRoutes.editDokumentasi,
        builder: (_, state) {
          final laporanId = state.extra as String;
          return EditDokumentasiScreen(
            laporanId: laporanId,
          );
        },
      ),

      GoRoute(
        path: AppRoutes.dokumentasi,
        builder: (_, state) {
          final laporanId = state.extra as String;
          return DokumentasiScreen(
            laporanId: laporanId,
          );
        },
      ),


      GoRoute(
        path: AppRoutes.profile,
        builder: (_, state) {
          final uid = state.extra as String?;
          return ProfileScreen(userId: uid);
        },
      ),

      GoRoute(path: AppRoutes.editProfile, builder: (_, __) => const EditProfileScreen()),
      GoRoute(path: AppRoutes.accountSettings, builder: (_, __) => const AccountSettingsScreen()),

      GoRoute(
        path: "/report-user",
        builder: (_, state) {
          final uid = state.extra as String;
          return ReportUserScreen(reportedUid: uid);
        },
      ),

      GoRoute(
        path: AppRoutes.adminReports,
        builder: (_, __) => const AdminReportsScreen(),
      ),

      GoRoute(path: AppRoutes.reportHistory, builder: (_, __) => const ReportHistoryScreen()),
    ],

    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(child: Text("404 — Page Not Found\n${state.uri}")),
      );
    },
  );
}
