import '../../utils/exports.dart';

// A page to login by email and password. Or phone number and password if the user is a rider
class LoginScreen extends StatefulWidget {
  final UserType usrType;
  const LoginScreen({super.key, required this.usrType});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // The controller for the password text fields
  TextEditingController password = TextEditingController();

  // The controller for the email text fields
  TextEditingController email = TextEditingController();

  // The controller for the phone text fields
  TextEditingController phone = TextEditingController();

  // Whether the user inputs are valid
  bool validationError = false;

  // Whether the loader is busy
  bool isLoading = false;

  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.appBarColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: Constants.size.height * 0.2),
              // App logo and and name
              const CircleAvatar(
                backgroundImage: AssetImage("assets/images/logo.png"),
                radius: 60,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 30),
                child: Text(appName, style: TextStyles.button),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sign In",
                  style: TextStyles.title,
                ),
              ),
              // The email text field if the user is a student or vendor and the phone number text field if the user is a rider
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                child: widget.usrType == UserType.rider
                    ? FormWidget(
                        controller: phone,
                        lableText: "Phone Number",
                        hintText: "0241234567",
                        validator: FormBuilderValidators.compose(
                          [
                            if (validationError) ...[
                              FormBuilderValidators.required(
                                  errorText: "Phone number is required".tr),
                              FormBuilderValidators.minLength(10,
                                  errorText: "Phone number is invalid".tr),
                              FormBuilderValidators.numeric(
                                  errorText: "Phone number is invalid".tr),
                            ],
                          ],
                        ),
                      )
                    : FormWidget(
                        controller: email,
                        hintText: "user@ashesi.edu.gh",
                        lableText: "Email",
                        validator: FormBuilderValidators.compose(
                          [
                            if (validationError) ...[
                              FormBuilderValidators.required(
                                  errorText: "Eamil is required".tr),
                              FormBuilderValidators.email(
                                  errorText: "Email is not valid".tr),
                            ],
                          ],
                        ),
                      ),
              ),
              // The password text field
              FormWidget(
                isPassword: true,
                obscureText: true,
                controller: password,
                lableText: "Password",
                validator: FormBuilderValidators.compose(
                  [
                    if (validationError) ...[
                      FormBuilderValidators.required(
                          errorText: "Password is required".tr),
                      FormBuilderValidators.minLength(6,
                          errorText: "Password is too short".tr),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // The login button
                    Expanded(
                      flex: 1,
                      child: MaterialButton(
                        onPressed: () {
                          validateForms();
                        },
                        color: const Color(0xffffffff),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(
                              color: Color(0xff9e9e9e), width: 1),
                        ),
                        padding: const EdgeInsets.all(16),
                        height: 40,
                        minWidth: 140,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                //padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 4,
                                ),
                              )
                            : const Text("Login",
                                style: TextStyles.buttonBlack),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    // The sign up button that takes the user to the sign up page
                    Expanded(
                      flex: 1,
                      child: MaterialButton(
                        onPressed: () {
                          Get.off(() => SignUp(
                                userType: widget.usrType,
                              ));
                        },
                        color: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.all(16),
                        height: 40,
                        minWidth: 140,
                        child: const Text("Sign Up", style: TextStyles.button),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Validates the phone number
  bool verifyPhone() {
    if (widget.usrType != UserType.rider) {
      return true;
    } else {
      if (phone.text.isNotEmpty &&
          phone.text.length > 9 &&
          phone.text.isNumericOnly) {
        return true;
      } else {
        return false;
      }
    }
  }

// Validates the email
  bool verifyEmail() {
    if (widget.usrType == UserType.rider) {
      return true;
    } else {
      if (email.text.isNotEmpty && email.text.isEmail) {
        return true;
      } else {
        return false;
      }
    }
  }

  // Validates the user inputs and logs the user in
  void validateForms() async {
    // Check if the user inputs are valid
    if (verifyPhone() &&
        verifyEmail() &&
        password.text.isNotEmpty &&
        password.text.length > 5) {
      setState(() {
        validationError = false;
        isLoading = true;
      });
      try {
        // // Sign in the user
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: widget.usrType == UserType.rider
                    ? "${phone.text}@gmail.com"
                    : email.text,
                password: password.text)
            .then((value) async {
          await Services.getUser(value.user!.uid);
          setState(() {
            isLoading = false;
          });
          controller.redirectUser();
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
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
      setState(() {
        validationError = true;
      });
    }
  }
}
