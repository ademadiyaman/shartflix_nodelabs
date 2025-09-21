import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/constants/app_sizes.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';

class NavBarView extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBarView({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.12, // Navbar yüksekliği
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.95),
            Colors.black.withOpacity(0.9),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Anasayfa Butonu
          Positioned(
            left: AppPaddings.left16,
            bottom: AppPaddings.navBottom,
            child: _buildNavButton(
              label: 'navbar_anasayfa'.tr(),
              iconPath: currentIndex == 0
                  ? "assets/icons/home_active.png"
                  : "assets/icons/home_inactive.png",
              isActive: currentIndex == 0,
              onTap: () => onTap(0),
              screenWidth: screenWidth,
            ),
          ),

          // Profil Butonu
          Positioned(
            right: AppPaddings.right16,
            bottom: AppPaddings.navBottom,
            child: _buildNavButton(
              label: 'navbar_profil'.tr(),
              iconPath: currentIndex == 1
                  ? "assets/icons/profile_active.png"
                  : "assets/icons/profile_inactive.png",
              isActive: currentIndex == 1,
              onTap: () => onTap(1),
              screenWidth: screenWidth,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required String label,
    required String iconPath,
    required bool isActive,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.figmaWidth, // ekranın %40’ı
        height: AppSizes.figmaHeight, // sabit Figma yüksekliği
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(42),
          gradient: isActive
              ? const LinearGradient(
            colors: [Color(0xFFE50914), Color(0xFFB2040C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isActive ? null : Colors.transparent,
          border: Border.all(
            color: isActive ? Colors.transparent : Colors.white,
            width: 0.31,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, width: 22, height: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.profilveanasayfa,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
