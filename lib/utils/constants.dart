import 'package:ashfood/widgets/cart_button.dart';

import '../models/app_user.dart';
import 'exports.dart';

class Constants {
  static Size size = Get.size;

  static const appBarColor = Color(0xff91413f);

  static AppBar appBar(String title, bool forCustomer) => AppBar(
        elevation: 4,
        centerTitle: true,
        backgroundColor: Constants.appBarColor,
        title: Text(title, style: TextStyles.title),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
            size: 30,
          ),
        ),
        actions: [if (forCustomer) const CartButton()],
      );
}

const String appName = "AshFood";
final user = AppUser().obs;

enum UserType { customer, vendor, rider }