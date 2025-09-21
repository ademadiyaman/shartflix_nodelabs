import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPaddings {
  const AppPaddings._();

  // Sayfa genel dolgusu
  static EdgeInsets page = EdgeInsets.symmetric(
    horizontal: 26.w,
    vertical: 15.h,
  );


  // Genel amaçlı padding değerleri
  static EdgeInsets none = EdgeInsets.zero;
  static EdgeInsets p6   = EdgeInsets.all(6.w);
  static EdgeInsets p10  = EdgeInsets.all(10.w);
  static EdgeInsets p12  = EdgeInsets.all(12.w);
  static EdgeInsets p16  = EdgeInsets.all(16.w);
  static EdgeInsets hv16 = EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h);

  static double h1 = 1.h;
  static double h5 = 5.h;
  static double h20 = 20.h;
  static double h10 = 10.h;
  static double h14 = 14.h;
  static double h15 = 15.h;
  static double h24 = 24.h;
  static double w1 = 81;
  static double jetonWidth = 110.w;
  static double jetonHeight = 186.h;
  static double uploadPhotoHeight = 172.h;
  static double uploadButtonWidth = 354.w;
  static double uploadButtonHeight = 56.h;


  static double top0 = 0.h;
  static double bottom8 = 8.h;
  static double bottom11 = 11.w;
  static double right12 = 12.w;
  static double right16 = 16.w;
  static double right24 = 24.w;
  static double top11 = 11.w;
  static double left16 = 16.w;
  static double left24 = 24.w;
  static double left20 = 20.w;
  static double top60 = 60.h;
  static double navBottom = 36.h;

  // Favori Butonu
  static double favWidth    = 52.w;
  static double favHeight   = 72.h;
  static double favRadius   = 20.r;
  static double favBorderW  = 1.w;
  static double favIconSize = 24.sp;
  static double favRight    = 14.w;
  static double favBottom   = 12.w;

  static Color favBorderColor = Colors.white.withOpacity(0.4);
  static Color favBgColor     = Colors.black.withOpacity(0.4);

  // HomeView özel layout değerleri
  static double infoBottom   = 0.14.sp; // height * 0.14
  static double infoSide     = 0.04.sp; // width * 0.04

  static double logoSize     = 40.w; // 40x40 px orantılı
  static double rowGapW      = 0.01.sp;

  static double favBottomH   = 0.31.sp;
  static double favRightW    = 0.08.sp;
}

class AppGaps {
  const AppGaps._();

  static Widget h6  = SizedBox(height: 6.h);
  static Widget h10 = SizedBox(height: 10.h);
  static Widget h12 = SizedBox(height: 12.h);
  static Widget h14 = SizedBox(height: 14.h);

  static Widget vh(BuildContext context, double factor) =>
      SizedBox(height: MediaQuery.of(context).size.height * factor);

  static Widget vw(BuildContext context, double factor) =>
      SizedBox(width: MediaQuery.of(context).size.width * factor);
}
