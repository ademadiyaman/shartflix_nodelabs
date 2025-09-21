import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/widgets/buttons/custom_primary_button.dart';
import 'package:jr_case_boilerplate/features/profile/widgets/token_card_widget.dart';

class ProfileBottomSheet extends StatelessWidget {
  const ProfileBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.9;
    final cardHeight = size.height * 0.20;
    final iconSize = cardHeight * 0.35;
    final fontSize = size.width * 0.030;

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A0000),
          borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
              child: Image.asset(
                "assets/images/shine_effect.png",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 260,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 11),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(width: 30),
                      Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'sinirliteklif',
                        style: AppTextStyles.teklifbaslik,
                      ).tr(),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                  Text(
                  'jetonpaketi',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.jetonpaketi,
                ).tr(),
                const SizedBox(height: 18),

                // 🔥 Bonuslar
                Container(
                  width: cardWidth,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A0000).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Text(
                        'bonuslar',
                        style: AppTextStyles.bonuslar,
                      ).tr(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _bonusCircle("assets/icons/bonus1.png", 'premium'.tr(), iconSize, fontSize),
                          _bonusCircle("assets/icons/bonus2.png", 'fazlaeslesme'.tr(), iconSize, fontSize),
                          _bonusCircle("assets/icons/bonus3.png", 'onecikar'.tr(), iconSize, fontSize),
                          _bonusCircle("assets/icons/bonus4.png", 'fazlabegeni'.tr(), iconSize, fontSize),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                 Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'kilitacmak',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ).tr(),
                ),
                const SizedBox(height: 20),

                // 🔥 Jeton paketleri
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _packageCard1(context),
                    _packageCard2(context),
                    _packageCard3(context),
                  ],
                ),
                const SizedBox(height: 20),
                // 🔥 Tüm jetonları gör butonu ------------------------------------------------------
                CustomPrimaryButton(
                  text: 'tumjetonlar'.tr(),
                  onPressed: () {
                    // TODO: Tüm jetonlar sayfasına yönlendirme
                  },
                ),

                // 🔥 Tüm jetonları gör butonu ------------------------------------------------------
                const SizedBox(height: 11),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Bonus Circle
  static Widget _bonusCircle(String assetPath, String label, double iconSize, double fontSize) {
    return Column(
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Center(
            child: Image.asset(assetPath, height: iconSize * 0.85, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, textAlign: TextAlign.center, style: AppTextStyles.bonuslar2),
      ],
    );
  }

// 🔹 Kart 1 ---------------------------------------------------------------------
    Widget _packageCard1(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardHeight = size.height * 0.25;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: AppPaddings.jetonWidth,   // 110.w
          height: AppPaddings.jetonHeight, // 186.h
           decoration: BoxDecoration(
            gradient: const RadialGradient(
              center: Alignment.topCenter,
              radius: 1.2,
              colors: [Color(0xFF6F060B), Color(0xFFE50914)],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 0.2.w),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('oldcoin1', style: AppTextStyles.oldcoin2, maxLines: 1, overflow: TextOverflow.ellipsis).tr(),
              Text('coin1', style: AppTextStyles.coin, maxLines: 1, overflow: TextOverflow.ellipsis).tr(),
              Text('jeton', style: AppTextStyles.jeton, maxLines: 1, overflow: TextOverflow.ellipsis).tr(),
              SizedBox(height: AppPaddings.h10),
              Container(width: 161.w, height: 1.h, color: Colors.white24),
              SizedBox(height: AppPaddings.h14),
              Text('priceleft', style: AppTextStyles.pricemid, maxLines: 1, overflow: TextOverflow.ellipsis).tr(),
              Text('haftalik', style: AppTextStyles.haftalik).tr(),
            ],
          ),
        ),
        Positioned(
          top: -cardHeight * 0.06,
          left: 0,
          right: 0,
          child: Center(
            child: DiscountBadge(text: AppStrings.discount1),
          ),
        ),
      ],
    );
  }

// 🔹 Kart 2
    Widget _packageCard2(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardHeight = size.height * 0.25;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: AppPaddings.jetonWidth,   // 110.w
          height: AppPaddings.jetonHeight, // 186.h
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              center: Alignment.topLeft,
              radius: 2.2,
              colors: [Color(0xFF5949E6), Color(0xFFE50914)],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 0.2.w),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('oldcoin2', style: AppTextStyles.oldcoin2, maxLines: 1, overflow: TextOverflow.ellipsis).tr(),
              Text('coin2', style: AppTextStyles.coin, maxLines: 1, overflow: TextOverflow.ellipsis).tr(),
              Text('jeton', style: AppTextStyles.jeton, maxLines: 1, overflow: TextOverflow.ellipsis).tr(),
              SizedBox(height: AppPaddings.h10),
              Container(width: 81.w, height: 1.h, color: Colors.white24),
              SizedBox(height: AppPaddings.h14),
              Text('pricemid', style: AppTextStyles.pricemid, maxLines: 1, overflow: TextOverflow.ellipsis).tr(),
              Text('haftalik', style: AppTextStyles.haftalik).tr(),
            ],
          ),
        ),
        Positioned(
          top: -cardHeight * 0.06,
          left: 0,
          right: 0,
          child: Center(
            child: DiscountBadgeSecondary(text: AppStrings.discount2),
          ),
        ),
      ],
    );
  }


// 🔹 Kart 3
    Widget _packageCard3(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardHeight = size.height * 0.25;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: AppPaddings.jetonWidth,   // 110.w
          height: AppPaddings.jetonHeight, // 186.h
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              center: Alignment.topCenter,
              radius: 1.2,
              colors: [Color(0xFF6F060B), Color(0xFFE50914)],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 0.2.w),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('oldcoin3', style: AppTextStyles.oldcoin2, maxLines: 1, overflow: TextOverflow.ellipsis).tr(),
              Text('coin3', style: AppTextStyles.coin, maxLines: 1, overflow: TextOverflow.ellipsis).tr(),
              Text('jeton', style: AppTextStyles.jeton, maxLines: 1, overflow: TextOverflow.ellipsis).tr(),
              SizedBox(height: AppPaddings.h10),
              Container(width: 81.w, height: 1.h, color: Colors.white24),
              SizedBox(height: AppPaddings.h14),
              Text('priceright', style: AppTextStyles.pricemid, maxLines: 1, overflow: TextOverflow.ellipsis).tr(),
              Text('haftalik', style: AppTextStyles.haftalik).tr(),
            ],
          ),
        ),
        Positioned(
          top: -cardHeight * 0.06,
          left: 0,
          right: 0,
          child: Center(
            child: DiscountBadge(text: AppStrings.discount3),
          ),
        ),
      ],
    );
  }
 }
