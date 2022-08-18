import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';

class AppTextStyles{
  // ------------- ESCAPE BIGGER CARD
  // Escape Name
  static const TextStyle escapeBiggerCardEscapeName = TextStyle(
    color: AppColors.yellowPrimary,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: "Montserrat_Bold"
  );
  // Company Name
  static const TextStyle escapeBiggerCardCompanyName = TextStyle(
      color: AppColors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: "Montserrat_Semibold"
  );
  // Topic Text
  static const TextStyle escapeCardTopic = TextStyle(
      color: AppColors.yellowPrimary,
      fontSize: 10,
      fontWeight: FontWeight.normal,
      fontFamily: "Montserrat_Regular"
  );
  // Description
  static const TextStyle escapeBiggerCardDescription = TextStyle(
      color: AppColors.white,
      fontSize: 13,
      fontWeight: FontWeight.normal,
      fontFamily: "Montserrat_Regular",
      height: 1.6
  );
  static const int escapeBiggerCardDescriptionMaxLines = 4;
  // Information
  static const TextStyle escapeCardInformationLeft = TextStyle(
      color: AppColors.white50,
      fontSize: 10,
      fontWeight: FontWeight.normal,
      fontFamily: "Montserrat_Regular"
  );


  // ----------- HOME PAGE
  static const TextStyle homeSectionTitle = TextStyle(
      color: AppColors.white,
      fontSize: 32,
      fontFamily: "Montserrat_Semibold"
  );


  // ------------- ESCAPE NORMAL CARD
  // Escape Name
  static const TextStyle escapeNormalCardEscapeName = TextStyle(
      color: AppColors.yellowPrimary,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: "Montserrat_Bold"
  );
  // Description
  static const TextStyle escapeNormalCardDescription = TextStyle(
      color: AppColors.white,
      fontSize: 10,
      fontWeight: FontWeight.normal,
      fontFamily: "Montserrat_Regular",
      height: 1.6
  );
  static const int escapeNormalCardDescriptionMaxLines = 3;


  // ------------- ESCAPE DETAIL PAGE
  // Escape Name
  static const TextStyle escapeDetailEscapeName = TextStyle(
      color: AppColors.yellowPrimary,
      fontSize: 32,
      fontFamily: "Montserrat_Semibold"
  );
  // Escape Name
  static const TextStyle escapeDetailCompanyName = TextStyle(
      color: AppColors.greyText,
      fontSize: 22,
      fontFamily: "Montserrat_Semibold"
  );
  // Topic Text
  static const TextStyle escapeDetailTopic = TextStyle(
      color: AppColors.yellowPrimary,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      fontFamily: "Montserrat_Regular"
  );
  // Ratings Text
  static const TextStyle escapeDetailRatingAndCity = TextStyle(
      color: AppColors.white,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontFamily: "Montserrat_Regular"
  );
  // Company Brand Name
  static const TextStyle escapeDetailCompanyBrandName = TextStyle(
      color: AppColors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: "Montserrat_Bold"
  );
  // Mini Title
  static const TextStyle escapeDetailMiniTitle = TextStyle(
      color: AppColors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: "Montserrat_Bold"
  );
  // Normal Text
  static const TextStyle escapeDetailNormalText = TextStyle(
      color: AppColors.white,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontFamily: "Montserrat_Regular",
      height: 1.6
  );
  // Ficha tecnica
  static const TextStyle escapeDetailFichaTecnica = TextStyle(
      color: AppColors.greyText,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontFamily: "Montserrat_Regular",
      height: 1.6
  );


  // FILTERS DIALOG
  static const TextStyle filtersDialogTitle = TextStyle(
      color: AppColors.yellowPrimary,
      fontSize: 24,
      fontFamily: "Montserrat_Semibold",
  );
  static const TextStyle filtersDialogSectionNameTitle = TextStyle(
    color: AppColors.yellowPrimary,
    fontSize: 18,
    fontFamily: "Montserrat_Regular",
  );
  static const TextStyle filtersDialogTextInputTitle = TextStyle(
    color: AppColors.greyText,
    fontSize: 16,
    fontFamily: "Montserrat_Regular"
  );


  // BOOKING
  static const TextStyle bookingTimesRowTitle = TextStyle(
      color: AppColors.whiteText,
      fontSize: 15,
      fontWeight: FontWeight.bold,
      fontFamily: "Montserrat_Bold"
  );
  static const TextStyle bookingTimesRowEmpty = TextStyle(
      color: AppColors.yellowPrimary,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontFamily: "Montserrat_Regular"
  );

  static const TextStyle bookingTicket = TextStyle(
      color: AppColors.whiteText,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontFamily: "Montserrat_Regular"
  );
  static const TextStyle bookingTicketsTitle = TextStyle(
      color: AppColors.whiteText,
      fontSize: 15,
      fontWeight: FontWeight.bold,
      fontFamily: "Montserrat_Bold"
  );

  // FORM
  static const TextStyle bookingFormTextInput_Title = TextStyle(
      color: AppColors.yellowPrimary,
      fontSize: 15,
      fontWeight: FontWeight.bold,
      fontFamily: "Montserrat_Bold"
  );
  static const TextStyle bookingFormTextInput_Label = TextStyle(
      color: AppColors.whiteText,
      fontSize: 15,
      fontWeight: FontWeight.normal,
      fontFamily: "Montserrat_Regular"
  );
  static const TextStyle bookingFormTextInput_Hint = TextStyle(
      color: AppColors.greyDarkText,
      fontSize: 15,
      fontWeight: FontWeight.normal,
      fontFamily: "Montserrat_Regular"
  );
  static const TextStyle bookingFormOptionErrorMsg = TextStyle(
      color: AppColors.primaryRed,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      fontFamily: "Montserrat_Regular"
  );


}