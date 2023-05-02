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
import 'package:onesignal_flutter/onesignal_flutter.dart';

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
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("314f3140-56e6-4302-82a9-3f76febe6618");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const Welcome());
}

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }

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
    } else if (user.value.userType == UserType.rider.name) {
      return const RiderHomepage();
    } else {
      return Container();
    }
  }
}
