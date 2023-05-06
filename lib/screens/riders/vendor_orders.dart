import '../../utils/exports.dart';

// A page to show the orders for a rider from a vendor
class VendorOrders extends StatefulWidget {
  final AppUser vendor;

  const VendorOrders({super.key, required this.vendor});

  @override
  State<VendorOrders> createState() => _VendorOrdersState();
}

class _VendorOrdersState extends State<VendorOrders> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> orders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      // The app bar
      appBar: Constants.appBar("${widget.vendor.name!}'s Orders", false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A stream builder to show the the orders
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
                            child: OrderContainer(
                                order: order, userType: UserType.rider),
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
    );
  }
}
