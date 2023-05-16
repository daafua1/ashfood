import 'package:ashfood/utils/exports.dart';

// A checkout page to display the list of items in the cart
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> cart = [];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.appBar(
        'Checkout',
        false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Get.to(() => const SelectLocation());
              },
              child: Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(
                    width: 20,
                  ),
                  // A text widget to display the user's location
                  Expanded(
                    child: Text(
                      user.value.location != null &&
                              user.value.location!.isNotEmpty
                          ? user.value.location!
                          : "Add Delivery Location",
                      style: TextStyles.buttonBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // A widget to display the list of items in the cart
          Expanded(child: _buildCartList()),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: floatingButtons(),
    );
  }

  // A method to build the list of items in the cart
  Widget _buildCartList() {
    return StreamBuilder(
        stream: Services().getCart(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Future.delayed(Duration.zero, () {
              setState(() {
                cart = snapshot.data!.docs;
              });
            });

            if (cart.isNotEmpty) {
              return ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final item = CartItem.fromJson(cart[index].data());
                  return CartItemContainer(
                    cartItem: item,
                  );
                },
              );
            } else {
              return const Center(child: Text('No Items Found'));
            }
          } else {
            return const Center(child: Text('No Items Found'));
          }
        });
  }

// The floating buttons to display the total price of items in the cart and the checkout button
  floatingButtons() {
    return cart.isNotEmpty
        ? Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            color: Colors.white,
            height: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // !Utilities.shouldOrder()
                //     ? Padding(
                //         padding: const EdgeInsets.only(bottom: 5.0),
                //         child: Text(
                //           Utilities.orderAt(),
                //           style: TextStyles.buttonBlack,
                //         ),
                //       )
                //     : const SizedBox.shrink(),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (
                              // check if the user has added a location and the order time is valid
                            //  Utilities.shouldOrder() &&
                                  user.value.location != null &&
                                  user.value.location!.isNotEmpty) {
                            // make payment through paystack
                            PayWithPayStack().now(
                                context: context,
                                secretKey:
                                    "sk_test_969269801c19e5659cfb5dc7f9e0049ead74f4e1",
                                customerEmail: user.value.email!,
                                reference: DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString(),
                                currency: "GHS",
                                amount: "${calculatePrice()}00",
                                transactionCompleted: () {
                                  placeOrder();
                                  Fluttertoast.showToast(
                                      msg: 'Transaction Successful',
                                      toastLength: Toast.LENGTH_LONG);
                                },
                                transactionNotCompleted: () {
                                  Fluttertoast.showToast(
                                      msg: 'Transaction Failed',
                                      toastLength: Toast.LENGTH_LONG);
                                });
                          } else {
                            if (user.value.location != null &&
                                user.value.location!.isNotEmpty) {
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Add delivery location",
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Utilities.shouldOrder()
                                  ? Constants.appBarColor
                                  : Constants.appBarColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16)),
                          child: Center(
                            child: isLoading
                                ? const SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 4,
                                    ),
                                  )
                                : const Text(
                                    'Checkout',
                                    style: TextStyles.button,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // A text widget to display the total price of items in the cart
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: Constants.appBarColor,
                          borderRadius: BorderRadius.circular(16)),
                      child: Center(
                        child: Text(
                          'GHS ${calculatePrice()}',
                          style: TextStyles.button,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

// A method to calculate the total price of items in the cart
  String calculatePrice() {
    num price = 0;
    for (var element in cart) {
      price = price +
          (element.data()['menu']['price'] * element.data()['quantity']);
    }
    return price.toInt().toString();
  }

// A method to place an order
  void placeOrder() async {
    setState(() {
      isLoading = true;
    });

    final riders = await Services().getRiders();

    AppUser? rider;

    // loop through the items in the cart and place an order for each item
    for (int i = 0; i < cart.length; i++) {
      if (riders.isNotEmpty) {
        rider = AppUser.fromJson(riders[0].data());
      }
      final docReference = FirebaseFirestore.instance
          .collection('orders')
          .doc(DateTime.now().millisecondsSinceEpoch.toString() + i.toString());
      final cartItem = CartItem.fromJson(cart[i].data());
      final order = UserOrder(
        menu: cartItem.menu,
        quantity: cartItem.quantity,
        id: docReference.id,
        user: user.value,
        userId: user.value.id,
        rider: rider,
        riderId: rider?.id,
        status: 'pending',
        isServed: false,
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        vendorId: cartItem.menu!.vendorId,
      );

      // save the order to the database
      FirebaseFirestore.instance.runTransaction(
        (transaction) async => transaction.set(
          docReference,
          order.toJson(),
        ),
      );
      // update the number of orders for the rider
      FirebaseFirestore.instance.collection('users').doc(rider!.id!).update({
        'numOfOrders': rider.numOfOrders! + 1,
      });
      // send notifications to the vendor, user and rider
      if (order.menu!.vendor!.fcmToken != null) {
        Services().sendNotification(
            token: order.menu!.vendor!.fcmToken!,
            content: "You have a new order",
            heading: order.menu!.name!);
      }
      if (order.user!.fcmToken != null) {
        Services().sendNotification(
          token: order.user!.fcmToken!,
          content: "Your order has been placed",
          heading: order.menu!.name!,
        );
      }
      if (order.rider!.fcmToken != null) {
        Services().sendNotification(
          token: order.rider!.fcmToken!,
          content: "You have a new ride",
          heading: order.menu!.vendor!.name!,
        );
      }
    }
    // delete the items in the cart
    for (var element in cart) {
      FirebaseFirestore.instance.collection('cart').doc(element.id).delete();
    }

    setState(() {
      isLoading = false;
    });
    // show a toast to indicate that the order has been placed
    Fluttertoast.showToast(
      msg: 'Orders Placed successfully',
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
