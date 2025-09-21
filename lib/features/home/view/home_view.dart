import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/models/movie.dart';
import 'package:jr_case_boilerplate/core/services/api_service.dart';
import 'package:jr_case_boilerplate/features/auth/views/login_view.dart';
import 'package:jr_case_boilerplate/features/nav_bar/view/nav_bar_view.dart';
import 'package:jr_case_boilerplate/features/profile/view/profile_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const _HomeContent(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _pages[_currentIndex],
// 🔽 Bottom Navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: NavBarView(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
              },
            ),
          ),

        ],
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  late Future<List<Movie>> _moviesFuture;
  late Future<List<Movie>> _favoritesFuture;
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    _moviesFuture = _api.getMovies(1);
    _favoritesFuture = _api.getFavoriteMovies();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<void> _toggleFavorite(String movieId, bool isFav) async {
    final token = await _getToken();
    if (token == null) {
      print("Token yok!");
      return;
    }
    final result = await _api.toggleFavorite(movieId, token);
    if (result) {
      setState(() {
        _favoritesFuture = _api.getFavoriteMovies();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return FutureBuilder<List<Movie>>(
      future: _moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.red));
        }
        if (snapshot.hasError) {
          return Center(child: Text("Hata: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return   Center(child: Text(AppStrings.filmbulunamadi, style: AppTextStyles.filmbulunamadi));
        }

        final movies = snapshot.data!;

        return FutureBuilder<List<Movie>>(
          future: _favoritesFuture,
          builder: (context, favSnapshot) {
            final favorites = favSnapshot.data ?? [];

            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                bool isFavorite = favorites.any((f) => f.id == movie.id);

                return Stack(
                  children: [
                    // 🎬 Arka plan posteri
                    Positioned.fill(
                      child: Image.network(
                        movie.posterUrl ?? "https://via.placeholder.com/400x600",
                        fit: BoxFit.cover,
                      ),
                    ),
                    // ❤️ Favori Butonu
                    Positioned(
                      bottom: height * 0.25,
                      right: AppPaddings.favRight,
                      child: StatefulBuilder(
                        builder: (context, setStateFav) {
                          return GestureDetector(
                            onTap: () async {
                              await _toggleFavorite(movie.id ?? "", isFavorite);
                              setStateFav(() => isFavorite = !isFavorite);
                            },
                            child: Container(
                              width: 52,
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 1.0,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Image.asset(
                                isFavorite
                                    ? "assets/icons/like.png"
                                    : "assets/icons/unlike.png",
                                width: 24,
                                height: 24,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // 📌 Film Bilgileri
                    Positioned(
                      bottom: height * 0.13,
                      left: AppPaddings.left16,
                      right: AppPaddings.right16,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/logo1.png",
                            height: AppPaddings.logoSize,
                            width: AppPaddings.logoSize,
                          ),
                          SizedBox(width: AppPaddings.right16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title ?? "",
                                  style: AppTextStyles.anasayfatitle,
                                ),
                                const SizedBox(height: 2),

                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final description = movie.description ?? "";

                                    // TextPainter ile satır hesaplama
                                    final tp = TextPainter(
                                      text: TextSpan(
                                        text: description,
                                        style: AppTextStyles.anasayfadescription,
                                      ),
                                      maxLines: 2,
                                      textDirection: Directionality.of(context), // 👈 ÖNEMLİ
                                      /// HALA AYNI HATAYI VERİYO tr() easylocalization ekledikten sonra veriyor bu hatayı
                                    )..layout(maxWidth: constraints.maxWidth);

                                    // Eğer sığıyorsa direkt yaz
                                    if (tp.didExceedMaxLines == false) {
                                      return Text(description, style: AppTextStyles.anasayfadescription);
                                    }

                                    // Metni 2 satıra sığdırabilecek kadar kes
                                    int endIndex = tp.getPositionForOffset(
                                      Offset(180, tp.height),
                                    ).offset;

                                    String visibleText = description.substring(0, endIndex);
                                    if (visibleText.length < description.length) {
                                      visibleText = visibleText.trimRight();
                                    }

                                    return RichText(
                                      text: TextSpan(
                                        style: AppTextStyles.anasayfadescription,
                                        children: [
                                          TextSpan(text: visibleText + ""),
                                          TextSpan(
                                            text: 'devamini_oku'.tr(),
                                            style: AppTextStyles.devaminioku,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {

                                              },
                                          ),
                                        ],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
