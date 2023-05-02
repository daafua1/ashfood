import 'package:ashfood/utils/exports.dart';

// A file to store text styles used throughout the app
class TextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const TextStyle titleBlack = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const TextStyle button = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle buttonBlack = TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle bodyBlack = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

   static const TextStyle bodyRed = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Constants.appBarColor,
  );

  static const TextStyle bodysmallSubTitleB = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  static const TextStyle smallSubTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static const errorTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    color: Color(0xff9e9e9e),
  );
  static const activeTimeLine = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: Colors.grey,
  );
  static const activeTimeLineBody = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: Colors.grey,
  );
}
