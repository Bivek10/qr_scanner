import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_maker/utils/theme/colors.dart';

class AppTheme {
  static TextStyle bodyText1 = TextStyle(
    fontSize: 18.sp,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.blackColor,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: "exo2",
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.light,
      textTheme: TextTheme(
        bodyLarge: bodyText1,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.backgroundColor2,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: AppColors.blueLight,
        ),
        iconTheme: IconThemeData(
          color: AppColors.blackColor,
        ),
        titleTextStyle: TextStyle(
          color: AppColors.blackColor,
        ),
      ),
      scaffoldBackgroundColor: AppColors.backgroundColor2,
    );
  }
}
