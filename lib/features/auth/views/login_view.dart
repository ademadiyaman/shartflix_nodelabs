import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/services/api_service.dart';
import 'package:jr_case_boilerplate/core/widgets/buttons/custom_primary_button.dart';
import 'package:jr_case_boilerplate/features/auth/views/register_view.dart';
import 'package:jr_case_boilerplate/features/home/view/home_view.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
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
              height: 200,
            ),
          ),
          // İçerik
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: AppPaddings.left24, right: AppPaddings.right24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //  Film afişleri animasyonu
                  SizedBox(
                    width: 800.sp,
                    height: 140.sp,
                    child: Lottie.asset(
                      "assets/animations/login.json",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                    SizedBox(height: AppPaddings.h10),
                  // Logo
                  Image.asset(
                    "assets/images/logo.png",
                    height: 100.sp,
                  ),
                  SizedBox(height: AppPaddings.h10),
                  // Başlık
                  Text(
                    'girisyap',
                    style: AppTextStyles.girisyap,
                  ).tr(),
                  SizedBox(height: AppPaddings.h5),
                  Text(
                    'girisyap_bilgi',
                    style: AppTextStyles.girisyap_bilgi,
                  ).tr(),
                  SizedBox(height: AppPaddings.h24),
                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email
                        TextFormField(
                          controller: _emailCtrl,
                          style: const TextStyle(color: AppColors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'eposta'.tr(),
                            hintStyle: AppTextStyles.eposta,
                            filled: true,
                            fillColor: const Color(0xFF1C1C1C),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            // Prefix Icon
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 12),
                              child: Image.asset(
                                "assets/icons/Mail.png",
                                width: 20,
                                height: 20,
                                color: AppColors.white,
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                            // Borderlar
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18), // Radius 18px
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.2),
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
                          ),
                          validator: (val) =>
                          val != null && val.contains("@") ? null : 'gecersizeposta'.tr(),
                        ),

                        SizedBox(height: AppPaddings.h24),
                        // Şifre
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: _obscureText,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: "sifre".tr(),
                            hintStyle: AppTextStyles.sifre,
                            filled: true,
                            fillColor: const Color(0xFF1C1C1C), // Figma koyu arka plan tonu
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 16.sp, // top-bottom
                              horizontal: 20.sp, // left-right
                            ),

                            // Prefix Icon
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: AppPaddings.left20, right: AppPaddings.right12),
                              child: Image.asset(
                                "assets/icons/Lock.png",
                                width: 20.sp,
                                height: 20.sp,
                                color: AppColors.white70,
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),

                            // Suffix Icon (göster/gizle)
                            suffixIcon: IconButton(
                              icon: Image.asset(
                                _obscureText
                                    ? "assets/icons/Hide.png"
                                    : "assets/icons/See.png",
                                width: 20,
                                height: 20,
                                color: AppColors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),

                            //Borderlar
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.2),
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
                          ),
                          validator: (val) =>
                          val != null && val.length >= 6 ? null : '6karakter'.tr(),
                        ),

                          SizedBox(height: AppPaddings.h5),

                        // Şifreyi unut
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'sifremiunuttum'.tr(),
                              style: AppTextStyles.sifreunuttum,
                            ),
                          ),
                        ),
                          SizedBox(height: AppPaddings.h5),

                        // Giriş Yap Butonu
                        CustomPrimaryButton(
                          text: 'girisyap'.tr(),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final result = await ApiService().login(
                                  _emailCtrl.text.trim(),
                                  _passwordCtrl.text.trim(),
                                );

                                if (!mounted) return;

                                if (result == null) {
                                  throw Exception('yanitalnamadi'.tr());
                                }

                                if (result["token"] == null) {
                                  throw Exception('tokenalnamadi'.tr());
                                }

                                SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                                await prefs.setBool("isLoggedIn", true);
                                await prefs.setString("token", result["token"]);
                                await prefs.setString("userId", result["id"]);
                                await prefs.setString("userName", result["name"]);
                                await prefs.setString("email", result["email"]);
                                await prefs.setString("photoUrl", result["photoUrl"]);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                    Text('hosgeldin${result["name"]}').tr(),
                                  ),
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeView(),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Giriş başarısız: $e"),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                    SizedBox(height: AppPaddings.h20),

                  // Sosyal butonlar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton("assets/icons/Google.png", () {}),
                      const SizedBox(width: 20),
                      _socialButton("assets/icons/Apple.png", () {}),
                      const SizedBox(width: 20),
                      _socialButton("assets/icons/Facebook.png", () {}),
                    ],
                  ),
                    SizedBox(height: AppPaddings.h20),

                  // Kayıt Ol linki
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'hesabinyokmu',
                        style: AppTextStyles.hesabinyokmu,
                      ).tr(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterView(),
                            ),
                          );
                        },
                        child: Text(
                          'kayitol',
                          style: AppTextStyles.kayitol,
                        ).tr(),
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

  Widget _socialButton(String assetPath, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          border: Border.all(color: AppColors.white70, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Image.asset(
            assetPath,
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}
