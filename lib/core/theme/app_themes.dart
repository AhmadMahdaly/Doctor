import 'package:doctor_app/core/constants.dart';
import 'package:doctor_app/core/responsive/responsive_config.dart';
import 'package:doctor_app/core/theme/app_colors.dart';
import 'package:doctor_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';


class Appthemes {
  static ThemeData lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
      useMaterial3: true,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundLightColor,
      fontFamily: kPrimaryFont,

      textTheme: TextTheme(
        titleLarge: AppTextStyles.style18W800,
        titleMedium: AppTextStyles.style16W500,
      ),
      appBarTheme: AppBarTheme(
        iconTheme:  IconThemeData(
          color: AppColors.scaffoldBackgroundLightColor,
        ),
        toolbarHeight: 100.h,
        titleTextStyle: AppTextStyles.style18Bold.copyWith(
          color: AppColors.scaffoldBackgroundLightColor,
        ),
        backgroundColor: AppColors.primaryColor,
        surfaceTintColor: AppColors.scaffoldBackgroundLightColor,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,

      /// Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.scaffoldBackgroundLightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 5,
        titleTextStyle: AppTextStyles.style20Bold,
      ),

      /// ستايل الزر الرئيسي (ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor:
              AppColors.scaffoldBackgroundLightColor, // لون النص والأيقونة
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          textStyle: AppTextStyles.style12W500,
        ),
      ),

      /// ستايل الزر الثانوي (TextButton)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: AppTextStyles.style14W500,
        ),
      ),
    );
  }
}
