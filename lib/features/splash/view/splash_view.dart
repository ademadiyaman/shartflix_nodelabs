import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/features/auth/views/login_view.dart';
import 'package:jr_case_boilerplate/features/home/view/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    // Status bar siyah/beyaz ikon uyumu
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // açılıs sonrası yönlendirme
    Future.delayed(const Duration(seconds: 2), () async {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => isLoggedIn ? const HomeView() : const LoginView(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Arka plan gradient
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
              height: 200,
            ),
          ),

          // Logo ve yazı
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  "assets/images/logo.png",
                  width: 84,
                  height: 84,
                ),
                SizedBox(height: AppPaddings.h16),
                // Uygulama adı
                Text(
                  AppStrings.shartflix,
                  style: AppTextStyles.shartflix,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
