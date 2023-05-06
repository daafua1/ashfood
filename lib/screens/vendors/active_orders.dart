import 'package:ashfood/utils/exports.dart';

// A page to display active orders for vendors
class ActivieOrdersVendors extends StatefulWidget {
  const ActivieOrdersVendors({super.key});

  @override
  State<ActivieOrdersVendors> createState() => _ActivieOrdersVendorsState();
}

class _ActivieOrdersVendorsState extends State<ActivieOrdersVendors> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> orders = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Constants.appBar(
          'Active Orders',
          false,
        ),
        body: _buildOrderList());
  }

// A method to build the list of orders
  Widget _buildOrderList() {
    return StreamBuilder(
      stream: Services().getOrdersVendros(user.value.id!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Future.delayed(Duration.zero, () {
            setState(() {
              orders = snapshot.data!.docs;
            });
          });

          if (orders.isNotEmpty) {
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final item = UserOrder.fromJson(orders[index].data());
                return OrderContainer(
                  userType: UserType.vendor,
                  order: item,
                );
              },
            );
          } else {
            return const Center(
              child: Text('No Items Found'),
            );
          }
        } else {
          return const Center(
            child: Text('No Items Found'),
          );
        }
      },
    );
  }
}
