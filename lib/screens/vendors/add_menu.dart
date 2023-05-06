import '../../utils/exports.dart';

// A page to add a new menu
class AddMenu extends StatefulWidget {
  const AddMenu({super.key});

  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  final controller = Get.put(NewMenuController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffffffff),
        // The app bar
        appBar: Constants.appBar("New Menu", false),
        body: Obx(
          () => controller.isLoading.value
              ? Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 60),
                  child: Column(
                    children: [
                      const Text(
                        "Please wait, we're uploading your files",
                        style: TextStyles.titleBlack,
                      ),
                      SizedBox(height: Constants.size.height * 0.2),
                      Center(
                        child: Obx(
                          () => CircularPercentIndicator(
                            radius: 60.0,
                            lineWidth: 13.0,
                            animation: true,
                            percent:
                                controller.currentUploadPercentage.value * 0.01,
                            center: Obx(
                              () => Text(
                                "${controller.currentUploadPercentage.value.toPrecision(1)} %",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),
                            footer: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Obx(
                                () => Text(
                                  "Uploading ${controller.currentUpload} of ${controller.totalUpload} files",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0),
                                ),
                              ),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Constants.appBarColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                          ),
                          child: Obx(
                            // The form field for the menu name
                            () => FormWidget(
                              textStyle: TextStyles.bodyBlack,
                              lableText: "Menu Name",
                              hintText: "Fufu and Groundnut Soup with Beef",
                              controller: controller.name.value,
                              errorStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                color: Colors.red,
                              ),
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

                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                          ),
                          child: Obx(
                            // The form field for the menu price
                            () => FormWidget(
                              textStyle: TextStyles.bodyBlack,
                              lableText: "Price",
                              hintText: "30.00",
                              controller: controller.price.value,
                              errorStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                color: Colors.red,
                              ),
                              validator: FormBuilderValidators.compose(
                                [
                                  if (controller.validationError.value) ...[
                                    FormBuilderValidators.required(
                                        errorText: "Price is required".tr),
                                    FormBuilderValidators.numeric(
                                        errorText: "Invalid price".tr),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0x1f000000),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                                color: const Color(0x4d9e9e9e), width: 1),
                          ),
                          // The form field for the menu description
                          child: Obx(
                            () => TextFormField(
                              controller: controller.description.value,
                              maxLines: null,
                              onChanged: (val) {
                                setState(() {
                                  controller.description.value.text = val;
                                  controller.description.value.selection =
                                      TextSelection.collapsed(
                                          offset: controller
                                              .description.value.text.length);
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter description",
                                hintStyle: TextStyle(color: Colors.black38),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // The validation error
                        Obx(
                          () => AnimatedCrossFade(
                            firstChild: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                  controller.description.value.text.isEmpty
                                      ? "Description is required".tr
                                      : "Description must be at least 10 characters"
                                          .tr,
                                  style: TextStyles.errorTextStyle),
                            ),
                            secondChild: const SizedBox.shrink(),
                            crossFadeState: controller.validationError.value &&
                                    (controller
                                            .description.value.text.isEmpty ||
                                        controller
                                                .description.value.text.length <
                                            10)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 300),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Upload images of the menu
                        Obx(
                          () => Text(
                              "Upload at least two images of the menu".tr,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: controller.validationError.value &&
                                          controller.getFiles().length < 2
                                      ? Colors.red
                                      : Colors.black)),
                        ),
                        const SizedBox(height: 8),
                        // The upload image button
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 50,
                          mainAxisSpacing: 16,
                          children: [
                            dottedContainer(0),
                            dottedContainer(1),
                            dottedContainer(2),
                            dottedContainer(3),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 30),
                          child: MaterialButton(
                            onPressed: () {
                              if (!controller.isLoading.value) {
                                controller.validateForms();
                              }
                            },
                            color: const Color(0xff91403e),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: const BorderSide(
                                  color: Color(0xff808080), width: 1),
                            ),
                            padding: const EdgeInsets.all(16),
                            textColor: const Color(0xffffffff),
                            height: Constants.size.width > 800 ? 60 : 40,
                            minWidth: MediaQuery.of(context).size.width,
                            // The add menu button
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    //padding: EdgeInsets.all(20),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 4,
                                    ),
                                  )
                                : const Text(
                                    "Add Menu",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }

// The function that handles permission and picks the image from the device
  onTapBtntf(int index) async {
    await FileManager.askForPermission(Permission.camera);
    await FileManager.askForPermission(Permission.storage);

    await FileManager().showModelSheetForImage(getImages: (value) async {
      setState(() {
        controller.media[index] = value!;
      });
    });
  }

// The function that returns  a dotted container for the picked image
  Widget dottedContainer(int index) {
    return DottedBorder(
      radius: const Radius.circular(16),
      color: Constants.appBarColor,
      dashPattern: const [8, 4],
      strokeWidth: 3,
      strokeCap: StrokeCap.butt,
      child: Obx(
        () => controller.media[index].isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(controller.media[index])),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      controller.media[index] = '';
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                    ),
                  ),
                ))
            : Center(
                child: IconButton(
                  onPressed: () {
                    onTapBtntf(index);
                  },
                  icon: const Icon(Icons.add_a_photo),
                ),
              ),
      ),
    );
  }
}
