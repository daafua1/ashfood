import 'package:ashfood/screens/students/active_orders.dart';
import 'package:ashfood/screens/vendors/add_menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/exports.dart';

class VendorDrawer extends StatelessWidget {
  final String userType;
  const VendorDrawer({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
              padding: const EdgeInsets.only(top: 80, bottom: 20),
              decoration: const BoxDecoration(color: Constants.appBarColor),
              child: Column(
                children: [
                  Obx(
                    () => CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        user.value.profileImage != null &&
                                user.value.profileImage!.isNotEmpty
                            ? user.value.profileImage!
                            : "https://firebasestorage.googleapis.com/v0/b/daafua-ashesi-social.appspot.com/o/9-250x250.jpg?alt=media&token=5a0798b0-f565-4e63-99cc-eb52e0f3167c",
                      ),
                      radius: 60,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Obx(
                    () => Text(
                      user.value.name!,
                      style: TextStyles.button,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 30,
                    width: 130,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white),
                    child: Center(
                      child: Obx(
                        () => Text(
                          user.value.phoneNumber!,
                          style: TextStyles.bodyBlack,
                        ),
                      ),
                    ),
                  )
                ],
              )),
          ListTile(
            onTap: () {
              Get.back();
              userType == 'customer'
                  ? Get.to(() => const ActivieOrdersStudents())
                  : null;
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            title: const Text(
              "Active Orders",
              style: TextStyles.buttonBlack,
              textAlign: TextAlign.start,
            ),
            selectedTileColor: const Color(0x42000000),
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Color(0xff000000), size: 24),
          ),
          const Divider(
            color: Color(0x4d9e9e9e),
            height: 16,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          ListTile(
            onTap: () {
              Get.back();
              //Get.to(() => const EditProfile());
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            title: const Text(
              "Past Orders",
              style: TextStyles.buttonBlack,
              textAlign: TextAlign.start,
            ),
            selectedTileColor: const Color(0x42000000),
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Color(0xff000000), size: 24),
          ),
          const Divider(
            color: Color(0x4d9e9e9e),
            height: 16,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          userType == UserType.vendor.name
              ? ListTile(
                  onTap: () {
                    Get.back();
                    Get.to(() => const AddMenu());
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  title: const Text(
                    "Add Menu",
                    style: TextStyles.buttonBlack,
                    textAlign: TextAlign.start,
                  ),
                  selectedTileColor: const Color(0x42000000),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Color(0xff000000), size: 24),
                )
              : const SizedBox.shrink(),
          userType == UserType.vendor.name
              ? const Divider(
                  color: Color(0x4d9e9e9e),
                  height: 16,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                )
              : const SizedBox.shrink(),
          // ListTile(
          //   onTap: () {
          //     Get.back();
          //     // Get.to(() => const VeiwProfile(
          //     //       withID: false,
          //     //     ));
          //   },
          //   contentPadding:
          //       const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          //   title: const Text(
          //     "Edit Profile",
          //     style: TextStyles.buttonBlack,
          //     textAlign: TextAlign.start,
          //   ),
          //   selectedTileColor: const Color(0x42000000),
          //   trailing: const Icon(Icons.arrow_forward_ios,
          //       color: Color(0xff000000), size: 24),
          // ),
          // const Divider(
          //   color: Color(0x4d9e9e9e),
          //   height: 16,
          //   thickness: 1,
          //   indent: 0,
          //   endIndent: 0,
          // ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
            child: MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Get.offAll(() => LoginScreen(
                    usrType: user.value.userType == UserType.customer.name
                        ? UserType.customer
                        : user.value.userType == UserType.vendor.name
                            ? UserType.vendor
                            : UserType.rider));
              },
              color: Constants.appBarColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              textColor: Colors.white,
              height: 40,
              minWidth: MediaQuery.of(context).size.width,
              child: const Text(
                "Log out",
                style: TextStyles.button,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
