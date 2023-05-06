import 'package:ashfood/utils/exports.dart';

// A screen that displays the past orders of the rider
class PastOrdersRider extends StatefulWidget {
  const PastOrdersRider({super.key});

  @override
  State<PastOrdersRider> createState() => _PastOrdersRiderState();
}

class _PastOrdersRiderState extends State<PastOrdersRider> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> orders = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // App bar
        appBar: Constants.appBar(
          'Past Orders',
          false,
        ),
        body: _buildOrderList());
  }

// A method that builds the list of past orders
  Widget _buildOrderList() {
    return StreamBuilder(
      stream: Services().getPastOrdersRiders(user.value.id!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Future.delayed(Duration.zero, () {
            setState(() {
              orders = snapshot.data!.docs;
            });
          });

          if (orders.isNotEmpty) {
            // A list of past orders
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final item = UserOrder.fromJson(orders[index].data());
                return OrderContainer(
                  userType: UserType.rider,
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
