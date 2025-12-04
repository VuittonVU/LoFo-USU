// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../widgets/lofo_scaffold.dart';
// import '../../widgets/lofo_text_field.dart';
// import '../../widgets/primary_button.dart';
// import '../../services/auth_service.dart';
// import '../../config/routes.dart';
//
// class OtpScreen extends StatefulWidget {
//   const OtpScreen({super.key});
//
//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<OtpScreen> {
//   final otpCtrl = TextEditingController();
//   bool loading = false;
//
//   late String uid;
//   late String email;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//
//     final params = GoRouterState.of(context).uri.queryParameters;
//
//     uid = params["uid"] ?? "";
//     email = params["email"] ?? "";
//   }
//
//   Future<void> _verifyOtp() async {
//     setState(() => loading = true);
//
//     final ok = await AuthService.instance.verifyOtp(
//       uid,
//       otpCtrl.text.trim(),
//     );
//
//     setState(() => loading = false);
//
//     if (!ok) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Kode OTP salah atau expired.")),
//       );
//       return;
//     }
//
//     context.go(AppRoutes.identitas);
//   }
//
//   Future<void> _resendOtp() async {
//     await AuthService.instance.sendOtpToEmail(email, uid);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Kode OTP baru dikirim.")),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LofoScaffold(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 60),
//
//           const Text(
//             "Halo, sobat USU!",
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.w800,
//               color: Color(0xFF2F9E44),
//             ),
//           ),
//           const SizedBox(height: 20),
//
//           Center(child: Image.asset("assets/logo.png", height: 150)),
//           const SizedBox(height: 20),
//
//           const Text(
//             "Periksa kode OTP di email anda!",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 10),
//
//           LofoTextField(
//             label: "",
//             hint: "Masukkan kode OTP",
//             icon: Icons.lock_clock,
//             controller: otpCtrl,
//           ),
//           const SizedBox(height: 10),
//
//           TextButton(
//             onPressed: _resendOtp,
//             child: const Text(
//               "Kirim ulang kode",
//               style: TextStyle(color: Colors.blue, fontSize: 14),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           PrimaryButton(
//             text: loading ? "Memverifikasi..." : "Kirim",
//             onPressed: loading ? null : _verifyOtp,
//           ),
//
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }
