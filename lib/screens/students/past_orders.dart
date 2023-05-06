import 'package:ashfood/utils/exports.dart';

// A page to display past orders for students
class PastOrdersStudents extends StatefulWidget {
  const PastOrdersStudents({super.key});

  @override
  State<PastOrdersStudents> createState() => _PastOrdersStudentsState();
}

class _PastOrdersStudentsState extends State<PastOrdersStudents> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> orders = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Constants.appBar(
          'Past Orders',
          true,
        ),
        body: _buildOrderList());
  }

// A method to build the list of orders
  Widget _buildOrderList() {
    return StreamBuilder(
      stream: Services().getPastOrdersStudents(user.value.id!),
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
                  userType: UserType.customer,
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
