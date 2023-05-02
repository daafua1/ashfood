import 'package:ashfood/models/app_user.dart';
import 'package:ashfood/models/cart_item.dart';
import 'package:ashfood/screens/riders/order_details_riders.dart';
import 'package:ashfood/screens/riders/vendor_orders.dart';
import 'package:ashfood/screens/students/vendor_menus.dart';
import 'package:ashfood/screens/vendors/order_details_vendor.dart';
import 'package:ashfood/utils/exports.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/menu.dart';
import '../models/order.dart';
import '../screens/students/menu_details.dart';
import '../screens/students/order_details.dart';

class MenuContainer extends StatelessWidget {
  final Menu menu;
  final bool forVendor;
  const MenuContainer({super.key, required this.menu, required this.forVendor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => MenuDetails(menu: menu)),
      child: Container(
          width: Constants.size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey, width: 2)),
          //padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(menu.media![0]),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0,12,12,0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      menu.name!,
                      style: TextStyles.buttonBlack,
                    )),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      "GHS ${menu.price.toString()}",
                      style: TextStyles.buttonBlack,
                    ),
                  ],
                ),
              ),
              forVendor
                  ? IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("menus")
                            .doc(menu.id)
                            .delete();
                      },
                      icon: Icon(Icons.delete))
                  : SizedBox.shrink()
            ],
          )),
    );
  }
}

class VendorContainer extends StatelessWidget {
  final AppUser vendor;
  final bool forRiders;
  const VendorContainer(
      {super.key, required this.vendor, required this.forRiders});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => forRiders
          ? VendorOrders(vendor: vendor)
          : VendorMenus(vendor: vendor)),
      child: Container(
        width: Constants.size.width,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black,
          image: DecorationImage(
              opacity: 0.6,
              image: CachedNetworkImageProvider(
                vendor.profileImage!,
              ),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Text(
            vendor.name!,
            style: TextStyles.title,
          ),
        ),
      ),
    );
  }
}

class CartItemContainer extends StatefulWidget {
  final CartItem cartItem;
  const CartItemContainer({super.key, required this.cartItem});

  @override
  State<CartItemContainer> createState() => _CartItemContainerState();
}

class _CartItemContainerState extends State<CartItemContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => MenuDetails(menu: widget.cartItem.menu!)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        widget.cartItem.menu!.media![0],
                      ),
                      fit: BoxFit.cover)),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      widget.cartItem.menu!.name!,
                      style: TextStyles.bodyBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "GHS ${widget.cartItem.menu!.price.toString()}",
                    style: TextStyles.buttonBlack,
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  if (widget.cartItem.quantity! > 1) {
                    FirebaseFirestore.instance
                        .collection('cart')
                        .doc(widget.cartItem.id)
                        .update({'quantity': widget.cartItem.quantity! - 1});
                  } else if (widget.cartItem.quantity == 1) {
                    FirebaseFirestore.instance
                        .collection('cart')
                        .doc(widget.cartItem.id)
                        .delete();
                  }
                },
                icon: const Icon(Icons.remove)),
            Text(
              widget.cartItem.quantity.toString(),
              style: TextStyles.buttonBlack,
            ),
            IconButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('cart')
                      .doc(widget.cartItem.id)
                      .update({'quantity': widget.cartItem.quantity! + 1});
                },
                icon: const Icon(Icons.add)),
          ],
        ),
      ),
    );
  }
}

class OrderContainer extends StatefulWidget {
  final UserOrder order;
  final UserType userType;
  const OrderContainer(
      {super.key, required this.order, required this.userType});

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.userType == UserType.rider) {
          Get.to(() => OrderDetailsRiders(order: widget.order));
        } else if (widget.userType == UserType.customer) {
          Get.to(() => OrderDetails(order: widget.order));
        } else if (widget.userType == UserType.vendor) {
          Get.to(() => OrderDetailsVendor(order: widget.order));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        widget.order.menu!.media![0],
                      ),
                      fit: BoxFit.cover)),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      widget.order.menu!.name!,
                      style: TextStyles.bodyBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "GHS ${widget.order.menu!.price.toString()}",
                        style: TextStyles.buttonBlack,
                      ),
                      widget.userType == UserType.vendor &&
                              widget.order.isServed == true
                          ? Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                'served',
                                style: TextStyle(
                                    color: Constants.appBarColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              widget.order.quantity.toString(),
              style: TextStyles.buttonBlack,
            ),
          ],
        ),
      ),
    );
  }
}
