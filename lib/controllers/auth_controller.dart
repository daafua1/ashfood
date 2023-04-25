import 'dart:convert';
import 'dart:io';

import 'package:ashfood/main.dart';
import 'package:ashfood/screens/riders/rider_homepage.dart';
import 'package:ashfood/screens/students/customer_homepage.dart';
import 'package:ashfood/utils/exports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/app_user.dart';
import '../screens/vendors/vendor_homepage.dart';
import '../utils/services.dart';

class AuthController extends GetxController {
  // The controllers for the student id text fields
  var password = TextEditingController().obs;

  // The controllers for the email text fields
  var email = TextEditingController().obs;

  // The controllers for the name text fields
  var name = TextEditingController().obs;

  // The controllers for the location text fields
  var location = TextEditingController().obs;

  // The controllers for the phoneNumber text fields
  var phone = TextEditingController().obs;
  // The longitude coordinate of the user's location
  var long = 0.0.obs;

  // The latitude coordinate of the user's location
  var lat = 0.0.obs;
  // Whether the user inputs are valid
  var validationError = false.obs;

  // Whether the loader is busy
  var isLoading = false.obs;
// The user's profile image
  var profileImage = ''.obs;

  var userType = UserType.customer.obs;

  // Validates the user inputs and logs the user in
  void validateForms() async {
    // Check if the user inputs are valid
    if (vendorVallidation() &&
        riderValidation() &&
        email.value.text.isEmail &&
        password.value.text.isNotEmpty &&
        name.value.text.isNotEmpty &&
        phone.value.text.isNotEmpty &&
        phone.value.text.length > 9 &&
        password.value.text.length > 5) {
      validationError.value = false;
      isLoading.value = true;

      try {
         String? imageURL;
        // Sign in the user
         if (profileImage.value.isNotEmpty) {
           imageURL =  await Services().uploadFile(File(profileImage.value));
          }
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.value.text, password: password.value.text)
            .then((value) async {
         
          // Create a new user in the database
          createUser(value.user!.uid, imageURL);
          prefs!.setString('userString', jsonEncode(user.value.toJson()));
          FirebaseFirestore.instance
              .collection('users')
              .doc(value.user!.uid)
              .set(user.value.toJson())
              .then((value) {});
        });

        isLoading.value = false;
        // Navigate to the feed page
       redirectUser();
      } catch (e) {
        isLoading.value = false;
        print(e.toString());
        // Show an error message if the user is not found
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.white,
          textColor: Colors.black,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 14,
        );
      }
    } else {
      validationError.value = true;
    }
  }

  bool vendorVallidation() {
    if (userType.value != UserType.vendor) {
      return true;
    } else {
      if (location.value.text.isNotEmpty &&
          profileImage.value.isNotEmpty &&
          lat.value != 0.0 &&
          long.value != 0.0) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool riderValidation() {
    if (userType.value != UserType.rider) {
      return true;
    } else {
      if (profileImage.value.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }
  }

  void createUser(String id, String? imageURL) {
    user.value = AppUser(
      email: email.value.text,
      id: id,
      name: name.value.text,
      location: location.value.text,
      phoneNumber: phone.value.text,
      profileImage: imageURL,
      userType: userType.value.name,
      lat: lat.value,
      long: long.value,
    );
  }

  void redirectUser() {
    if (user.value.userType == UserType.customer.name) {
      Get.offAll(() => const CustomerHomePage());
    } else if (user.value.userType == UserType.vendor.name) {
      Get.offAll(() => const VendorHomepage());
    } else if (user.value.userType == UserType.rider.name) {
      Get.offAll(() => const RiderHomepage());
    }
  }
}
