import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/provider/photo_provider.dart';
import 'package:jr_case_boilerplate/core/services/api_service.dart';
import 'package:jr_case_boilerplate/core/models/movie.dart';
import 'package:jr_case_boilerplate/core/widgets/buttons/exit_language_custom_button.dart';
import 'package:jr_case_boilerplate/features/auth/views/login_view.dart';
import 'package:jr_case_boilerplate/features/profile/widgets/profile_bottom_sheet.dart';
import 'package:jr_case_boilerplate/features/upload_photo/view/upload_photo_view.dart';
import 'package:jr_case_boilerplate/features/nav_bar/view/nav_bar_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<List<Movie>> _moviesFuture;
  String? _photoUrl;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadProfilePhoto();
    _moviesFuture = ApiService().getFavoriteMovies();
  }

  Future<void> _loadProfilePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _photoUrl = prefs.getString("photoUrl");
    });
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = context.watch<PhotoProvider>().photoUrl;
    final size = MediaQuery.of(context).size;
    final height = size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3F0306),
                  Color(0xFF090909),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Profil üst bar
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppPaddings.left24,
                      right: AppPaddings.right24,
                      top: AppPaddings.top60,
                      bottom: AppPaddings.bottom8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'profil',
                          style: AppTextStyles.profile,
                        ).tr(),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (context) => const ProfileBottomSheet(),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFE50914),
                                  Color(0xFFB2040C),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(53),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/icons/vector.png",
                                  height: 15.83,
                                  width: 14.3,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'sinirliteklif',
                                  style: AppTextStyles.sinirliteklif,
                                ).tr(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Çizgi + Profil Row
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white24, width: 1),
                      ),
                    ),
                    padding: EdgeInsets.only(
                      left: AppPaddings.left24,
                      right: AppPaddings.right24,
                      top: AppPaddings.top11,
                      bottom: AppPaddings.bottom11,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.height * 0.035,
                          backgroundImage: photoUrl != null
                              ? NetworkImage(photoUrl)
                              : const AssetImage("assets/images/ayca.png") as ImageProvider,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppStrings.isimsoyisim, style: AppTextStyles.title),
                              Text(AppStrings.id, style: AppTextStyles.id),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const UploadPhotoView()),
                            );
                          },
                          child: Builder(
                            builder: (context) {
                              final screenWidth = MediaQuery.of(context).size.width;
                              final buttonWidth = screenWidth * 0.34;
                              final buttonHeight = screenWidth * 0.12;
                              final borderRadius = screenWidth * 0.03;

                              return Container(
                                width: buttonWidth,
                                height: buttonHeight,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3A1D1D),
                                  borderRadius: BorderRadius.circular(borderRadius),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'fotografyukle',
                                  style: AppTextStyles.fotografyukle,
                                ).tr(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Beğendiklerim Başlığı
                  Padding(
                    padding: EdgeInsets.only(left: AppPaddings.left24, right: AppPaddings.right24, top: AppPaddings.top11),
                    child: Text(
                      'begendiklerim',
                      style: AppTextStyles.begendiklerim,
                    ).tr(),
                  ),
                  // Beğendiklerim Grid
                  Padding(
                    padding: EdgeInsets.only(left: AppPaddings.left24, right: AppPaddings.right24),
                    child: FutureBuilder<List<Movie>>(
                      future: _moviesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.red),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "Hata: ${snapshot.error}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        final movies = snapshot.data ?? [];

                        if (movies.isEmpty) {
                          return GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 169 / 251,
                            children: [
                              _movieCard("assets/images/love_again.png"),
                              _movieCard("assets/images/past_lives.png"),
                              _movieCard("assets/images/anyone.png"),
                              _movieCard("assets/images/culpa.png"),
                            ],
                          );
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: movies.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 169 / 251,
                          ),
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      movie.posterUrl,
                                      width: 169,
                                      height: 196,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset("assets/images/placeholder.png", fit: BoxFit.cover);
                                      },
                                    ),
                                  ),
                                ),
                                Text(
                                  movie.title,
                                  style: AppTextStyles.favoritestitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Row(
                      children: [
                        ExitLanguageCustomButton(
                          icon: Icons.language,
                          label: "dildegistir".tr(),
                          onTap: () => _changeLanguage(context),
                          backgroundColor: Colors.blue, // farklı renk olsun
                        ),
                        ExitLanguageCustomButton(
                          icon: Icons.logout,
                          label: "cikisyap".tr(),
                          onTap: () => _logout(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.1),
                ],
              ),
            ),
          ),
          // NavBarView
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: NavBarView(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index != _currentIndex) {
                  if (index == 0) {
                    Navigator.pushReplacementNamed(context, "/home");
                  }
                  setState(() => _currentIndex = index);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _changeLanguage(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final currentLocale = context.locale;

    if (currentLocale.languageCode == "tr") {
      // İngilizceye geçiş
      await context.setLocale(const Locale("en", "US"));
      await prefs.setString("lang", "en_US");
    } else {
      // Türkçeye geçiş
      await context.setLocale(const Locale("tr", "TR"));
      await prefs.setString("lang", "tr_TR");
    }
  }

  // Kullanıcı çıkış methodu
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
          (route) => false,
    );
  }

  // Fallback Asset Kartı
  Widget _movieCard(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(image, fit: BoxFit.cover),
    );
  }
}
