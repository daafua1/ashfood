import '../../utils/exports.dart';

// A page for the user to sign up
class SignUp extends StatefulWidget {
  final UserType userType;
  const SignUp({super.key, required this.userType});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final controller = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    controller.userType.value = widget.userType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.appBarColor,
      // The app bar
      appBar: AppBar(
        backgroundColor: Constants.appBarColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Register",
          style: TextStyles.title,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: Constants.size.height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Stack(
                  children: [
                    // The user's profile image
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 60,
                      backgroundImage: controller.profileImage.isEmpty
                          ? null
                          : FileImage(File(controller.profileImage.value))
                              as ImageProvider<Object>,
                    ),
                    Positioned(
                      bottom: -10,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Constants.appBarColor),
                        child: IconButton(
                          iconSize: 30,
                          onPressed: () {
                            // This function is called when the user taps on the camera icon to change the profile image
                            pickFile();
                          },
                          icon: const Icon(
                            Icons.photo_camera_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // An error message if the user does not select a profile image. Only shown if the user is a rider or a vendor
              Obx(
                () => AnimatedCrossFade(
                  crossFadeState:
                      controller.userType.value != UserType.customer &&
                              controller.validationError.value &&
                              controller.profileImage.isEmpty
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 500),
                  firstChild: const Text("Image cannot be empty",
                      style: TextStyles.errorTextStyle),
                  secondChild: const SizedBox.shrink(),
                ),
              ),

              // The name text field
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Obx(
                  () => FormWidget(
                    controller: controller.name.value,
                    hintText: "abc Cafeteria",
                    lableText: "Name",
                    validator: FormBuilderValidators.compose(
                      [
                        if (controller.validationError.value) ...[
                          FormBuilderValidators.required(
                              errorText: "Name is required".tr),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              // The email text field
              widget.userType == UserType.rider
                  ? const SizedBox(
                      height: 16,
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 0),
                      child: Obx(
                        () => FormWidget(
                          controller: controller.email.value,
                          hintText: "user@ashesi.edu.gh",
                          lableText: "Email",
                          validator: FormBuilderValidators.compose(
                            [
                              if (controller.validationError.value) ...[
                                FormBuilderValidators.required(
                                    errorText: "Eamil is required".tr),
                                FormBuilderValidators.email(
                                    errorText: "Email is not valid".tr),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
              // The student id text field
              Obx(
                () => FormWidget(
                  controller: controller.password.value,
                  lableText: "Password",
                  obscureText: true,
                  isPassword: true,
                  validator: FormBuilderValidators.compose(
                    [
                      if (controller.validationError.value) ...[
                        FormBuilderValidators.required(
                            errorText: "Password is required".tr),
                        FormBuilderValidators.minLength(6,
                            errorText: "Password is too short".tr),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // The phone number text field
              Obx(
                () => FormWidget(
                  controller: controller.phone.value,
                  lableText: "Phone Number",
                  hintText: "0241234567",
                  validator: FormBuilderValidators.compose(
                    [
                      if (controller.validationError.value) ...[
                        FormBuilderValidators.required(
                            errorText: "Phone number is required".tr),
                        FormBuilderValidators.minLength(10,
                            errorText: "Phone number is invalid".tr),
                      ],
                    ],
                  ),
                ),
              ),

              // The location text field. Only shown if the user is a vendor
              widget.userType == UserType.vendor
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const SelectLocation());
                        },
                        child: Obx(
                          () => FormWidget(
                            enabled: false,
                            controller: controller.location.value,
                            lableText: "Location",
                            validator: FormBuilderValidators.compose(
                              [
                                if (controller.validationError.value) ...[
                                  FormBuilderValidators.required(
                                      errorText: "Location is required".tr),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // The sign up button
                    Expanded(
                      flex: 1,
                      child: Obx(
                        () => MaterialButton(
                          onPressed: () {
                            controller.validateForms();
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
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  //padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 4,
                                  ),
                                )
                              : const Text("Sign Up",
                                  style: TextStyles.buttonBlack),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    // The login button that takes the user to the login page
                    Expanded(
                      flex: 1,
                      child: MaterialButton(
                        onPressed: () {
                          Get.off(() => LoginScreen(
                                usrType: widget.userType,
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
                        child: const Text("Login", style: TextStyles.button),
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

  // Function to handle permissions and show the image picker
  pickFile() async {
    await FileManager.askForPermission(Permission.camera);
    await FileManager.askForPermission(Permission.storage);

    await FileManager().showModelSheetForImage(getImages: (value) async {
      setState(() {
        controller.profileImage.value = value!;
      });
    });
  }
}
