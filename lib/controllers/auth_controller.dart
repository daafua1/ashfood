import '../utils/exports.dart';

class AuthController extends GetxController {
  // The controllers for the passord text fields
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

// The user's type
  var userType = UserType.customer.obs;

  // Validates the user inputs and logs the user in
  void validateForms() async {
    // Check if the user inputs are valid
    if (vendorVallidation() &&
        riderValidation() &&
        customerValidation() &&
        password.value.text.isNotEmpty &&
        name.value.text.isNotEmpty &&
        phone.value.text.isNotEmpty &&
        phone.value.text.length > 9 &&
        phone.value.text.isNumericOnly &&
        password.value.text.length > 5) {
      validationError.value = false;
      isLoading.value = true;

      try {
        String? imageURL;
        // Sign in the user
        if (profileImage.value.isNotEmpty) {
          imageURL = await Services().uploadFile(File(profileImage.value));
        }
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: userType.value == UserType.rider
                    ? "${phone.value.text}@gmail.com"
                    : email.value.text,
                password: password.value.text)
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
        // Navigate to the the appropriate page
        redirectUser();
      } catch (e) {
        isLoading.value = false;
        // Show an error message if any
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.white,
          textColor: Colors.black,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 14,
        );
      }
    } else {
      print('érror');
      validationError.value = true;
    }
  }

// Performs vendor specific validations
  bool vendorVallidation() {
    if ( userType.value != UserType.vendor) {
      return true;
    } else {
      if (email.value.text.isEmail &&location.value.text.isNotEmpty &&
          profileImage.value.isNotEmpty &&
          lat.value != 0.0 &&
          long.value != 0.0) {
        return true;
      } else {
        return false;
      }
    }
  }

// Performs rider specific validations
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

  bool customerValidation() {
    if (userType.value != UserType.customer) {
      return true;
    } else {
      if (email.value.text.isEmail) {
        return true;
      } else {
        return false;
      }
    }
  }

// Creates a new user
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
        numOfOrders: 0);
  }

// Redirects the user to the appropriate page based on thier user type
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
