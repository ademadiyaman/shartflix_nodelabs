import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/services/api_service.dart';
import 'package:jr_case_boilerplate/core/widgets/buttons/custom_primary_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  @override
  void initState() {
    super.initState();
    // Status bar şeffaf
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Gradient (arka plan)
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A0000), Color(0xFF000000)],
              ),
            ),
          ),
          // Shine effect
          Positioned(
            top: -11,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/shine_effect.png",
              fit: BoxFit.fitHeight,
              height: 200.sp,
            ),
          ),
          SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: AppPaddings.left24, right: AppPaddings.right24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  "assets/images/logo.png",
                  height: 80,
                ),
                  SizedBox(height: AppPaddings.h20),
                // Başlık
                  Text(
                  'hesapac',
                  style: AppTextStyles.hesapac,
                ).tr(),
                  SizedBox(height: AppPaddings.h5),
                  Text(
                  'kaydol',
                  style: AppTextStyles.kayit,
                ).tr(),
                  SizedBox(height: AppPaddings.h20),
                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Ad Soyad
                      TextFormField(
                        controller: _nameCtrl,
                        style: const TextStyle(color: AppColors.white),
                        decoration: _inputDecoration('adsoyad'.tr(), "assets/icons/profil.png"),
                        validator: (val) => val != null && val.isNotEmpty ? null : "Ad Soyad giriniz",
                      ),
                        SizedBox(height: AppPaddings.h15),
                      // E-posta
                      TextFormField(
                        controller: _emailCtrl,
                        style: const TextStyle(color: AppColors.white),
                        decoration: _inputDecoration("eposta".tr(), "assets/icons/Mail.png"),
                        validator: (val) => val != null && val.contains("@") ? null : 'gecersizeposta'.tr(),
                      ),
                        SizedBox(height: AppPaddings.h15),
                      // Şifre
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: AppColors.white),
                        decoration: _inputDecoration(
                          'sifre'.tr(),
                          "assets/icons/Lock.png",
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (val) =>
                        val != null && val.length >= 6 ? null : '6karakter',
                      ),
                        SizedBox(height: AppPaddings.h15),
                      TextFormField(
                        controller: _confirmPasswordCtrl,
                        obscureText: _obscureConfirmPassword,
                        style: const TextStyle(color: AppColors.white, fontSize: 14),
                        decoration: _inputDecoration(
                          'sifretekrar'.tr(),
                          "assets/icons/Lock.png",
                          suffix: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (val) => val == _passwordCtrl.text ? null : 'sifreuyusmuyor'.tr(),
                      ),
                        SizedBox(height: AppPaddings.h15),
                      // Kullanıcı sözleşmesi
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptedTerms,
                            onChanged: (val) {
                              setState(() {
                                _acceptedTerms = val ?? false;
                              });
                            },
                            checkColor: Colors.black,
                            activeColor: Colors.red,
                          ),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'kullanicisozlesmesini'.tr(),
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                                children: [
                                  TextSpan(
                                    text: 'kabulediyorum'.tr(),
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                        SizedBox(height: AppPaddings.h20),
                      // Kaydol Butonu
                      CustomPrimaryButton(
                        text: 'kayitol'.tr(),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final result = await ApiService().register(
                                  _nameCtrl.text,
                                  _emailCtrl.text,
                                  _passwordCtrl.text,
                                );
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      'kayitbasarili${result?["user"]["email"]}')
                                      .tr()),
                                );
                                Navigator.pop(
                                    context); // Geri Login sayfasına dön
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("kayitbasarisiz$e").tr()),
                                );
                              }
                            }
                          }
                      ),
                    ],
                  ),
                ),
                  SizedBox(height: AppPaddings.h20),
                // Sosyal Medya Butonları
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton("assets/icons/Google.png", () async {
                      final googleUser = await GoogleSignIn().signIn();
                      if (googleUser == null) return;

                      final googleAuth = await googleUser.authentication;
                      final credential = GoogleAuthProvider.credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken,
                      );

                      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

                       final idToken = await userCredential.user?.getIdToken();

                      if (idToken != null) {
                        final api = ApiService();
                        final result = await api.loginWithGoogle(idToken);

                        if (result != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Hoş geldin ${result["name"]}")),
                          );
                          Navigator.pushReplacementNamed(context, "/home");
                        }
                      }
                    }),
                      SizedBox(width: AppPaddings.h20),
                    _socialButton("assets/icons/Apple.png", () {}),
                      SizedBox(width: AppPaddings.h20),
                    _socialButton("assets/icons/Facebook.png", () {}),
                  ],
                ),
                  SizedBox(height: AppPaddings.h20),
                // Alt yazı
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text('hesabinvarmi', style: AppTextStyles.hesabinyokmu).tr(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('girisyap', style: AppTextStyles.kayit).tr(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
          ],
      ),
    );
  }
  // Google ile Giriş (Backend'de endpoint olmadığı için tamamlanmadı!)
  Future<UserCredential?> _signInWithGoogle() async {
    try {

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google ile giriş hatası: $e")),
      );
      return null;
    }
  }
// Ortak input
  InputDecoration _inputDecoration(String hint, String iconPath, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFF1C1C1C), // Figma’daki koyu arka plan tonunu alabilirsin
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16, // top-bottom 16px
        horizontal: 20, // left-right 20px
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 20, right: 12), // Figma spacing
        child: Image.asset(
          iconPath,
          width: 20,
          height: 20,
          color: Colors.white70,
        ),
      ),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 40,
      ),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18), // Radius = 18px
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.2), // Border = 1px
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
    );
  }
  // Sosyal medya butonu
  Widget _socialButton(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.white24),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Image.asset(assetPath, width: 24, height: 24),
        ),
      ),
    );
  }
}
