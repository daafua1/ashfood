import '../../utils/exports.dart';

// A screen that displays the homepage of the rider
class RiderHomepage extends StatefulWidget {
  const RiderHomepage({super.key});

  @override
  State<RiderHomepage> createState() => _RiderHomepageState();
}

class _RiderHomepageState extends State<RiderHomepage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> orders = [];
  List<Map<String, dynamic>> ordersNew = [];

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
        title: const Text(
          'Upcoming Deliveries',
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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A stream builder to show the list of upcoming rides of the rider.
            // The list is sorted by the vendor name
            Expanded(
              child: StreamBuilder(
                  stream: Services().getRiderOrders(user.value.id!),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      orders = snapshot.data!.docs;
                      for (var element in orders) {
                        final orderDoc = element.data();
                        if (ordersNew.any((element1) =>
                            element1['vendorId'] == orderDoc['vendorId'])) {
                        } else {
                          ordersNew.add(orderDoc);
                        }
                      }
                    }
                    if (orders.isNotEmpty) {
                      return ListView.builder(
                        itemCount: ordersNew.length,
                        itemBuilder: (_, index) {
                          final order = UserOrder.fromJson(ordersNew[index]);
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: VendorContainer(
                                vendor: order.menu!.vendor!, forRiders: true),
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
      drawer: AppDrawer(
        userType: user.value.userType!,
      ),
    );
  }
}
