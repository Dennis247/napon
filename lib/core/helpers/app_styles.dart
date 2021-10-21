import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:napon/core/helpers/app_colors.dart';
import 'package:sizer/sizer.dart';

class AppStyles {
  static final appDarkHeaderTextStyle = GoogleFonts.poppins(
      fontSize: 3.8.h,
      color: AppColors.primaryColorBlack,
      fontWeight: FontWeight.w600);

  static final normalBlackTextStyle = GoogleFonts.poppins(
      fontSize: 3.5.w, color: Color(0xff262626), fontWeight: FontWeight.w400);

  static final appMediumBoldTextStyle = GoogleFonts.poppins(
      fontSize: 2.5.h,
      color: AppColors.primaryColorBlack,
      fontWeight: FontWeight.bold);

  static final labelTextStyle = GoogleFonts.poppins(
    fontSize: 12,
    color: AppColors.primaryColor,
  );
  static final appInputTextStyle = GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.primaryColorBlack,
  );

  static final greyTextStyle = GoogleFonts.poppins(
      fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w400);

  static final appLightTextStyle = GoogleFonts.poppins(
      fontSize: 2.2.h, color: Colors.white, fontWeight: FontWeight.bold);

  static final appTextStyle = GoogleFonts.poppins(
    fontSize: 2.2.h,
    color: AppColors.primaryColorBlack,
  );

  static final appPurpleTextStyle = GoogleFonts.poppins(
      fontSize: 2.2.h, color: Colors.green[900], fontWeight: FontWeight.w500);

  static final appBoldWhiteTextStyle = GoogleFonts.poppins(
      fontSize: 2.5.h, color: Colors.white, fontWeight: FontWeight.bold);

  static final appBoldGreenTextStyle = GoogleFonts.poppins(
      fontSize: 2.5.h, color: Colors.green, fontWeight: FontWeight.bold);

  static final appHintTextStyle = GoogleFonts.poppins(
    fontSize: 1.8.h,
    color: AppColors.colorDimText,
  );

  static final appMediumTextStyle = GoogleFonts.poppins(
    fontSize: 1.8.h,
    color: AppColors.primaryColorBlack,
  );

  static final appBoldTextStyle = GoogleFonts.poppins(
      fontSize: 2.2.h,
      color: AppColors.primaryColorBlack,
      fontWeight: FontWeight.w700);

  static final appBigPrimaryBoldTextStyle = GoogleFonts.poppins(
      fontSize: 3.2.h, color: Colors.green, fontWeight: FontWeight.w700);

  static final appBigPrimaryBlackBoldTextStyle = GoogleFonts.poppins(
      fontSize: 3.5.h, color: Colors.black, fontWeight: FontWeight.w700);

  static final smallAppTextStyle = GoogleFonts.poppins(
      fontSize: 1.5.h,
      color: AppColors.primaryColorBlack,
      fontWeight: FontWeight.w400);

  static final smallGreyTextStyle = GoogleFonts.poppins(
      fontSize: 1.5.h, color: AppColors.grey, fontWeight: FontWeight.w400);

  static final cardBoldDarkTextStyle2 = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w700,
    ),
  );

  static final cardBoldDarkTextStyleGreen = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: AppColors.primaryColor,
      fontSize: 12,
      fontWeight: FontWeight.w700,
    ),
  );

  static final cardNormalTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  );

  static final cardNormalDarkTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  );

  static final cardBoldTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
  );

  static final cardBoldDarkTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
  );

  static final cardMediumBoldDarkTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 2.8.h,
      fontWeight: FontWeight.w700,
    ),
  );
}
