import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameCtrl = TextEditingController(text: "Udin Simanjuntak");
  final majorCtrl = TextEditingController(text: "Ilmu Komunikasi");
  final facultyCtrl = TextEditingController(text: "FISIP");
  final nimCtrl = TextEditingController(text: "231401063");

  final phoneCtrl = TextEditingController(text: "0895–6229–2408");
  final igCtrl = TextEditingController(text: "@sayaUdins");
  final waCtrl = TextEditingController(text: "0895–6229–2408");
  final emailCtrl = TextEditingController(text: "udinSimanjuntak940@usu.ac.id");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3E3),

      // ============================================================
      //                       TOP BAR ✔️
      // ============================================================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          height: 90,
          width: double.infinity,
          color: const Color(0xFF4CAF50),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // BACK BUTTON
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 26),
                ),

                // TITLE — ALWAYS CENTERED
                const Text(
                  "LoFo USU",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                // SAVE BUTTON
                GestureDetector(
                  onTap: () {
                    // TODO: Save profile ke Firebase
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Profil berhasil disimpan."),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                          bottom: 40,
                          left: 16,
                          right: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );

                    context.pop();
                  },
                  child: const Icon(Icons.check,
                      color: Colors.white, size: 28),
                ),
              ],
            ),
          ),
        ),
      ),

      // ============================================================
      //                    BODY & SCROLL VIEW ✔️
      // ============================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ============================================================
            //                      PROFILE PHOTO ✔️
            // ============================================================
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 5),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/avatar.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // ICON EDIT
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xff4CAF50),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.edit,
                          size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ============================================================
            //                 DATA MAHASISWA (Nama–NIM) ✔️
            // ============================================================
            _sectionForm(
              children: [
                _label("Nama"),
                _editField(nameCtrl),

                _label("Prodi"),
                _editField(majorCtrl),

                _label("Fakultas"),
                _editField(facultyCtrl),

                _label("NIM"),
                _editField(nimCtrl),
              ],
            ),

            const SizedBox(height: 25),

            // ============================================================
            //                       KONTAK ✔️
            // ============================================================
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Kontak:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade900,
                ),
              ),
            ),

            const SizedBox(height: 10),

            _contactItem(
              iconPath: "assets/icons/phone.png",
              label: "Nomor Telepon:",
              controller: phoneCtrl,
            ),

            _contactItem(
              iconPath: "assets/icons/instagram.png",
              label: "Instagram:",
              controller: igCtrl,
            ),

            _contactItem(
              iconPath: "assets/icons/whatsapp.png",
              label: "Whatsapp:",
              controller: waCtrl,
            ),

            _contactItem(
              iconPath: "assets/icons/mail.png",
              label: "email:",
              controller: emailCtrl,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ============================================================
  //            MINI FORM CONTAINERS & FIELD WIDGETS ✔️
  // ============================================================

  Widget _sectionForm({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xff4CAF50)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _editField(TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.edit, size: 18, color: Color(0xFF4CAF50)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4CAF50)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
        ),
      ),
    );
  }

  Widget _contactItem({
    required String iconPath,
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF4CAF50)),
      ),
      child: Row(
        children: [
          Image.asset(iconPath, width: 28),
          const SizedBox(width: 10),

          // LABEL
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // TEXTFIELD
          Expanded(
            flex: 2,
            child: TextField(
              controller: controller,
              maxLines: 1,
              decoration: InputDecoration(
                suffixIcon:
                const Icon(Icons.edit, size: 18, color: Color(0xFF4CAF50)),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: Color(0xFF4CAF50), width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
