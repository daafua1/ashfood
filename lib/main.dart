import 'dart:convert';

import 'package:ashfood/models/app_user.dart';
import 'package:ashfood/screens/get_started.dart';
import 'package:ashfood/screens/riders/rider_homepage.dart';
import 'package:ashfood/screens/vendors/vendor_homepage.dart';
import 'package:ashfood/utils/exports.dart';
import 'package:ashfood/utils/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'screens/students/customer_homepage.dart';

SharedPreferences? prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();
  final userString = prefs!.getString('user');
  if (userString != null) {
    user.value = AppUser.fromJson(jsonDecode(userString));
    Services.getUser(user.value.id!);
  }
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const Welcome());
}

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final bool? isFirstTime = prefs!.getBool('isFirstTime');
    final isLogin = FirebaseAuth.instance.currentUser == null;
    return GlobalLoaderOverlay(
      switchInCurve: Curves.fastOutSlowIn,
      useDefaultLoading: false,
      overlayWidget: Center(
        child: LoadingAnimationWidget.inkDrop(
          color: Constants.appBarColor,
          size: 100.0,
        ),
      ),
      overlayColor: Colors.white,
      overlayOpacity: 0.90,
      duration: const Duration(seconds: 2),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        home: isFirstTime == false ? const GetStarted() : appRoot(),
      ),
    );
  }
}

Widget appRoot() {
  if (user.value.userType == null) {
    return const GetStarted();
  } else {
    if (user.value.userType == UserType.customer.name) {
      return const CustomerHomePage();
    } else if (user.value.userType == UserType.vendor.name) {
      return const VendorHomepage();
    } else if(user.value.userType == UserType.rider.name) {
      return const RiderHomepage();
    }else{
      return Container();
    }
  }
}
