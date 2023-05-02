import 'dart:io';

import 'package:ashfood/models/app_user.dart';
import 'package:ashfood/models/order.dart';
import 'package:ashfood/widgets/containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/exports.dart';
import '../../utils/services.dart';

// A page to show the feed of posts
class VendorOrders extends StatefulWidget {
  final AppUser vendor;

  const VendorOrders({super.key, required this.vendor});

  @override
  State<VendorOrders> createState() => _VendorOrdersState();
}

class _VendorOrdersState extends State<VendorOrders> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> orders = [];

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      Services().registerNotification();
      Services().configLocalNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      // The app bar
      appBar: Constants.appBar("${widget.vendor.name!}'s Orders", false),
      // A stream builder to show the posts in real time
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: Services()
                      .getRiderVendor(user.value.id!, widget.vendor.id!),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      orders = snapshot.data!.docs;
                    }
                    if (orders.isNotEmpty) {
                      return ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (_, index) {
                          final order =
                              UserOrder.fromJson(orders[index].data());
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child:
                                OrderContainer(order: order, userType: UserType.rider),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("No orders yet"));
                    }
                  }),
            ),
            
          ],
        ),
      ),
      // The drawer at the homepage
    );
  }
}


