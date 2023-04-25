import 'dart:developer';
import 'dart:io';

import 'package:ashfood/models/app_user.dart';
import 'package:ashfood/models/order.dart';
import 'package:ashfood/widgets/containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/exports.dart';
import '../../utils/services.dart';
import '../../widgets/vendor_drawer.dart';

// A page to show the feed of posts
class VendorOrders extends StatefulWidget {
  final AppUser vendor;

  const VendorOrders({super.key, required this.vendor});

  @override
  State<VendorOrders> createState() => _VendorOrdersState();
}

class _VendorOrdersState extends State<VendorOrders> {
  List<QueryDocumentSnapshot<Map<String,dynamic>>> orders = [];
  
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
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        backgroundColor: Constants.appBarColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
         widget.vendor.name! + "'s Orders",
          style: TextStyles.title,
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      // A stream builder to show the posts in real time
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Expanded(
              child: StreamBuilder(
                  stream: Services().getRiderVendor(user.value.id!, widget.vendor.id!),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      
                      orders = snapshot.data!.docs;
                      
                    }
                    if (orders.isNotEmpty) {
                      return ListView.builder(
                        itemCount:orders.length,
                        itemBuilder: (_, index) {
                          final order =
                              UserOrder.fromJson(orders[index].data());
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: OrderContainer(order: order,forRiders: true ),
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
